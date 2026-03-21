# vlayer Session Proof Verification Skill

This skill interfaces with the vlayer SDK to perform web page content authenticity verification using client-side TLS (zkTLS) proofs.

## Capabilities

- **GitHub Verification:** Securely extracts the commit history and PR merge status from a user's authenticated GitHub session.
- **Polymarket Verification:** Extracts the historical PnL and win/loss ratio from an authenticated Polymarket browser session without revealing API keys or specific open positions.
- **Social Media Verification:** Captures exact impression and engagement metrics from authenticated platforms (e.g., Twitter Analytics).

## Usage

This skill generates cryptographic proofs that the `PandemEvaluator` uses to verify conditions on web2 platforms. The provider generates the zkTLS proof and submits it to the job contract. The Pandem Evaluator uses this skill to assert the validity of the proof for `complete()` or `reject()`.
