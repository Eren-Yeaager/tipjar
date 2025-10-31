# Event Documentation

This document defines all events emitted by TipJar contracts that the indexer will subscribe to.

## Events Overview

The indexer subscribes to events on Base to build off-chain analytics and maintain the database state.

## Event Schemas

### JarCreated

**Contract:** `JarFactory`  
**Event Signature:** `JarCreated(address indexed owner, address indexed jar, string indexed handle)`

**Description:** Emitted when a new TipJar is created.

**Parameters:**

- `owner` (address, indexed): The creator/owner of the jar
- `jar` (address, indexed): The address of the deployed TipJar contract
- `handle` (string, indexed): Unique handle identifier (e.g., "alice")

**Indexer Actions:**

- Insert new jar record in `jars` table
- Link jar to owner in `users` table (create user if doesn't exist)
- Store handle uniqueness mapping

**Topic Calculation:**

- Topic[0]: `keccak256("JarCreated(address,address,string)")`
- Topic[1]: owner address
- Topic[2]: jar address
- Topic[3]: keccak256(handle)

---

### TipReceived

**Contract:** `TipJar`  
**Event Signature:** `TipReceived(address indexed from, address indexed token, uint256 amount)`

**Description:** Emitted when a tip is received (ETH or ERC20).

**Parameters:**

- `from` (address, indexed): Address that sent the tip
- `token` (address, indexed): Token address (address(0) for ETH)
- `amount` (uint256): Amount tipped (in token's smallest unit)

**Indexer Actions:**

- Insert new tip record in `tips` table
- Update jar totals
- Calculate USD equivalent (if price oracle available)
- Update leaderboard for last 7 days

**Topic Calculation:**

- Topic[0]: `keccak256("TipReceived(address,address,uint256)")`
- Topic[1]: from address
- Topic[2]: token address

**Note:** Token address `0x0000000000000000000000000000000000000000` represents ETH.

---

## Indexer Configuration

### Confirmation Blocks

**Recommended:** 5 blocks  
**Rationale:** Base has fast finality (~2s per block), but 5 blocks ensures reorg protection.

### Event Topics

JarCreated: 0x[TOPIC_HASH_FROM_ABI]
TipReceived: 0x[TOPIC_HASH_FROM_ABI]

### Filtering

The indexer should filter logs by:

1. Contract addresses (JarFactory and all deployed TipJars)
2. Event topic[0] (event signature)
3. Block range (with gap detection)

## Backfill Strategy

On startup or after downtime:

1. Query latest processed block from database
2. Calculate safe start block: `latest - confirmationBlocks`
3. Fetch logs in batches (max 10,000 blocks per request)
4. Process events in chronological order
5. Handle reorgs by tracking block hashes
