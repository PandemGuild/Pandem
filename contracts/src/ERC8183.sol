// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {IERC20} from "openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";
import {SafeERC20} from "openzeppelin-contracts/contracts/token/ERC20/utils/SafeERC20.sol";
import {IERC8183, IACPHook} from "./IERC8183.sol";

/// @title ERC8183 Contract
/// @dev A basic implementation of the ERC-8183 standard
contract ERC8183 is IERC8183 {
    using SafeERC20 for IERC20;

    enum State {
        Open,
        Funded,
        Submitted,
        Completed,
        Rejected,
        Expired
    }

    struct Job {
        address client;
        address provider;
        address evaluator;
        address hook;
        uint256 budget;
        uint256 expiredAt;
        State state;
        string description;
        bytes32 deliverable;
    }

    IERC20 public immutable paymentToken;
    uint256 public nextJobId;
    mapping(uint256 => Job) public jobs;

    event JobCreated(uint256 indexed jobId, address indexed client, address indexed provider, address evaluator);
    event JobFunded(uint256 indexed jobId, uint256 amount);
    event JobSubmitted(uint256 indexed jobId, bytes32 deliverable);
    event JobCompleted(uint256 indexed jobId, bytes32 reason);
    event JobRejected(uint256 indexed jobId, bytes32 reason);
    event JobRefunded(uint256 indexed jobId);

    constructor(address _paymentToken) {
        paymentToken = IERC20(_paymentToken);
        nextJobId = 1;
    }

    function _callHookBefore(uint256 jobId, bytes4 selector, bytes calldata data) internal {
        address hook = jobs[jobId].hook;
        if (hook != address(0)) {
            IACPHook(hook).beforeAction(jobId, selector, data);
        }
    }

    function _callHookAfter(uint256 jobId, bytes4 selector, bytes calldata data) internal {
        address hook = jobs[jobId].hook;
        if (hook != address(0)) {
            IACPHook(hook).afterAction(jobId, selector, data);
        }
    }

    function createJob(
        address provider,
        address evaluator,
        uint256 expiredAt,
        string calldata description,
        address hook
    ) external override returns (uint256) {
        uint256 jobId = nextJobId++;

        jobs[jobId] = Job({
            client: msg.sender,
            provider: provider,
            evaluator: evaluator,
            hook: hook,
            budget: 0,
            expiredAt: expiredAt,
            state: State.Open,
            description: description,
            deliverable: bytes32(0)
        });

        emit JobCreated(jobId, msg.sender, provider, evaluator);
        return jobId;
    }

    function setProvider(uint256 jobId, address provider, bytes calldata optParams) external override {
        Job storage job = jobs[jobId];
        require(msg.sender == job.client, "Only client");
        require(job.state == State.Open, "Job not open");

        bytes4 selector = this.setProvider.selector;
        _callHookBefore(jobId, selector, msg.data);
        job.provider = provider;
        _callHookAfter(jobId, selector, msg.data);
    }

    function setBudget(uint256 jobId, uint256 amount, bytes calldata optParams) external override {
        Job storage job = jobs[jobId];
        require(msg.sender == job.client || msg.sender == job.provider, "Unauthorized");
        require(job.state == State.Open, "Job not open");

        bytes4 selector = this.setBudget.selector;
        _callHookBefore(jobId, selector, msg.data);
        job.budget = amount;
        _callHookAfter(jobId, selector, msg.data);
    }

    function fund(uint256 jobId, uint256 expectedBudget, bytes calldata optParams) external override {
        Job storage job = jobs[jobId];
        require(msg.sender == job.client, "Only client");
        require(job.state == State.Open, "Job not open");
        require(job.budget > 0, "Budget not set");
        require(job.budget == expectedBudget, "Budget mismatch");

        bytes4 selector = this.fund.selector;
        _callHookBefore(jobId, selector, msg.data);

        job.state = State.Funded;
        paymentToken.safeTransferFrom(msg.sender, address(this), expectedBudget);

        _callHookAfter(jobId, selector, msg.data);
        emit JobFunded(jobId, expectedBudget);
    }

    function submit(uint256 jobId, bytes32 deliverable, bytes calldata optParams) external override {
        Job storage job = jobs[jobId];
        require(msg.sender == job.provider, "Only provider");
        require(job.state == State.Funded, "Job not funded");

        bytes4 selector = this.submit.selector;
        _callHookBefore(jobId, selector, msg.data);

        job.state = State.Submitted;
        job.deliverable = deliverable;

        _callHookAfter(jobId, selector, msg.data);
        emit JobSubmitted(jobId, deliverable);
    }

    function complete(uint256 jobId, bytes32 reason, bytes calldata optParams) external override {
        Job storage job = jobs[jobId];
        require(msg.sender == job.evaluator, "Only evaluator");
        require(job.state == State.Submitted || job.state == State.Funded, "Invalid state");

        bytes4 selector = this.complete.selector;
        _callHookBefore(jobId, selector, msg.data);

        job.state = State.Completed;
        paymentToken.safeTransfer(job.provider, job.budget);

        _callHookAfter(jobId, selector, msg.data);
        emit JobCompleted(jobId, reason);
    }

    function reject(uint256 jobId, bytes32 reason, bytes calldata optParams) external override {
        Job storage job = jobs[jobId];

        if (job.state == State.Open) {
            require(msg.sender == job.client, "Only client can reject open job");
            job.state = State.Rejected;
            emit JobRejected(jobId, reason);
            return;
        }

        require(msg.sender == job.evaluator, "Only evaluator");
        require(job.state == State.Funded || job.state == State.Submitted, "Invalid state");

        bytes4 selector = this.reject.selector;
        _callHookBefore(jobId, selector, msg.data);

        job.state = State.Rejected;
        paymentToken.safeTransfer(job.client, job.budget);

        _callHookAfter(jobId, selector, msg.data);
        emit JobRejected(jobId, reason);
    }

    function claimRefund(uint256 jobId) external override {
        Job storage job = jobs[jobId];
        require(block.timestamp > job.expiredAt, "Not expired");
        require(job.state == State.Funded || job.state == State.Submitted, "Invalid state");

        job.state = State.Expired;
        paymentToken.safeTransfer(job.client, job.budget);

        emit JobRefunded(jobId);
    }
}
