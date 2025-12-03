# Node.js rewrite workspace

This directory hosts the new Node.js + React implementation that will replace the legacy Rails application. The initial scaffold focuses on a NestJS API; a React frontend will be added under `node/web`.

## Layout
- `api/`: NestJS TypeScript service scaffold with global validation, Prisma wiring, and initial domain modules.
- `web/`: React/Vite frontend scaffold with placeholder routes ready to bind to the API.
- `.gitignore`: Ignores build artifacts, environment files, and `node_modules` across the workspace.

## Getting started (API)
1. Install dependencies (Node 18+):
   ```bash
   cd node/api
   npm install
   npm run prisma:generate
   ```
2. Run the development server:
   ```bash
   npm run start:dev
   ```
3. Visit `http://localhost:3000/` for a welcome payload and `http://localhost:3000/health` for a health check.

To seed roles/resources and an admin user (after `prisma generate`):
```bash
npm run prisma:seed
```

To enable real email delivery for activation/reset links, set SMTP credentials in `.env`:
```bash
MAIL_FROM=no-reply@example.com
PUBLIC_WEB_URL=http://localhost:4173
SMTP_HOST=smtp.example.com
SMTP_PORT=587
SMTP_USER=apikey
SMTP_PASSWORD=secret
SMTP_SECURE=false
```
If SMTP values are omitted the service will log email payloads instead of sending them.

## Modules currently scaffolded
- Auth (register/login with JWT and session metadata)
- Users (list/detail/create, state transitions, role assignment)
- Access control (roles/resources and role-resource attachment)
- Content (pages, announcements, settings) with CRUD + pagination helpers
- Clients (clients + casenotes) with paginated listings and recent-note previews
- Health/root endpoints

Environment variables live in `.env` (see `.env.example`). New auth flows use `PERISHABLE_TOKEN_TTL_HOURS` and optional `ADMIN_EMAIL`/`ADMIN_PASSWORD` seed values.
Seed data now aligns with the Nest resource strings (e.g., `pages:list`, `users:update-state`, `access-control:roles:attach`) used by the authorization guard.

## Getting started (web)
1. Install dependencies:
   ```bash
   cd node/web
   npm install
   npm run dev
   ```
2. Navigate to `http://localhost:4173` to view placeholder routes that will be wired to the API.

## Next steps
- Add admin CRUD screens in React to exercise the new pagination-aware endpoints for content and clients.
- Add email transport configuration to replace the logging-only notification adapter.
- Flesh out the React frontend in `node/web` to consume the new endpoints.
