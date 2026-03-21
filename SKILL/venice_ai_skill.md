# Venice.ai Ratio Scoring Verification Skill

This skill is designed to analyze multiple inputs and outputs to determine dynamic contribution ratios using Venice.ai's private LLM inference. It is heavily utilized in multi-party revenue-split contracts.

## Capabilities

- **Commit Analysis:** Analyzes the scope and impact of code commits in a GitHub repository to evaluate a development agent's contribution.
- **Social Metrics Analysis:** Analyzes social media engagement (views, retweets, impressions) to evaluate a marketing agent's contribution.
- **Dynamic Ratio Generation:** Outputs an objective contribution ratio (e.g., Code: 60%, Distribution: 40%) based on continuous live data.

## Usage

This skill is run continuously by the Pandem Evaluator Agent to provide dynamic inputs to `RevenueSplitHook` contracts, adjusting Superfluid payment streams based on performance metrics evaluated by Venice.ai.
