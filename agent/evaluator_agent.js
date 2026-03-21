/**
 * Project Pandem - Evaluator Agent Ethers.js Script
 *
 * This script simulates the off-chain logic of the "Evaluator Agent" for the
 * Zero-Trust Private Bug Bounty (Atomic Handover) use case.
 *
 * Responsibilities:
 * 1. Listen for `JobSubmitted` events on the ERC8183 contract.
 * 2. Simulate acquiring and verifying the off-chain deliverable (e.g., verifying GitHub PR/Deployment).
 * 3. Await client decision and execute `complete()` or `reject()` on-chain.
 * 4. Listen for the `PayloadReadyForDecryption` event to simulate releasing the Lit Protocol decryption key.
 */

import { ethers } from "ethers";

// ABI fragments for the necessary ERC8183 and AtomicHandoverHook functions/events
const ERC8183_ABI = [
  "event JobSubmitted(uint256 indexed jobId, bytes32 deliverable)",
  "function complete(uint256 jobId, bytes32 reason, bytes calldata optParams) external",
  "function reject(uint256 jobId, bytes32 reason, bytes calldata optParams) external",
  "function jobs(uint256 jobId) external view returns (address client, address provider, address evaluator, address hook, uint256 budget, uint256 expiredAt, uint8 state, string description, bytes32 deliverable)"
];

const HOOK_ABI = [
  "event PayloadReadyForDecryption(uint256 indexed jobId, address indexed client, address indexed provider, bytes32 deliverableHash)"
];

// Configuration (Replace with actual deployed addresses and RPC)
const RPC_URL = process.env.RPC_URL || "http://localhost:8545";
const PRIVATE_KEY = process.env.EVALUATOR_PRIVATE_KEY || "0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80"; // Default Anvil key #0
const ERC8183_ADDRESS = process.env.ERC8183_ADDRESS || "0xYourERC8183Address";
const HOOK_ADDRESS = process.env.HOOK_ADDRESS || "0xYourHookAddress";

// Pre-defined Reason Hashes
const REASON_APPROVED = ethers.id("APPROVED");
const REASON_AMICABLE = ethers.id("AMICABLE_CANCELLATION");
const REASON_HOSTILE = ethers.id("SPAM_SUBMISSION");

async function main() {
  console.log("🚀 Starting Pandem Evaluator Agent Simulation...\n");

  const provider = new ethers.JsonRpcProvider(RPC_URL);
  const wallet = new ethers.Wallet(PRIVATE_KEY, provider);

  const erc8183Contract = new ethers.Contract(ERC8183_ADDRESS, ERC8183_ABI, wallet);
  const hookContract = new ethers.Contract(HOOK_ADDRESS, HOOK_ABI, provider); // Listen only

  console.log(`📡 Listening for JobSubmitted events on ERC8183 (${ERC8183_ADDRESS})...`);

  // 1. Listen for Work Submission
  erc8183Contract.on("JobSubmitted", async (jobId, deliverableHash, event) => {
    console.log(`\n======================================================`);
    console.log(`🔔 EVENT: JobSubmitted detected for Job ID: ${jobId}`);
    console.log(`📦 Deliverable Hash: ${deliverableHash}`);

    // 2. Fetch Job Details
    const job = await erc8183Contract.jobs(jobId);
    console.log(`🔍 Job Description: ${job.description}`);
    console.log(`🧑‍💻 Proposer: ${job.provider}`);
    console.log(`🏢 Client: ${job.client}`);

    // 3. Simulate Off-Chain Verification & Client Interaction
    console.log(`\n🤖 Evaluator Agent Processing...`);
    console.log(`   --> Extracting GitHub API Keys from Secure Enclave... (Simulated)`);
    console.log(`   --> Cloning private repository & running test suite... (Simulated)`);
    console.log(`   --> Verifying live preview deployment... (Simulated)`);
    console.log(`   --> Sending preview link to Client... (Simulated)`);

    // Simulate network delay for client testing
    await new Promise(resolve => setTimeout(resolve, 3000));

    // Determine the outcome (Simulated for this script)
    // In reality, this would be triggered by an API endpoint the Client hits,
    // or by evaluating a vlayer zkTLS proof submitted by the Client.
    const clientDecision = "APPROVE"; // Options: "APPROVE", "AMICABLE_REJECT", "HOSTILE_REJECT"

    console.log(`\n📩 Client Decision Received: ${clientDecision}`);

    try {
      if (clientDecision === "APPROVE") {
        console.log(`✅ Executing complete() transaction on-chain...`);
        const tx = await erc8183Contract.complete(jobId, REASON_APPROVED, "0x");
        await tx.wait();
        console.log(`   Transaction confirmed! Hash: ${tx.hash}`);
      }
      else if (clientDecision === "AMICABLE_REJECT") {
        console.log(`🤝 Executing reject() transaction (Amicable) on-chain...`);
        // We pass the reason hash as optParams as required by the hook logic we built
        const optParams = ethers.AbiCoder.defaultAbiCoder().encode(["bytes32"], [REASON_AMICABLE]);
        const tx = await erc8183Contract.reject(jobId, REASON_AMICABLE, optParams);
        await tx.wait();
        console.log(`   Transaction confirmed! Hash: ${tx.hash}`);
      }
      else if (clientDecision === "HOSTILE_REJECT") {
        console.log(`🚫 Executing reject() transaction (Hostile/Spam) on-chain...`);
        const optParams = ethers.AbiCoder.defaultAbiCoder().encode(["bytes32"], [REASON_HOSTILE]);
        const tx = await erc8183Contract.reject(jobId, REASON_HOSTILE, optParams);
        await tx.wait();
        console.log(`   Transaction confirmed! Hash: ${tx.hash}`);
      }
    } catch (error) {
      console.error(`❌ Transaction failed:`, error.message);
    }
  });

  // 4. Listen for the Atomic Handover Trigger
  hookContract.on("PayloadReadyForDecryption", async (jobId, clientAddr, providerAddr, deliverableHash, event) => {
    console.log(`\n======================================================`);
    console.log(`🔓 EVENT: PayloadReadyForDecryption detected for Job ID: ${jobId}`);
    console.log(`   --> Payment has been secured on-chain.`);
    console.log(`   --> Interfacing with Lit Protocol Nodes... (Simulated)`);
    console.log(`   --> Fetching decryption keys for payload hash: ${deliverableHash}`);
    console.log(`   --> Securely delivering Decryption Key to Client: ${clientAddr}`);
    console.log(`🎉 Atomic Handover Complete!`);
    console.log(`======================================================\n`);
  });

  // Keep script running
  process.stdin.resume();
}

main().catch(console.error);