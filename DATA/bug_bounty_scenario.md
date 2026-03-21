# Project Pandem: The Zero-Trust Private Bug Bounty Scenario Report

## Objective
To build a highly flexible, secure, and trustless bug bounty mechanism using the ERC-8183 Commerce Layer. This system facilitates the atomic exchange of a codebase (the bug fix) for payment without exposing the repository, the code itself, or requiring traditional human arbitration.

## The Participants
1. **The Proposer (Security Agent/Developer):** Finds a bug in a client's website, writes a patch on their own private GitHub branch, and deploys a live preview for testing.
2. **The Client (Organization):** Owns the vulnerable website and holds the bounty budget (e.g., $10,000 USDC).
3. **The Evaluator (AI Agent):** A neutral third-party agent designated in the ERC-8183 contract. It accesses the proposer's private repository, verifies the deployment, sends the preview link to the client, and ultimately executes the contract's outcome based on the client's decision.

## The Handover Flow & Logical Path

### 1. Negotiation & Job Creation
- The Proposer identifies a bug and approaches the Client.
- The Proposer proposes an ERC-8183 job. To signal high confidence and avoid wasting the client's time, the Proposer *optionally* attaches a **Slashing Fee (Collateral)** (e.g., $500).
- **Flexibility Note:** The collateral is not mandatory. The `AtomicHandoverHook` allows the required collateral amount to be `0` if the parties agree to a risk-free proposal.
- The Client creates the Job with a budget of $10,000 USDC and sets the Proposer and Evaluator.

### 2. Funding
- The Proposer stakes the agreed-upon collateral into the hook.
- The Client funds the job with the $10,000 USDC budget.
- The Job state moves to **Funded**.

### 3. Work & Submission
- The Proposer completes the patch on their private GitHub and deploys a live preview.
- The Proposer encrypts the codebase payload (e.g., using Lit Protocol).
- The Proposer calls `submit()` on the ERC-8183 contract, providing the `deliverable` hash (IPFS hash of the encrypted codebase). The Job state moves to **Submitted**.

### 4. Evaluation & Client Testing (Off-Chain Synergy)
- The **Evaluator Agent** detects the `JobSubmitted` event.
- The Evaluator accesses the Proposer's private repository using scoped GitHub keys (provided securely off-chain via secure enclaves or Venice.ai private inference).
- The Evaluator verifies the deployment matches the codebase and acquires the live preview link.
- The Evaluator sends the direct preview link to the Client.
- The Client tests the exact patch in isolation.

### 5. Resolution & Settlement (The Atomic Handover)
The Client communicates their decision to the Evaluator (or takes an on-chain action that the Evaluator verifies via zkTLS). The Evaluator then finalizes the contract.

**Outcome A: Success (Atomic Handover)**
- The Client approves the patch.
- The Evaluator calls `complete(jobId, evidenceHash)`.
- **On-chain Hook Action:** The $500 collateral is returned to the Proposer. The $10,000 budget is sent to the Proposer. The hook emits a `PayloadReadyForDecryption` event.
- **Off-chain Action:** The Evaluator (or a Lit Protocol action) detects the event and securely releases the decryption key directly to the Client. The codebase is handed over atomically.

**Outcome B: Amicable Cancellation**
- The Client and Proposer agree to part ways before submission, or the Client decides not to proceed but acknowledges the effort wasn't malicious.
- The Evaluator calls `reject()`.
- **On-chain Hook Action:** Because it's an amicable cancellation, the hook logic allows the collateral to be returned to the Proposer, and the $10,000 budget is refunded to the Client.

**Outcome C: Rejection with Slashing (Spam/Malicious)**
- The Client finds the patch completely irrelevant, malicious, or spam.
- The Client instructs the Evaluator to slash.
- The Evaluator calls `reject()` passing a specific reason hash indicating a slash.
- **On-chain Hook Action:** The $500 collateral is slashed and sent to the Client. The $10,000 budget is refunded to the Client.

## Off-Chain Dependencies & Preliminary Requirements
To fully realize this scenario in production, the Evaluator Agent relies on several external systems. These dependencies are abstracted from the smart contract but are critical for the end-to-end flow:

1. **Lit Protocol:** Used to encrypt the `deliverable` codebase. The decryption key is conditionally released only when the `PayloadReadyForDecryption` event is emitted upon a successful `complete()` call.
2. **Filecoin / IPFS:** Used to permanently store the encrypted codebase payload and the Evaluator's evidence bundles (test reports, zkTLS proofs).
3. **GitHub API Keys (Scoped):** The Evaluator requires read-only access to the Proposer's private repository to verify the code and deployment. These keys must be handled within a secure enclave (e.g., TEE) or using Venice.ai's private inference to ensure they are never leaked.
4. **vlayer (zkTLS):** If the Client's approval happens via a Web2 action (e.g., clicking "Approve" on a private dashboard or merging a PR), the Evaluator uses vlayer to generate a client-side TLS proof of that action, providing cryptographic truth without arbitration.

## Contract Design Principles for this Scenario
- **No Plaintext Keys On-Chain:** The previous iteration stored the decryption key in the contract state. This is highly insecure. The new design uses Events to trigger off-chain key releases.
- **Parametrized Collateral:** The hook will accept dynamic collateral requirements.
- **Discretionary Slashing:** The `reject` function in the hook will analyze the `reason` payload to determine if the rejection is amicable (return collateral) or hostile (slash collateral).
