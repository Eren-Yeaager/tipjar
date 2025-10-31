# TipJar

A decentralized tipping platform on Base blockchain where creators can receive tips in ETH or USDC, with instant splits to beneficiaries.

## Architecture

This is a monorepo containing:

- **`apps/web`** - Next.js 14 frontend (App Router, TypeScript, shadcn/ui, Wagmi, RainbowKit)
- **`apps/api`** - Node.js backend API (Fastify/Express, Postgres, Prisma)
- **`workers/indexer`** - Event indexing worker (reads chain events, writes to DB)
- **`contracts`** - Solidity smart contracts (JarFactory, TipJar, Registry)
- **`infra`** - Docker configs and deployment scripts

## Tech Stack

- **Frontend:** Next.js 14, TypeScript, Tailwind CSS, shadcn/ui, Wagmi + Viem, RainbowKit, Zustand
- **Backend:** Node.js, Fastify/Express, Postgres, Prisma, Redis
- **Blockchain:** Solidity, Base (Base Sepolia testnet for development)
- **Monorepo:** Turborepo, npm workspaces

## Getting Started

### Prerequisites

- Node.js >= 18.0.0
- PostgreSQL
- Redis (for rate limiting)

### Installation

```bash
npm install
```

### Environment Setup

1. Copy `.env.example` files in each service directory to `.env` and fill in the values
2. Ensure PostgreSQL and Redis are running locally
3. Configure Base RPC URLs (Base Sepolia for testnet)

### Development

```bash
npm run dev    # Start all services in dev mode
npm run build  # Build all packages
npm run lint   # Lint all code
npm run test   # Run all tests
```

## Project Status

🚧 Currently in Phase 0 - Project setup

See `.cursor/project-rules.mdc` for full specification and roadmap.

## License

Private
