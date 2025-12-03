# Node.js + React Rebuild Blueprint

This document captures a concrete plan to recreate the legacy Rails application using a modern Node.js backend and a React frontend. The intent is to execute this work on a dedicated branch (e.g., `nodejs-rewrite`) separate from the legacy Rails code until the new stack is production-ready.

## Goals
- Preserve existing product capabilities: authentication and account lifecycle, role/resource-based authorization, admin controls, CMS pages/announcements, client records with casenotes, and configurable settings.
- Deliver a maintainable TypeScript codebase with automated tests and a clear migration path for existing data.
- Allow incremental validation through API and UI test coverage.

## Proposed technology choices
- **Backend:** NestJS (Node.js + TypeScript) with Prisma ORM and PostgreSQL.
- **Auth:** Passport local strategy for login, JWT access/refresh tokens, Nodemailer for activation/reset emails.
- **Frontend:** React + Vite + TypeScript with React Router, component library (e.g., Chakra UI or MUI), and react-query for data fetching.
- **Testing:** Jest + Supertest for backend; Vitest/Testing Library + Playwright (optional) for frontend.
- **Tooling:** ESLint, Prettier, commitlint/husky optional; docker-compose for local dev.

## Backend implementation plan (NestJS)
1. **Project scaffold**
   - Generate a NestJS app (`nest new api`) inside `node/api/` on the new branch.
   - Add Prisma with PostgreSQL connection; model tables to mirror legacy schema (`users`, `profiles`, `roles`, `resources`, `roles_resources`, `users_roles`, `pages`, `announcements`, `clients`, `casenotes`, `settings`).
   - Configure environment management (dotenv) and global validation pipes with class-validator/class-transformer.

2. **Domain modules**
   - **Auth module:**
     - Local username/password login backed by user state machine (pending/active/suspended/deleted).
     - JWT access + refresh tokens; middleware/guards to enforce authenticated requests.
     - Perishable-token workflows for account activation and password reset; email delivery via Nodemailer adapter.
   - **Users module:**
     - CRUD endpoints for account creation and profile updates.
     - Admin-only mutations for state transitions (activate/suspend/delete) and password reset triggers.
   - **Authorization module:**
     - Guards/interceptors that load role/resource claims from JWT and compare against resource strings matching the Rails model (`controller#action` style).
     - Seeder for default roles/resources/settings equivalent to the legacy defaults.
   - **Content modules:** Pages, Announcements, Settings with CRUD and pagination where applicable.
   - **Clients module:** Clients and nested Casenotes routes; pagination and author tracking on notes.

3. **Cross-cutting concerns**
   - Global exception filter for consistent API responses; logging middleware.
   - DTO validation reflecting existing Rails validations (e.g., slug format for pages, required titles/bodies).
   - Swagger/OpenAPI documentation for all routes.
   - Background-friendly email interface (abstract provider) to swap SMTP/provider in deployment.

4. **Testing strategy**
   - Unit tests for guards, services, and DTO validation.
   - Integration tests with Supertest exercising auth flows (signup/activate/login/refresh/reset) and authorization matrix (role/resource access).
   - API contract snapshots via Pact or OpenAPI snapshots to keep frontend aligned.

## Frontend implementation plan (React)
1. **Project scaffold**
   - Create `node/web/` with Vite + React + TypeScript; configure absolute imports and environment-based API URLs.
   - Add React Router with nested layouts for public pages, authenticated dashboard, and admin area.
   - Install UI kit and form handling (react-hook-form or Formik) plus zod/yup for validation.

2. **Auth + state management**
   - Auth context storing access/refresh tokens and user claims; auto-refresh tokens on expiry and handle forced logout on suspension/deletion.
   - Route guards mirroring backend authorization (role/resource), showing access-denied messaging consistent with legacy behavior.

3. **Feature screens**
   - **Auth flows:** login, signup, activation, forgot/reset password, troubleshooting.
   - **Dashboard:** overview plus navigation driven by role/resource access.
   - **Admin:** user management (state changes, password reset), roles/resources matrix, settings, announcements, and pages CRUD.
   - **Clients:** list/detail with casenote timeline and pagination; note creation/editing with author metadata.
   - **Pages:** public slug-based rendering and admin edit/create forms with validation.

4. **API client layer**
   - Typed fetch wrapper (axios/fetch) with interceptors for auth headers and refresh handling.
   - React Query hooks for CRUD endpoints with optimistic updates where safe.

5. **Frontend testing**
   - Component/unit tests with Vitest + Testing Library.
   - Integration/route tests for guarded navigation.
   - Optional Playwright smoke tests once API stabilizes.

## Data migration plan
1. Export existing database (matching `db/schema.rb`) to SQL/CSV.
2. Write a one-off migration script (Node + Prisma) to import data into the new schema, mapping:
   - Users + profiles and role/resource join tables.
   - Pages, announcements, settings, clients, casenotes.
3. Decide password approach: force resets or port Authlogic hashes if feasible; send activation/reset emails accordingly.
4. Validate migrated content via admin UI and compare record counts before cutover.

## Deployment considerations
- Use docker-compose for local dev (`postgres`, `api`, `web`).
- Provision staging/production with environment parity (e.g., Render/Fly/Heroku/Docker hosts) and CI pipelines running backend+frontend tests.
- Plan for incremental rollout: run Rails and Node stacks in parallel with a subset of users, then cut DNS once parity and migration verification are complete.

## Next steps
1. Create the new branch (e.g., `nodejs-rewrite`).
2. Scaffold `node/api` and `node/web` projects following the steps above.
3. Stand up database + minimal auth flow, then iterate through modules, completing migration and frontend features.
