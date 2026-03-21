// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {IERC20} from "openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";
import {SafeERC20} from "openzeppelin-contracts/contracts/token/ERC20/utils/SafeERC20.sol";
import {IACPHook} from "./IERC8183.sol";
import {ERC8183} from "./ERC8183.sol";

/// @title Atomic Handover Hook (Build 1)
/// @dev Flexible Zero-Trust Bug Bounty hook allowing optional slashing and secure off-chain handover.
contract AtomicHandoverHook is IACPHook {
    using SafeERC20 for IERC20;

    IERC20 public immutable paymentToken;
    ERC8183 public immutable jobContract;

    // Configurable collateral requirements per job
    mapping(uint256 => uint256) public requiredCollateral;
    // Current locked collateral per job
    mapping(uint256 => uint256) public lockedCollateral;

    // Event emitted to trigger off-chain Lit Protocol or Evaluator node
    // to securely release the decryption key to the client's wallet.
    event PayloadReadyForDecryption(uint256 indexed jobId, address indexed client, address indexed provider, bytes32 deliverableHash);

    // Reason hash used by client/evaluator to signify an amicable rejection (no slashing)
    bytes32 public constant AMICABLE_REJECTION_REASON = keccak256("AMICABLE_CANCELLATION");

    constructor(address _paymentToken, address _jobContract) {
        paymentToken = IERC20(_paymentToken);
        jobContract = ERC8183(_jobContract);
    }

    /// @dev Allows the proposer/client to configure the collateral required for a specific job.
    /// In a fully autonomous setup, this might happen in `createJob` via factory, but here we explicitly set it.
    function configureCollateral(uint256 jobId, uint256 collateralAmount) external {
        (address client, address provider, , , , , ERC8183.State state, , ) = jobContract.jobs(jobId);
        require(state == ERC8183.State.Open, "Job must be open");
        require(msg.sender == client || msg.sender == provider, "Unauthorized config");
        requiredCollateral[jobId] = collateralAmount;
    }

    function beforeAction(uint256 jobId, bytes4 selector, bytes calldata data) external override {
        require(msg.sender == address(jobContract), "Only job contract");

        if (selector == ERC8183.fund.selector) {
            // CollateralHook: Enforce provider stakes collateral (if required) before the client can fund the job.
            uint256 reqCol = requiredCollateral[jobId];
            if (reqCol > 0) {
                (, address provider, , , , , , , ) = jobContract.jobs(jobId);
                require(provider != address(0), "Provider must be set");

                // Provider must deposit collateral
                paymentToken.safeTransferFrom(provider, address(this), reqCol);
                lockedCollateral[jobId] = reqCol;
            }
        }
    }

    function afterAction(uint256 jobId, bytes4 selector, bytes calldata data) external override {
        require(msg.sender == address(jobContract), "Only job contract");

        if (selector == ERC8183.complete.selector) {
            // Handover successful. Return collateral to provider.
            (address client, address provider, , , , , , , bytes32 deliverable) = jobContract.jobs(jobId);

            uint256 col = lockedCollateral[jobId];
            if (col > 0) {
                lockedCollateral[jobId] = 0;
                paymentToken.safeTransfer(provider, col);
            }

            // Emit event to trigger secure off-chain handover.
            // The Evaluator node sees this and securely encrypts/sends the Lit Protocol key to the client.
            // NO plaintext key is stored on-chain.
            emit PayloadReadyForDecryption(jobId, client, provider, deliverable);

        } else if (selector == ERC8183.reject.selector) {
            // Handover failed.
            // Decode the reason to determine if it's an amicable cancellation or a slashing event.
            require(data.length >= 4, "Invalid reject data length");
            (, bytes32 reason, ) = abi.decode(data[4:], (uint256, bytes32, bytes));

            (address client, address provider, , , , , , , ) = jobContract.jobs(jobId);

            uint256 col = lockedCollateral[jobId];
            if (col > 0) {
                lockedCollateral[jobId] = 0;

                if (reason == AMICABLE_REJECTION_REASON) {
                    // Amicable Cancellation: Return collateral to the provider.
                    paymentToken.safeTransfer(provider, col);
                } else {
                    // Hostile Rejection (Spam/Malicious): Slash collateral and send to the client.
                    paymentToken.safeTransfer(client, col);
                }
            }
        }
    }

    /// @dev Allows the provider to reclaim collateral if the job expires.
    /// This is necessary because claimRefund() in ERC-8183 is intentionally not hookable.
    function reclaimExpiredCollateral(uint256 jobId) external {
        (, address provider, , , , , ERC8183.State state, , ) = jobContract.jobs(jobId);
        require(msg.sender == provider, "Only provider");
        require(state == ERC8183.State.Expired, "Job not expired");

        uint256 col = lockedCollateral[jobId];
        require(col > 0, "No collateral to reclaim");

        lockedCollateral[jobId] = 0;
        paymentToken.safeTransfer(provider, col);
    }
}
