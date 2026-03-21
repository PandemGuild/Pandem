# Lit Protocol Verification Skill

This skill documents the usage of Lit Protocol within the Pandem ERC-8183 architecture to conditionally release encrypted payloads off-chain based on on-chain states.

## Capabilities
- **Payload Encryption:** Encrypts a codebase payload (zip or text) such that it can only be decrypted if a specific condition is met on a specific smart contract.
- **Atomic Release:** The access control condition is hard-coded to require the `Job` state in `ERC8183.sol` to be `Completed` OR it requires the emission of the `PayloadReadyForDecryption` event.
- **Zero-Knowledge Handover:** The decryption key is never stored on the public blockchain.

## Evaluator Agent Usage
In "Build 1: The Zero-Trust Private Bug Bounty", the Evaluator Agent listens for the `PayloadReadyForDecryption` event emitted by the `AtomicHandoverHook.sol` after `complete()` is called.
Upon detecting this event, the Evaluator Agent (or the Client directly through a Lit frontend) requests the decryption key from the Lit network nodes. The Lit nodes verify the on-chain event emission and release the key.
