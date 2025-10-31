# Phase 1 - Contracts Spec & Events Summary

## Status

✅ Interfaces Complete | ⏳ Implementation Pending | ⏳ Testnet Deploy Pending

## Deliverables Completed

### 1. Contract Interfaces ✅

- **ITipJar** (`contracts/src/interfaces/ITipJar.sol`)
  - `tipETH()` function
  - `tipERC20()` function
  - `TipReceived` event
- **IJarFactory** (`contracts/src/interfaces/IJarFactory.sol`)
  - `createJar()` function
  - `JarCreated` event
- **IRegistry** (`contracts/src/interfaces/IRegistry.sol`)
  - `isTokenAllowed()` view function
  - `treasury()` view function
  - `feeBps()` view function

### 2. Event Documentation ✅

- **EVENTS.md** (`contracts/docs/EVENTS.md`)
  - Complete event schemas
  - Topic calculations
  - Indexer configuration
  - Backfill strategy

### 3. Architecture Decision Records ✅

- **ADR-01** (`contracts/docs/ADR-01-ROUNDING-POLICY.md`)
  - Rounding & remainder policy documented
  - Examples provided
  - Edge cases addressed

## Pending Items

### Additional ADRs (to be created in implementation phase)

- [ ] ADR-02: Fee collection strategy
- [ ] ADR-03: Handle uniqueness & collision policy
- [ ] ADR-04: Event schema and indexer confirmations (partially covered in EVENTS.md)

### Implementation Phase (Phase 1 continuation)

- [ ] Implement TipJar contract
- [ ] Implement JarFactory contract
- [ ] Implement Registry contract
- [ ] Write unit tests
- [ ] Deploy to Base testnet
- [ ] Verify events in block explorer

## Key Design Decisions

### Rounding Policy (ADR-01)

- **Decision:** Floor rounding (truncation) with remainder to treasury
- **Rationale:** Prevents over-distribution, deterministic, simple
- **Edge Cases:** Very small tips (< 100 wei) may result in zero for some beneficiaries

### Constraints

- Max 5 beneficiaries per jar
- Sum of beneficiary bps + fee bps must equal 10000 (100%)
- Only allowlisted tokens (ETH, USDC) in MVP
- Non-upgradeable jars for MVP

### Security Posture

- Reentrancy guard required on tip paths
- Bounded loops (max 5 beneficiaries)
- Token allowlist enforcement
- No admin keys to move user funds

## Next Steps

1. **Implementation:** Begin implementing contracts based on interfaces
2. **Testing:** Write comprehensive tests before deployment
3. **Deployment:** Deploy to Base Sepolia testnet
4. **Verification:** Confirm events appear correctly in block explorer

## Acceptance Criteria Status

- ✅ ABIs/Interfaces defined
- ✅ Events defined with documentation
- ✅ Edge cases documented (rounding policy)
- ⏳ Testnet deployment (pending implementation)
- ⏳ Events observed in block explorer (pending deployment)
