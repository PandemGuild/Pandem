// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Test, console} from "forge-std/Test.sol";
import {ERC8183} from "../src/ERC8183.sol";
import {AtomicHandoverHook} from "../src/AtomicHandoverHook.sol";
import {ERC20} from "openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";

contract MockToken is ERC20 {
    constructor() ERC20("MockToken", "MTK") {
        _mint(msg.sender, 1000000 * 10**18);
    }

    function mint(address to, uint256 amount) external {
        _mint(to, amount);
    }
}

contract AtomicHandoverTest is Test {
    ERC8183 public jobContract;
    AtomicHandoverHook public hook;
    MockToken public token;

    address public client = address(0x1);
    address public provider = address(0x2);
    address public evaluator = address(0x3);

    uint256 public constant BUDGET = 10000 * 10**18;
    uint256 public constant COLLATERAL = 500 * 10**18;

    bytes32 public constant AMICABLE_REJECTION_REASON = keccak256("AMICABLE_CANCELLATION");
    bytes32 public constant HOSTILE_REJECTION_REASON = keccak256("SPAM_SUBMISSION");
    bytes32 public constant DELIVERABLE_HASH = keccak256("encrypted_codebase_ipfs_hash");

    event PayloadReadyForDecryption(uint256 indexed jobId, address indexed client, address indexed provider, bytes32 deliverableHash);

    function setUp() public {
        token = new MockToken();
        jobContract = new ERC8183(address(token));
        hook = new AtomicHandoverHook(address(token), address(jobContract));

        // Fund client and provider
        token.mint(client, BUDGET * 2);
        token.mint(provider, COLLATERAL * 2);

        // Approve hook and job contract
        vm.prank(client);
        token.approve(address(jobContract), type(uint256).max);

        vm.prank(provider);
        token.approve(address(hook), type(uint256).max);
    }

    function test_SuccessfulHandoverWithCollateral() public {
        // 1. Client creates Job
        vm.prank(client);
        uint256 jobId = jobContract.createJob(provider, evaluator, block.timestamp + 7 days, "Fix SQL Injection", address(hook));

        // 2. Client sets budget and Configures Collateral
        vm.startPrank(client);
        jobContract.setBudget(jobId, BUDGET, "");
        hook.configureCollateral(jobId, COLLATERAL);
        vm.stopPrank();

        // 3. Client Funds the Job
        // The hook intercepts this and pulls COLLATERAL from the provider.
        uint256 providerBalBefore = token.balanceOf(provider);

        vm.prank(client);
        jobContract.fund(jobId, BUDGET, "");

        assertEq(token.balanceOf(address(jobContract)), BUDGET);
        assertEq(token.balanceOf(address(hook)), COLLATERAL);
        assertEq(token.balanceOf(provider), providerBalBefore - COLLATERAL);

        // 4. Provider Submits work
        vm.prank(provider);
        jobContract.submit(jobId, DELIVERABLE_HASH, "");

        // 5. Evaluator Completes (Client Approves)
        vm.expectEmit(true, true, true, true);
        emit PayloadReadyForDecryption(jobId, client, provider, DELIVERABLE_HASH);

        vm.prank(evaluator);
        jobContract.complete(jobId, bytes32("APPROVED"), "");

        // 6. Verify Settlement
        // Provider gets their collateral back PLUS the budget
        assertEq(token.balanceOf(provider), providerBalBefore + BUDGET);
        assertEq(token.balanceOf(address(hook)), 0);
        assertEq(token.balanceOf(address(jobContract)), 0);
    }

    function test_AmicableCancellation() public {
        vm.prank(client);
        uint256 jobId = jobContract.createJob(provider, evaluator, block.timestamp + 7 days, "Fix Bug", address(hook));

        vm.startPrank(client);
        jobContract.setBudget(jobId, BUDGET, "");
        hook.configureCollateral(jobId, COLLATERAL);
        jobContract.fund(jobId, BUDGET, "");
        vm.stopPrank();

        uint256 providerBalAfterFund = token.balanceOf(provider);
        uint256 clientBalAfterFund = token.balanceOf(client);

        // Provider submits
        vm.prank(provider);
        jobContract.submit(jobId, DELIVERABLE_HASH, "");

        // Evaluator Rejects (Amicable)
        vm.prank(evaluator);
        jobContract.reject(jobId, AMICABLE_REJECTION_REASON, abi.encode(AMICABLE_REJECTION_REASON));

        // Verify Settlement:
        // Client gets budget back
        assertEq(token.balanceOf(client), clientBalAfterFund + BUDGET);
        // Provider gets collateral back (no slashing)
        assertEq(token.balanceOf(provider), providerBalAfterFund + COLLATERAL);
    }

    function test_HostileRejectionWithSlashing() public {
        vm.prank(client);
        uint256 jobId = jobContract.createJob(provider, evaluator, block.timestamp + 7 days, "Fix Bug", address(hook));

        vm.startPrank(client);
        jobContract.setBudget(jobId, BUDGET, "");
        hook.configureCollateral(jobId, COLLATERAL);
        jobContract.fund(jobId, BUDGET, "");
        vm.stopPrank();

        uint256 providerBalAfterFund = token.balanceOf(provider);
        uint256 clientBalAfterFund = token.balanceOf(client);

        // Provider submits
        vm.prank(provider);
        jobContract.submit(jobId, DELIVERABLE_HASH, "");

        // Evaluator Rejects (Hostile/Spam)
        vm.prank(evaluator);
        jobContract.reject(jobId, HOSTILE_REJECTION_REASON, abi.encode(HOSTILE_REJECTION_REASON));

        // Verify Settlement:
        // Client gets budget back PLUS the slashed collateral
        assertEq(token.balanceOf(client), clientBalAfterFund + BUDGET + COLLATERAL);
        // Provider loses collateral
        assertEq(token.balanceOf(provider), providerBalAfterFund);
    }
}
