# TipJar Runbook

Quick reference for common tasks and troubleshooting.

## Environment Setup

### First Time Setup

1. **Clone and install:**

   ```bash
   npm install
   ```

2. **Database setup:**
   - Ensure PostgreSQL is running locally
   - Create database: `createdb tipjar_dev`
   - Update `apps/api/.env` and `workers/indexer/.env` with `DATABASE_URL`

3. **Redis setup:**
   - Ensure Redis is running: `redis-server` or via Docker
   - Update `apps/api/.env` with `REDIS_URL=redis://localhost:6379`

4. **Environment variables:**
   - Copy `.env.example` to `.env` in each service directory
   - Fill in Base RPC URLs (use Base Sepolia testnet for development)
   - Get WalletConnect Project ID from https://cloud.walletconnect.com

## Common Commands

```bash
# Start all services
npm run dev

# Start specific service
npm run dev --workspace=apps/web
npm run dev --workspace=apps/api

# Build everything
npm run build

# Run linter
npm run lint

# Type check
npm run typecheck
```

## Common Issues

### Database Connection Errors

**Problem:** `Error: connect ECONNREFUSED 127.0.0.1:5432`

**Solution:**

- Verify PostgreSQL is running: `pg_isready`
- Check `DATABASE_URL` in `.env` files
- Ensure database exists: `createdb tipjar_dev`

### Port Already in Use

**Problem:** `Error: listen EADDRINUSE :::3000`

**Solution:**

- Find and kill process: `lsof -ti:3000 | xargs kill -9`
- Or change `PORT` in `.env` files

### Module Not Found Errors

**Problem:** `Cannot find module '@tipjar/...'`

**Solution:**

- Reinstall dependencies: `npm install`
- Rebuild: `npm run build`
- Clear Turbo cache: `rm -rf .turbo`

### TypeScript Errors in Monorepo

**Problem:** Type errors across workspaces

**Solution:**

- Ensure all packages have `tsconfig.json` that extends root config
- Run `npm run typecheck` from root
- Clear build outputs: `rm -rf */dist */build */.next`

## Development Workflow

1. Make changes in any workspace
2. Husky pre-commit hook will lint and format
3. Test locally before committing
4. Push to trigger CI (lint/test/build)

## Getting Help

- Check logs in service directories
- Review `.cursor/project-rules.mdc` for architecture decisions
- Check Base testnet block explorer for contract interactions
