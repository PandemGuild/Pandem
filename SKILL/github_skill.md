# GitHub MCP Verification Skill

This skill is designed to interact with the GitHub API via the Model Context Protocol (MCP) to automatically verify conditions for bounty and development contracts.

## Capabilities

- **Merge Verification:** Checks if a specific Pull Request has been merged into the target branch.
- **Test Coverage Analysis:** Can query CI/CD pipelines (e.g., GitHub Actions) or coverage reports (e.g., Codecov) linked to a PR to ensure a minimum test coverage percentage (e.g., >90%).
- **Reviewer Status:** Verifies that a required number of designated independent security reviewers have approved the Pull Request before merge.

## Usage

This skill is typically invoked by the Pandem Evaluator Agent when a `JobSubmitted` event is detected for a GitHub-based bounty. The provider submits the PR URL or hash as the deliverable. The Evaluator Agent uses this skill to assert the `complete()` condition.
