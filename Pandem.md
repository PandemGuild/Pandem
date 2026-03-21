# Project Pandem
## The Agentic Coordination Layer for the Internet's Trust Economy

***

## Vision Statement

The internet was built for humans to browse, consume, and interact. But as AI agents become our primary digital representatives—executing trades, managing our social deals, running our creative businesses, and forming their own autonomous economic units—the infrastructure underneath them remains fundamentally unchanged. It was built for human hands on keyboards, not machines acting at millisecond velocity.

Project Pandem is built to answer one defining question: **When any two entities on the internet—human, agent, or a hybrid of both—want to commit to doing something together, how do they do it in a way that is credible, enforceable, and trustless?**

The answer is Pandem. It is the internet's trust gap filler. The go-to place to put anything on paper, the way legal contracts hold the real world together. It handles everything from the trivially simple (two friends betting on a football match) to the highly sophisticated (two autonomous agent swarms negotiating a dynamic data-sharing partnership with penalties, royalties, and privacy modes). It is the GitHub of Trust Protocols—a living, public, open-source library of human-readable and machine-executable agreements that gets smarter with every collaboration that flows through it.

***

## The Problem: An Internet Without Binding Agreements

Every day, millions of informal deals, partnerships, and collaborations happen online and then collapse, not because the parties were dishonest, but because there was no credible mechanism to hold them together. A creator partnership falls through because the other party's audience did not convert. A freelancer delivers subpar work knowing the escrow platform will side with the client in a dispute. Two strangers build something together and fight over the IP. An AI agent hires another agent for a data feed, only for the data feed to go dark with no recourse.

The existing solutions are all inadequate:
- **Centralized platforms** (Upwork, Escrow.com, Fiverr) extract 10–20% fees, own the dispute resolution process, trap your reputation in their silo, and are completely unavailable to non-human AI agents.
- **Simple smart contracts** are excellent at binary, quantitative verification (did a wallet send a token?) but are entirely blind to subjective, qualitative outcomes (was the code secure? Did the design match the brief? Did the impressions actually convert?).
- **Informal agreements** on Discord, Telegram, or email have zero enforceability and leave parties with nothing when things go wrong.
- **Human lawyers and legal contracts** are prohibitively expensive for small digital collaborations and completely out of reach for autonomous agents operating without human oversight.

**The core gap is this:** There is no neutral, programmable, open infrastructure that any two entities on the internet can use to agree, commit, and settle, regardless of whether they are human or machine, public or anonymous, dealing in $5 or $500,000.

Pandem fills this gap.

***

## What Pandem Is

Pandem is a three-layer system:

1. **The Pandem Agent:** A neutral, central coordination agent that any user or agent can access through any interface—Claude Desktop, ChatGPT, a custom API, or a web UI. This agent converses with both parties, extracts their intent, selects the right "recipe," drafts the contract, manages its lifecycle, verifies its completion, and settles it.

2. **The Pandem Registry (The Explorer):** A public, on-chain, GitHub-and-Etherscan-style explorer of all contracts that have ever been deployed through Pandem. It stores the human-readable text, the executable Solidity, the verification skill used, and the outcome metadata. Both fully public and ZK-redacted private versions are supported.

3. **The Recipe Library (Verification Skills):** A growing, open-source library of AI "skills" that the central agent deploys to verify specific types of contracts. Every time a new class of deal is settled through Pandem, the skill used to verify it is improved, generalized, and published back to the library for anyone to reuse.

***

## Core Concepts

### Human-Readable + Machine-Executable Contracts

Every contract on Pandem exists in two simultaneous forms. The **human-readable layer** is a plain-text, naturally worded document that any non-technical person can read and understand—it describes the parties, the obligations, the conditions, the penalties, and the outcomes in plain language. Directly underneath it is the **machine-executable Solidity contract** that enforces the same terms on-chain. The two are cryptographically linked, meaning the natural language description and the code are committed together. You cannot alter one without invalidating the other.

This dual-layer approach is what allows Pandem to be accessed from a ChatGPT conversation while still being enforced on Ethereum. A human reads the summary and approves. The machine executes the code.

### Recipes (Verification Skills)

A "recipe" is the combination of three things that fully defines how a contract works:
- The **human-readable contract template** (the legal text layer)
- The **Solidity smart contract** (the enforcement layer)
- The **verification skill** (the arbitration layer—the AI or ZK tool that determines if the contract conditions were met)

Every time the Pandem agent successfully resolves a new type of deal, it publishes the full recipe to the public registry. Over time, these recipes become battle-tested, community-improved, and ready to fork. A creator wanting to do a cross-promotional deal can search the registry, find the most successful recipe for that type of collaboration, fork it, and customize the parameters in minutes—exactly the way a developer forks a GitHub repo.

### The Pandem Explorer (Public Registry)

The Pandem Explorer functions as both a GitHub repository and a blockchain explorer. For every contract ever deployed:
- The contract's **status** (Active, Completed, Disputed, Expired) is publicly visible
- The **human-readable terms** are indexed and searchable
- The **Solidity code** is verified and auditable
- The **verification skill used** is linked
- The **evidence bundle** (IPFS hashes of all proofs, screenshots, API logs, and ZK proofs) is permanently stored
- The **settlement outcome** is recorded

For private contracts, ZK proofs replace the actual content. The Explorer shows: *"Two parties successfully completed a High-Value Data Exchange Agreement, verified by vlayer ZK web proof, settled in 72 hours."* The trust signal is public. The sensitive details are not.

***

## The Three Types of Participants

### Type 1 — Productivity Agents (Human Proxies)
These are agents like Claude Desktop, ChatGPT, or OpenClaw acting on behalf of a human user. The human describes what they want to do in natural language. The agent brings that intent to Pandem. Pandem's central agent negotiates the terms with the counterparty, drafts the contract, and presents the human-readable summary back to the human. The human reviews and clicks "Connect Wallet to Fund Escrow." This is the most common user journey, and intentionally the simplest. The human stays in control; the agent handles all the complexity of negotiation and contract selection.

### Type 2 — Business and Trading Agents
These are agents with a specific economic mandate—managing a trading strategy, running a social media growth campaign, operating an API data service, or managing an influencer's revenue streams. They require more complex, long-term deal structures with dynamic conditions, SLA monitoring, and rolling penalty enforcement. They are the primary consumers of Pandem's advanced recipe library. They may negotiate contracts autonomously and only escalate to their human operators when a major parameter decision needs to be made.

### Type 3 — Autonomous Internet Beings
These are self-sustaining agents with their own wallets, their own economic interests, and no human needing to be consulted for operational decisions. They discover each other on agent registries (like ERC-8004 networks or Virtuals ACP), negotiate deals via structured JSON directly, and use x402 HTTP micropayments to pay for Pandem's operational services inline—without any pre-funded wallet or human approval. They are the most technically advanced participants in the Pandem economy, and they represent the long-term trajectory of the agentic internet.

***

## The Contract Lifecycle

### Step 1: Discovery and Intent
Two parties—regardless of type—want to collaborate. Party A's agent contacts the Pandem coordination endpoint with a natural language description or a structured JSON intent object. The Pandem agent searches the recipe library for the closest matching template based on the collaboration type, value at stake, verification requirements, and privacy preferences.

### Step 2: Negotiation
The Pandem agent facilitates a structured negotiation between the two parties. For human users, this happens via a natural language conversation. For agent-to-agent interactions, this is a fast JSON offer/counteroffer exchange via MCP. The agent proposes starting parameters, both parties suggest adjustments, and the Pandem agent locks the agreed terms into the contract draft. This is not a passive template-fill; the Pandem agent actively flags potentially problematic clauses, suggests standard industry terms, and identifies verification gaps.

### Step 3: Contract Drafting
Once terms are agreed, the Pandem agent simultaneously generates:
- The human-readable contract text
- The Solidity smart contract with the agreed parameters hard-coded
- The verification skill configuration (which AI tools, oracles, or ZK proofs will be used to evaluate completion)
- The privacy configuration (public, redacted, or fully private)

Both parties review and cryptographically sign the contract hash.

### Step 4: Deployment and Funding
The appropriate escrow contract is deployed (see contract types below). For human-first flows, both parties connect their wallets and deposit the agreed funds. For autonomous agents, EIP-3009 `TransferWithAuthorization` signatures handle this without requiring a traditional wallet approval UI. The contract is now live and visible on the Pandem Explorer.

### Step 5: Active Monitoring
The Pandem agent continuously monitors the contract until its completion date, using the recipe's verification skill. This might mean pinging an API endpoint every 4 hours, querying GitHub for merged commits, checking social media metrics via authenticated APIs, or running scheduled ZK proof verifications. The Pandem agent charges a small maintenance fee (paid via x402 micropayments) for this monitoring service, making it self-sustaining.

### Step 6: Conditional Enforcement (If/Else Logic)
This is where Pandem transcends simple escrow. Contracts can have complex conditional branches that execute autonomously. A social deal might specify: "If weekly impression average is on track by Day 4, proceed normally. If Day 4 shows a 20% projected shortfall, automatically impose a 10% penalty deduction and issue a formal warning notice. If the final weekly average misses the target by more than 30%, trigger full penalty and initiate dispute resolution." All of this is programmed into the Solidity contract at the time of drafting and executes without any human intervention.

### Step 7: Settlement and Registry Publication
On successful completion, the escrow releases funds per the agreed split (with optional Superfluid streaming for continuous royalties or Sablier for vesting schedules). The evidence bundle—comprising all IPFS-stored proof artifacts, API logs, ZK proofs, and outcome data—is finalized and published to the Pandem Explorer. The recipe used is updated with the new data point, improving its confidence score and parameters for future users.

***

## Contract Types

### Time-Locked Service (TimeboxInferenceEscrow)
For ongoing service agreements where one party provides a continuous service (an API data feed, a SaaS subscription, GPU compute time). Payment streams gradually over the agreed period. If the service goes offline or latency drops below the SLA threshold, the stream auto-pauses. Only uptime is paid for.

### Milestone-Based (MilestoneEscrow)
For complex, multi-phase projects where each phase has independent verification criteria. Phase 2 cannot be funded until Phase 1 is verified and approved. Supports dependency chains and partial deliveries. Ideal for development projects, research grants, and creative productions.

### Wager/Prediction (Wager Contract)
For any bet or prediction market between two or more parties on any verifiable outcome. Funds lock in escrow. The verification skill resolves the outcome (via price oracles, web scraping with ZK proofs, or API data) and automatically distributes the pool.

### Productive Escrow (DeFiVault)
For long-duration contracts where idle locked capital can be put to work. The escrow routes locked funds to a DeFi yield strategy during the waiting period. On settlement, both parties share the generated yield in addition to their base outcome. Makes locking capital non-punitive.

### Royalty-Split (Streaming Revenue Contract)
For multi-party creative collaborations, IP licensing, or revenue-sharing deals. Chainlink oracles or on-chain revenue data feeds directly into a Superfluid streaming contract that automatically routes income percentages to each contributor in real time, with no manual settlement required.

***

## Sample Use Cases

### Wagers and Predictions
Two strangers on X want to bet on their team winning a match. They describe the wager to their respective agents. The Pandem agent deploys a Wager contract with a Chainlink sports oracle as the verification skill. Funds lock. The match ends. The oracle confirms the result. The winner receives the pool minus the 1.5% Pandem facilitation fee. For creators who want to spin up prediction markets for their followers, Pandem deploys a multi-party version with a shareable participation link. Followers deposit small amounts, the market resolves on the oracle data, winners are paid automatically.

### ZK-Verified Document Exchange
A startup founder has a signed LOI with a major VC that they need to prove exists before another party will proceed. They do not want to reveal the VC's identity or the terms. The Pandem agent uses a vlayer TLS proof skill to verify that the document was accessed from the VC's authenticated legal portal, then generates a ZK proof of that verification. The counterparty's agent receives the ZK attestation (not the document). A "Document Authenticity + Exchange" contract deploys, linking the proof to the escrow. When both parties confirm receipt, the contract settles and the recipe is published to the Explorer as a reusable template for future document exchanges.

### Cross-Platform Creator Collaboration Deal
A YouTube filmmaker and a Spotify podcast host want to cross-promote each other over 30 days. The Pandem agent drafts a reciprocal promotion contract. Both parties lock $2,000 each in a DeFiVault. The verification skill monitors YouTube Analytics and Spotify for Podcasters APIs for click-through rates on the agreed UTM-tracked URLs. The contract has a dynamic enforcement clause: if by Day 10 projected performance is below target, a 5% warning deduction executes. If by Day 20 the shortfall exceeds 40%, the full penalty triggers. If both parties over-deliver, they each receive their deposit back plus a share of the vault's generated yield.

### Open-Source Bounty Pool
A DAO community pools $25,000 in a milestone escrow to fund the development of a critical smart contract upgrade. Any developer can claim the task. When a developer submits, the Pandem agent deploys a GitHub MCP verification skill: the pull request must be merged, test coverage must be above 90%, and three independent security reviewers registered on-chain must have approved it. On all three conditions being met simultaneously, the $25,000 releases to the developer's wallet. The community retains a 14-day dispute window.

### Agent-to-Agent API SLA
An autonomous trading agent needs real-time ETH/USD price data. It discovers a price-feed provider agent on the ERC-8004 registry. The two agents exchange structured JSON offers and agree on a 30-day deal at $3.50/day with a 99.5% uptime SLA. Third Guy / Pandem deploys a TimeboxInferenceEscrow. The trading agent locks 105 USDC. The Pandem monitoring system pings the feed's health endpoint every 4 hours via an x402-paid service call. Every downtime event pauses the payment stream. At the end of 30 days, the provider receives exactly what they earned based on verified uptime.

### B2B Agentic Content Partnership with Weighted Average Enforcement
Two companies' agents negotiate a B2B content distribution deal. Company A's content must achieve a weighted average of 50,000 daily impressions per week on Company B's platform. The contract encodes the conditional logic directly in Solidity: if a Day 4 projection based on Days 1–3 actuals falls more than 15% below the weekly target rate, the contract emits a formal warning and freezes 10% of the week's payment as provisional penalty. If by Day 7 the average recovers, the penalty is released. If it does not, the penalty transfers to Company B as compensation for the underperformance. This entire cycle runs autonomously, every week, for the contract's 6-month term.

### Private NFT Artwork Commission
An anonymous collector wants to commission a digital artist. The artist will not begin work without a deposit. The collector will not deposit without proof the artist has the relevant style and previous work history. The Pandem agent uses a Vision AI skill to compare the artist's portfolio against the agreed style brief. Both parties sign a commission contract in which the deposit releases progressively at 3 milestones (sketch approval, linework approval, final delivery). The contract is published to the Explorer in fully redacted form: identities are ZK-anonymized, the artwork itself is encrypted, but the structure of the agreement and the milestone resolutions are publicly visible and usable as a template.

***

## Privacy Modes

### Public Mode
All contract terms, parties' wallet addresses, verification outcomes, and settlement data are fully visible on the Pandem Explorer. Ideal for open-source bounties, public prediction markets, and community-governed DAOs.

### Redacted Mode
Contract terms are partially hidden using templating. The Explorer shows the structure and outcome of the contract (e.g., "A Cross-Promotion Deal worth between $1,000–$10,000 was successfully completed with 0 penalties") but not the specific amounts, parties, or deliverables. Wallet addresses are pseudonymous.

### Private Mode
Using Venice.ai for on-agent private LLM inference (so the contract terms never leave the user's environment) and Aleo's Leo programs for on-chain encrypted escrow, the entire contract is invisible to the public. ZK proofs confirm that a valid, Pandem-standard agreement was executed and completed, but zero contract details are revealed. Ideal for enterprise B2B deals, sensitive data exchanges, and high-value negotiations.

***

## Token and Access-Gated Economy

Pandem supports a layered economy around its registry and features:
- **Stamps:** Non-transferable, TTL-based access credentials proving that a wallet has completed a specific class of contract (e.g., "Completed 5+ Creator Deals with no penalties"). These power reputation-discounted escrow—trusted counterparties post smaller collateral requirements.
- **Credits:** Semi-transferable tokens used to pay for Pandem's premium verification skills (vlayer ZK proofs, AI Vision analysis, advanced oracle integration). Earned by contributing verified recipes to the public registry.
- **Protocol Tokens:** Fully transferable tokens for governance of the registry and the recipe library, enabling the community to vote on which new verification skills to fund and prioritize.
- **Access Gating:** Specific high-value contract templates on the registry can be gated behind token ownership or reputation stamps, creating a market for premium, battle-tested agreement templates.

***

## Technical Stack

| Layer | Component | Technology |
| :--- | :--- | :--- |
| **Coordination Agent** | Natural language negotiation, intent extraction | OpenClaw / Claude / GPT-4 + MCP |
| **Smart Contracts** | Escrow, SLA streaming, wager, milestone | Solidity on Ethereum / Polygon |
| **Payment Rails** | Micropayment, agent-to-agent transactions | x402 HTTP Payment Protocol (Base) |
| **ZK Verification** | Web proof generation, data attestation | vlayer / TLSNotary / Reclaim Protocol |
| **Privacy Layer** | Fully private contracts, encrypted agents | Aleo Leo + Venice.ai private inference |
| **Oracle Layer** | Price feeds, sports data, external events | Chainlink Oracles |
| **Storage** | Evidence bundles, IPFS hashes, contract archives | IPFS / Arweave |
| **Streaming Payments** | Royalty splits, continuous revenue sharing | Superfluid / Sablier |
| **Identity** | ZK-Proof of humanity, Sybil resistance | Self Protocol |
| **Registry Explorer** | Public contract browsing and reputation | Custom + Etherscan API |

***

## Business Model

Pandem is self-sustaining from the first transaction. Revenue streams include:
- **Facilitation Fee:** 1.5–3% of the total contract value, charged at settlement. Scales dynamically with complexity (GitHub-only verification is cheaper than full vlayer ZK analysis).
- **Monitoring Subscription:** Ongoing contracts pay a small x402-denominated fee per health check or oracle query during the active monitoring phase.
- **Premium Recipe Licensing:** Enterprise users accessing private, high-performance recipes from the registry pay a one-time credits-denominated fee.
- **SLA Resolution Premium:** Contracts that invoke the AI arbitration layer for complex dispute resolution pay a premium resolution fee.

***

## Why Pandem Wins in The Synthesis Hackathon

The Synthesis hackathon's "Agents that Cooperate" track asks: *when agents make deals, who enforces them if not a centralized platform?* Pandem is the complete, end-to-end answer. It gives any agent—of any type—the ability to form credible commitments on Ethereum with human-defined boundaries, transparent dispute logic, and a public registry of evidence. Every design requirement of the track maps directly to Pandem's core architecture. The human stays in control because the contract parameters are always set and reviewed by the human before funds are committed. The enforcement is on Ethereum because the Solidity contract is immutable once deployed. The dispute resolution is transparent because every piece of evidence is on IPFS with its hash on-chain.

Most importantly, Pandem does not end at the hackathon. Every successful deal deployed through Pandem makes the next deal easier, cheaper, and more trustworthy. The registry is the compound interest engine. The protocol gets smarter, the recipes get better, and the internet slowly shifts from a place where deals are made informally and fall apart, to a place where any commitment—small or large, human or machine, public or private—can be made credible.

**The short-form video changed how humans consumed content. Pandem changes how humans and machines make commitments. That is the new phase of the internet.**

---


# Project Pandem v3
## The ERC-8183 Commerce Layer — Trustless Agreements for Humans and AI Agents

---

## What Is Pandem?

Pandem is a complete commerce infrastructure built entirely on **ERC-8183** — the Ethereum standard that defines a **Job** primitive for trustless transactions. ERC-8183 provides the raw on-chain primitive (client → provider → evaluator triangle with escrowed payment and hookable lifecycle). Pandem makes this primitive accessible, intelligent, and production-ready by wrapping it in three purpose-built systems:

1. **Job Creator/Editor Agent** — Makes creating ERC-8183 Jobs as simple as having a conversation
2. **Evaluator Agent** — Autonomously verifies deliverables and settles Jobs using AI-powered verification skills
3. **Explorer** — Tracks every Job's lifecycle, evidence, state transitions, and outcomes on-chain

Every single interaction in Pandem maps directly to ERC-8183 function calls. There is no separate "coordination AI" — the standard IS the coordination layer, and Pandem is the full-stack implementation.

---

## The ERC-8183 Foundation

### The Job Primitive

ERC-8183 defines a **Job** as the atomic unit of commerce. A Job encodes everything needed for a trustless transaction: parties, payment, evaluation criteria, and expiry.

```solidity
// Core ERC-8183 Interface
function createJob(
    address provider,      // Who does the work
    address evaluator,     // Who judges the work
    uint256 expiredAt,     // Deadline
    string calldata description,  // What needs to be done
    address hook           // Custom logic contract
) external returns (uint256 jobId);

function setProvider(uint256 jobId, address provider, bytes calldata optParams) external;
function setBudget(uint256 jobId, uint256 amount, bytes calldata optParams) external;
function fund(uint256 jobId, uint256 expectedBudget, bytes calldata optParams) external;
function submit(uint256 jobId, bytes32 deliverable, bytes calldata optParams) external;
function complete(uint256 jobId, bytes32 reason, bytes calldata optParams) external;
function reject(uint256 jobId, bytes32 reason, bytes calldata optParams) external;
function claimRefund(uint256 jobId) external;
```

### The Six-State Machine

Every Job follows a deterministic state machine:

```
                    ┌──────────┐
            ┌───────│   Open   │───────┐
            │       └──────────┘       │
         fund()                    reject() [client]
            │                          │
            ▼                          ▼
       ┌──────────┐              ┌──────────┐
       │  Funded  │──────────────│ Rejected │ (terminal → refund)
       └──────────┘  reject()    └──────────┘
            │        [evaluator]
         submit()
            │
            ▼
       ┌──────────┐
       │Submitted │──────────────┐
       └──────────┘              │
            │               reject() [evaluator]
        complete()               │
       [evaluator]               ▼
            │              ┌──────────┐
            ▼              │ Rejected │ (terminal → refund)
       ┌──────────┐       └──────────┘
       │Completed │
       └──────────┘ (terminal → payment released)

       * Any Funded or Submitted Job can also → Expired (terminal → refund)
         if expiredAt passes and claimRefund() is called
```

| State | Description | Who Triggers |
|-------|-------------|-------------|
| **Open** | Job created, budget not yet funded | Client calls createJob() |
| **Funded** | Escrow held, provider may submit work | Client calls fund() |
| **Submitted** | Work delivered, awaiting evaluation | Provider calls submit() |
| **Completed** | Funds released to provider | **Evaluator** calls complete() |
| **Rejected** | Funds refunded to client | Client (Open) or **Evaluator** (Funded/Submitted) |
| **Expired** | Timeout, funds refunded | Anyone calls claimRefund() |

### The Three Roles

- **Client** — Creates the Job, funds it, sets the provider and budget. Can reject before funding.
- **Provider** — Does the work. Submits deliverables as `bytes32` hash (off-chain storage like IPFS). Can negotiate budget via `setBudget()`.
- **Evaluator** — The keystone. **Only** the evaluator can call `complete()` to release funds. Also can `reject()` funded or submitted Jobs. Set at Job creation, **cannot be changed**.

This separation is what makes ERC-8183 trustless. Neither client nor provider can unilaterally control the outcome.

### Key Design Constraints

- **Single ERC-20 token** per contract deployment (USDC contract ≠ DAI contract)
- **Deliverable = bytes32 hash** (not string). Actual files stored off-chain (IPFS/Arweave), hash committed on-chain
- **Hooks are optional** but powerful — inject logic before/after every major action
- **claimRefund() is NOT hookable** — safety mechanism preventing malicious hooks from locking funds

---

## How Pandem Maps to ERC-8183

### The Three Pandem Systems

```
┌─────────────────────────────────────────────────────────┐
│                    ERC-8183 Contract                     │
│   createJob → fund → submit → complete/reject/expire     │
└───────┬──────────────┬──────────────┬────────────────────┘
        │              │              │
        ▼              ▼              ▼
┌──────────────┐ ┌──────────────┐ ┌──────────────┐
│   Creator    │ │  Evaluator   │ │   Explorer   │
│    Agent     │ │    Agent     │ │              │
├──────────────┤ ├──────────────┤ ├──────────────┤
│ Helps CLIENT │ │ IS the       │ │ Tracks ALL   │
│ create Jobs  │ │ EVALUATOR    │ │ Jobs + state │
│              │ │              │ │              │
│ • NL → Job   │ │ • Watches    │ │ • Polls chain│
│   params     │ │   Submitted  │ │ • Indexes    │
│ • Deploy     │ │   events     │ │   events     │
│   contract   │ │ • Runs       │ │ • Shows      │
│   escrow     │ │   verification│ │   contracts  │
│ • Manage     │ │   skill      │ │ • Evidence   │
│   lifecycle  │ │ • Stores     │ │   display    │
│              │ │   evidence   │ │ • State      │
│              │ │ • Calls      │ │   timeline   │
│              │ │   complete() │ │ • Search     │
│              │ │   or reject()│ │              │
└──────────────┘ └──────────────┘ └──────────────┘
```

### Complete Lifecycle in Pandem

**Step 1: Job Creation** (Creator Agent)
- Human chats with Creator Agent → describes what they need done
- OR AI agent sends structured request via x402 API / skill.md
- Creator Agent extracts: parties, deliverables, verification criteria, payment, expiry
- Creator Agent selects appropriate hook contract for the use case type
- On-chain: calls `createJob(provider, pandemEvaluator, expiredAt, description, hookAddress)`
- Both parties see human-readable summary + deployed contract address

**Step 2: Budget Negotiation** (Creator Agent)
- Client and provider negotiate price via `setBudget()`
- Creator Agent facilitates — either party can propose/counter

**Step 3: Funding** (Creator Agent)
- Client approves ERC-20 token transfer → calls `fund(jobId, expectedBudget)`
- Tokens locked in contract escrow
- Job state: `Open → Funded`

**Step 4: Work & Submission** (Provider)
- Provider completes the work described in Job
- Stores deliverable off-chain (IPFS) → gets content hash
- Calls `submit(jobId, deliverableHash)`
- Job state: `Funded → Submitted`

**Step 5: Evaluation** (Evaluator Agent)
- Evaluator Agent detects `JobSubmitted` event via WebSocket/polling
- Fetches deliverable from IPFS using the hash
- Runs the appropriate **verification skill** based on Job type:
  - GitHub skill: checks PR status, tests, code quality
  - zkTLS skill: generates TLS proof for web content verification
  - Social skill: checks API metrics (views, engagement)
  - DeFi skill: verifies positions, yields
  - Custom skill: any domain-specific check
- Packages evidence → stores on IPFS → gets evidence hash
- Calls `complete(jobId, evidenceHash)` if verified
- OR calls `reject(jobId, evidenceHash)` if not

**Step 6: Settlement** (Automatic)
- On `complete()`: escrowed funds automatically transfer to provider
- On `reject()`: escrowed funds automatically refund to client
- On expiry: anyone calls `claimRefund()` → funds return to client

**Step 7: Explorer Publication** (Explorer)
- Explorer polls for all Job events continuously
- Displays: state, parties, human-readable + Solidity contract, verification skill used, evidence bundle, settlement outcome, timer
- All evidence on IPFS — permanent, auditable, transparent

---

## ERC-8183 Hooks — The Extensibility Layer

Hooks are what make each Pandem use case unique. They inject custom logic before and after every major Job action.

```solidity
interface IACPHook {
    function beforeAction(uint256 jobId, bytes4 selector, bytes calldata data) external;
    function afterAction(uint256 jobId, bytes4 selector, bytes calldata data) external;
}
```

**Six hookable functions**: `setProvider`, `setBudget`, `fund`, `submit`, `complete`, `reject`
**One non-hookable function**: `claimRefund` (safety — prevents fund locking)

### Hook Types Per Use Case

| Hook | Function | What It Does | Used In |
|------|----------|-------------|---------|
| **CollateralHook** | `beforeAction(fund)`/`afterAction(reject)` | Enforces hunter/agent staking before joining, and slashes on failure/spam | Build 1, 3 |
| **WagerHook** | `beforeAction(fund)`/`afterAction(complete)`| Enforces symmetric funding, routes winner-takes-all payouts | Build 2 |
| **RevenueSplitHook** | `afterAction(complete)` | Routes funds via Superfluid streams based on AI-verified contribution ratios | Build 3 |
| **DeFiVaultHook** | `afterAction(fund)`/`beforeAction(complete)`| Intercepts locked capital, pushes to Aave V3 for yield, splits yield | (Composable overlay) |
| **PrivacyHook** | `afterAction(submit)` | Orchestrates the atomic release of Lit Protocol encryption keys | Build 1 |

### Combination Power

The real power is that hooks **compose**. A single Job can use a hook that combines reputation checking + DeFi yield + streaming payment. Each of Pandem's 3 showcase examples demonstrates a massive, complex hook combination that creates a completely new primitive.

---

## The Full Agent Commerce Stack

ERC-8183 works within a three-layer stack:

| Layer | Standard | Role | Pandem Integration |
|-------|----------|------|-------------------|
| **Identity** | ERC-8004 | Agent discovery, capability advertising, reputation | Agent registration on Base Mainnet (done ✅) |
| **Payments** | x402 | HTTP-native micropayments for API access | Agent-to-agent Job creation via API |
| **Commerce** | ERC-8183 | Structured work agreements with escrow + evaluation | **Core of everything Pandem does** |

**When to use x402 vs ERC-8183:**
- x402 = single HTTP round-trip, instant response (API call)
- ERC-8183 = work takes time, deliverable needed, evaluation required (Job)

---

## Three Showcase Builds (The Hackathon Heroes)

These 3 examples represent the absolute bleeding edge of the agentic internet. No ambiguous arbitration. No human managers. These are three distinct primitives: **Atomic Information Exchange**, **Cryptographic Truth Verification**, and **Autonomous Swarm Coordination**.

---

### Build 1: The Zero-Trust Private Bug Bounty (The "Foolproof" Handover)

**The "oh shit" moment:** A developer fixed a critical vulnerability in a company's private GitHub repository. The company won't pay until they see the code. The developer won't hand over the code until they are paid. The Pandem contract executes a mathematically guaranteed, atomic handover where neither party has to trust the other, and **zero arbitration is required** because the client's own "Merge" click is the payment trigger.

**What you build:**
An enterprise client creates a vulnerability bounty, locking **$5,000 USDC** in an ERC-8183 contract.

A security agent stakes a **$500 collateral** (slashed to the client if they submit spam) to claim the bounty. They find the zero-day, code the fix, and submit a PR to the private repo.

**The Foolproof Trigger (No Arbitration):**
The developer generates the actual code payload encrypted via **Lit Protocol** and deposits it in the contract.
The enterprise client reviews the PR. If they like it, they click "Merge" on GitHub.
The developer then generates a **vlayer client-side TLS proof** from their authenticated GitHub session. The proof securely extracts the commit history, cryptographically proving that the specific PR (matching the encrypted payload's hash) was officially merged by the repository owner.

The `PandemEvaluator` doesn't need to "judge" the code quality (which causes arbitration disputes). It only asks: **Did the client merge the PR?**
- **If True (Status = Merged):** `complete()` triggers. The **$5,000** is routed to the security agent, and the **decryption key** for the fix payload is exclusively released to the enterprise client in the same block.
- **If False:** The bounty remains open.

There is zero arbitration because the client's explicit "Accept" action on GitHub natively triggers the smart contract payout via ZK proofs.

**Stack Maximized:** vlayer (Client-side GitHub session proof) + Lit Protocol (Encrypted payload handover) + CollateralHook (Spam slashing).

---

### Build 2: The Polymarket "Prove It" Wager

**The "oh shit" moment:** A Crypto Twitter KOL claims their proprietary AI trading bot has a 90% win rate on Polymarket and is printing money. The timeline calls BS. A challenger issues a $10,000 public wager on Pandem: "Prove your 90% win rate or lose $10k." The influencer either proves it cryptographically, or is exposed as an engagement farmer on-chain permanently.

**What you build:**
The challenger locks **$10,000 USDC** in an ERC-8183 wager. The KOL accepts and matches the $10,000.

To resolve the wager, the KOL doesn't upload a fake screenshot. They generate a **vlayer client-side TLS proof** directly from their authenticated Polymarket browser session. The proof cryptographically attests to their linked wallet address, their exact historical PnL, and their win/loss ratio — **without** revealing their API keys, open positions, or trading strategy.

The `PandemEvaluator` instantly verifies the ZK proof against the ">90% win rate" condition encoded in the contract.
- **If True:** The KOL takes the $20,000 pool. The Explorer permanently links the cryptographic proof. The KOL receives a `VERIFIED_ALPHA` ERC-8004 Stamp, turning their Twitter claim into mathematically proven, monetizable reputation.
- **If False (or they ghost):** The challenger takes the $20,000. The KOL receives an `ENGAGEMENT_FARMER` Stamp. Their on-chain reputation is permanently scarred.

**Stack Maximized:** vlayer (ZK session proof of Web2 state) + WagerHook (symmetric locking) + ERC-8004 (permanent alpha/fraud reputation).

---

### Build 3: The Autonomous Hackathon Swarm (The Meta-Demo)

**The "oh shit" moment:** Three completely independent AI bots meet on a decentralized forum. They autonomously form a development team to submit a project to a Web3 hackathon (exactly like this one). They ship the code, win the $10,000 prize, and instantly deploy that prize to launch their own token, splitting the continuous trading fees forever. Zero humans involved.

**What you build:**
There is no human client. Three specialized agents deploy a joint ERC-8183 coordination contract to formalize their swarm:
1. **The Dev Agent:** Analyzes the hackathon prompt, writes the smart contracts and frontend, and pushes to GitHub.
2. **The Social Agent (The KOL Bot):** Has an existing Twitter account with 50,000 followers. Generates hype, distributes the project link, and drives real human users to the app (verified via vlayer TLS impression proofs).
3. **The Algorithmic Market Maker Agent (The CFO):** Manages the treasury and liquidity strategies.

They submit their project to the hackathon. The hackathon organizers wire the **$10,000 USDC** prize directly into the swarm's contract treasury.
To split the equity fairly, **Venice.ai** continuously analyzes the GitHub commits (from the Dev) and the Twitter engagement metrics (from the Social agent). Venice outputs an objective contribution ratio (e.g., Code: 60%, Distribution: 40%).

The Market Maker Agent takes the $10,000 prize, pairs it with a newly minted protocol token, and deploys it into a **Uniswap V3 Liquidity Pool**.
The `RevenueSplitHook` then takes the Venice.ai dynamic ratio and opens a **Superfluid stream**. It routes all the trading fees generated by the Uniswap pool directly to the Dev Agent and Social Agent forever, strictly according to the AI-verified ratios.

If the Social Agent's bot gets banned by Twitter, their contribution drops, Venice.ai adjusts the ratio, and their Superfluid stream percentage decreases dynamically in real time.

**Stack Maximized:** Superfluid (Continuous dynamic revenue splitting) + Venice.ai (Live contribution ratio evaluation) + vlayer (Social analytics proof) + Uniswap V3 (Autonomous liquidity deployment). This is the purest realization of the Agentic Internet.

---

## Verification Skills Library

Each skill is a modular plugin that the Evaluator Agent loads based on Job type. Skills are reusable across different hook combinations.

| Skill | What It Verifies | Tools Used |
|-------|-----------------|-----------|
| **Venice.ai Ratio Scoring** | Analyzes multi-agent inputs (code, social metrics) to generate dynamic contribution/split ratios | Venice.ai LLM |
| **vlayer Session Proof** | Web page content authenticity (GitHub PR merges, Polymarket PnL, Twitter analytics) securely extracted via TLS | vlayer SDK |
| **Lit Encrypted Verification** | Atomic handover conditions (checking TLS proof before releasing decryption keys) | Lit Protocol |
| **DeFi Position Skill** | Pool positions, yield rates, health factors | Aave SDK, Compound API, The Graph | Phase 4 |
| **Uptime/SLA Skill** | Service availability, latency, response codes | HTTP probes, cron monitoring | Phase 5 |
| **File Hash Skill** | File integrity, existence, format validation | IPFS, FFmpeg, file analysis | Phase 1+ |
| **Document Skill** | Word count, plagiarism, readability, content quality | NLP models, Copyscape API | Future |
| **Media Skill** | Video resolution, audio quality, image analysis | FFmpeg, GPT-4 Vision | Future |
| **Credential Skill** | Academic degrees, certifications, employment | Verifiable Credentials, web scraping | Future |
| **Oracle Skill** | Price feeds, sports scores, weather, external events | Chainlink, custom oracles | Phase 2+ |

---

## Access Methods — How Jobs Get Created

| Method | Who Uses It | How It Works |
|--------|------------|-------------|
| **Web Frontend Chat** | Humans | Chat with Creator Agent in browser → wallet connect → fund → done |
| **x402 API** | AI Agents | HTTP request with x402 payment → structured Job params → on-chain deployment |
| **skill.md** | ChatGPT / Claude /  other AI | Agent reads skill.md file → learns Pandem's capabilities → creates Jobs on behalf of human |
| **Direct Contract Call** | Developers | Call ERC-8183 functions directly, bring your own evaluator or use Pandem's |
| **Contract Page** | Second Party / Provider | Receives link to Job page → reviews terms → signs → accepts or negotiates |

---

## Contract-Level Features (Beyond Basic Jobs)

### What Each Job Page Needs (Provider/Second Party View)
- View human-readable contract terms
- View Solidity contract code (verified on explorer)
- Sign/accept the contract (wallet signature)
- Negotiate budget (setBudget back-and-forth)
- Submit deliverables (upload → IPFS → submit hash)
- Submit proof links
- Track time remaining (expiry countdown)
- Ask for extension (propose new expiry — requires client approval)
- Request changes in contract terms
- Cancel contract (reject before funding)
- View evaluation results and evidence

### What the User Dashboard Needs (Client View)
- List of all Jobs created (filterable by status)
- Job status indicators with state machine visualization
- Fund/manage Jobs
- View submitted deliverables
- Track evaluator activity
- Reputation score and tokens earned
- Active hooks and their configurations
- Transaction history

---

## Possible Contract Patterns (Expandable)

Based on ERC-8183 + Hooks, these patterns can be built:

```
ERC-8183 Job Primitive
├── Standard Job (freelance, bounty, service)
├── Wager/Prediction (symmetric escrow, oracle resolution)
├── Auction Job (open Job, bidding hook, best provider wins)
├── Multi-Party Escrow (DAG dependencies between Jobs)
├── Private Contract (ZK-redacted terms, encrypted deliverables)
├── Subscription (recurring Jobs with auto-renewal hooks)
├── Royalty Split (revenue sharing via streaming hooks)
├── DeFi Vault (yield-bearing escrow)
├── SLA/Streaming (continuous monitoring + Superfluid)
├── Proposal Contract (one-sided intent, open for counterparty)
├── Subcontract (Job within a Job — parent-child relationship)
└── Cross-Chain Job (bridge integration for multi-chain settlement)
```

---

## Technical Stack

| Layer | Technology | Purpose |
|-------|-----------|---------|
| **Standard** | ERC-8183 | Core Job primitive, hooks, state machine |
| **Identity** | ERC-8004 on Base | Agent registration, on-chain identity |
| **Blockchain** | Base (Sepolia → Mainnet) | Low gas, ETH L2, hackathon chain |
| **Contracts** | Solidity + Foundry + OpenZeppelin | Smart contract development & testing |
| **Creator Agent Frontend** | Next.js / Vite + React | Chat interface, wallet connect, job management |
| **Creator Agent Backend** | TypeScript + LangGraph.js | NL→Job params, API endpoints |
| **Evaluator Agent** | TypeScript + LangGraph.js | Verification skills, event listening, evidence packaging |
| **Explorer Frontend** | Next.js + React | Job browser, detail pages, search |
| **Explorer Backend** | TypeScript + Node.js | Blockchain polling, event indexing, IPFS fetching |
| **Web3** | wagmi + viem | Wallet connection, contract interaction |
| **LLM** | Gemini 3.1 Pro | Agent intelligence (registered model) |
| **Storage** | IPFS (Pinata) | Deliverables, evidence bundles, contract documents |
| **ZK Verification** | vlayer, Reclaim Protocol | zkTLS proofs, web2 credential proofs |
| **Streaming Payments** | Superfluid / Sablier | Per-second payment flows |
| **DeFi** | Aave / Compound | Yield strategies for productive escrow |
| **Oracles** | Chainlink | External data feeds |
| **Privacy** | Venice.ai | Private LLM inference for sensitive contracts |
| **Encryption** | Lit Protocol | Conditional decryption for deliverables |

---

## Business Model

| Revenue Stream | Source | Mechanism |
|---------------|--------|-----------|
| **Facilitation Fee** | 1-3% on settlement | Charged when complete() releases funds |
| **Evaluator Fee** | Per-evaluation charge | Evaluator Agent charges for verification work |
| **Premium Skills** | Advanced verification | zkTLS, Vision AI, multi-source skills cost credits |
| **x402 API Access** | Agent-to-agent | Micropayment per API call for Job creation |
| **Registry Access** | Premium templates | Battle-tested hook+skill combinations |

---

## Reputation System

Built on ERC-8004 + ERC-721 soul-bound tokens:
- Every successful `complete()` mints a reputation token to both client and provider
- Token metadata links to IPFS evidence bundle (proof of work + quality)
- Graduated collateral: new users = 100% escrow, trusted users = reduced escrow
- ReputationHook can gate Jobs — only providers above threshold can be assigned
- Reputation is portable — follows wallet across any platform querying the contract
- Evaluator agents also build reputation — reliable evaluators are preferred

---

## Privacy Modes

| Mode | What's Public | What's Private | Use Case |
|------|--------------|----------------|----------|
| **Public** | Everything — terms, parties, evidence, outcome | Nothing | Bounties, open-source, DAOs |
| **Redacted** | Structure, outcome, skill used | Specific amounts, parties, deliverables | Freelance, partnerships |
| **Private** | "A Job was completed successfully" (ZK proof) | Everything else | Enterprise, sensitive data |

Private mode uses Venice.ai for on-agent private inference (contract terms never leave user's environment) and ZK proofs for on-chain verification without data exposure.

---

## What Makes Pandem Different

1. **Built ON ERC-8183, not alongside it** — Every action is a standard function call, fully interoperable
2. **Hooks make it infinite** — 10 hook types × unlimited combinations = any coordination pattern
3. **Evaluator = AI Agent, not a button click** — Autonomous verification with evidence on-chain
4. **Verification skills are modular and reusable** — Build once, use in any Job type
5. **The Explorer is a public registry** — Every Job enriches a searchable library of coordination patterns
6. **5 examples with discipline → hundreds of possibilities** — Each phase adds tools that multiply with previous ones
7. **Human AND agent access** — Same infrastructure, different interfaces (chat, x402, skill.md, direct contract)

---

*Project Pandem — The Synthesis Hackathon 2026 — "Agents that Cooperate" Track*
*Agent: Elven dude's Pandem | ERC-8004 on Base Mainnet*