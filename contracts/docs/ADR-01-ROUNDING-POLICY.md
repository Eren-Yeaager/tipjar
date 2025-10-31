# ADR-01: Rounding & Remainder Policy in `_splitAndPay`

## Status

Proposed

## Context

When splitting a tip amount among multiple beneficiaries and a treasury fee, we need to handle:

1. **Rounding errors:** Division in Solidity truncates, so we may lose precision
2. **Remainder distribution:** After splitting, there may be a small remainder due to rounding

Example: Tip of 100 wei with 3 beneficiaries (33.33% each):

- 33% = 33 wei (truncated)
- 33% = 33 wei (truncated)
- 33% = 33 wei (truncated)
- Total distributed: 99 wei
- Remainder: 1 wei

## Decision

### Rounding Strategy

- **Use floor rounding (truncation):** Always round down to prevent over-distribution
- **Distribute remainder to treasury:** Any remainder from rounding errors goes to the treasury
- **Validate invariant:** Sum of all splits + fee must equal 100% (10000 basis points) before deployment

### Implementation Approach
