
# Job-Posting-Platform

**Public repo:** https://github.com/didar044/Job-Posting-Platform

## Overview
A Laravel-based job posting platform with role-based access control (Admin, Employee, Jobseeker), job posting, applications, and Stripe payment integration for paid job applications.

---

## Deliverables (Included)
- Clean code in this GitHub repository.
- This `README.md` with setup, API endpoints, roles, and payment flow.
- Postman collection (`postman_collection.json`) with example requests (import into Postman).

---

## Setup (Local)

1. Clone the repo
```bash
git clone https://github.com/didar044/Job-Posting-Platform.git
cd Job-Posting-Platform
```

2. Install PHP dependencies
```bash
composer install
npm install
npm run build   # or npm run dev for development
```

3. Copy and configure `.env`
```bash
cp .env.example .env
# Edit .env and set DB and Stripe credentials:
# DB_CONNECTION=mysql
# DB_HOST=127.0.0.1
# DB_PORT=3306
# DB_DATABASE=hireme
# DB_USERNAME=root
# DB_PASSWORD=
# STRIPE_KEY=pk_test_xxx
# STRIPE_SECRET=sk_test_xxx
# DB_TABLE_PREFIX=hm_   # if you use prefixed table names
```

4. Generate app key & run migrations
```bash
php artisan key:generate
php artisan migrate
php artisan db:seed --class=AdminUserSeeder
```

5. Serve
```bash
php artisan serve
```

---

## Important files & notes
- `database/seeders/AdminUserSeeder.php` — creates a default admin user (`admin@hireme.com`).
- `routes/api.php` — main API routes and role-protected groups.
- Authentication uses JWT / token-based middleware (`auth:api` in routes). Ensure your `config/auth.php` and guard are configured to use the API driver you expect (JWT or Passport).
- Stripe webhook route is located at `/api/applications/stripe/webhook` (used by both admins and jobseekers in this project as configured).

---

## Roles & Permissions
- **admin**
  - Full access to users, jobs, applications, analytics.
- **employee**
  - CRUD access to jobs and manage candidate applications (accept / reject).
- **jobseeker**
  - Can view jobs and apply (may need to pay when application fee is enabled).

## If You want  Create Admin/Employee/JobSekeer   
  {
    "name": "**",
    "email": "***",
    "password": "****",
    "password_confirmation": "***",
   
}  

Seeded admin credentials (from seeder):
- Email: `admin@hireme.com`
- Password: `password123`


Seeded employee credentials (from seeder)::(Create Employee role use this email),
- Email: `employee@example.com`


---

## API Endpoints (summary)

### Auth (public)
- `POST /api/auth/register` — register user (role assignment may be manual in DB or via admin).
- `POST /api/auth/login` — login, returns token.

### Auth (protected)
- `POST /api/auth/logout` — revoke token.
- `POST /api/auth/refresh` — refresh token.
- `POST /api/auth/me` — current user info.

### Users (admin only)
- `GET /api/users` — list users
- `POST /api/users` — create user
- `GET /api/users/{id}` — show user
- `PUT/PATCH /api/users/{id}` — update user
- `DELETE /api/users/{id}` — delete user

### Jobs
- `GET /api/jobs` — public list of jobs
- (admin/employee) `POST /api/jobs` — create job
- (admin/employee) `GET /api/jobs/{id}` — show job
- (admin/employee) `PUT /api/jobs/{id}` — update job
- (admin/employee) `DELETE /api/jobs/{id}` — delete job

### Applications
- `POST /api/applications` — submit an application (may trigger Stripe payment flow)
- `GET /api/applications` — list applications (admin/employee)
- `GET /api/applications/{id}` — application details
- `PATCH /api/applications/{id}/status` — update application status (accept/reject) — employee
- `POST /api/applications/stripe/webhook` — Stripe webhook endpoint (no auth)

### Analytics
- `GET /api/analytics/company` — company analytics (admin)

---

## Payment Flow (Stripe) — high level
1. Jobseeker starts an application that requires a fee.
2. Server creates a Stripe Checkout session or PaymentIntent with metadata linking to the application (application_id).
3. Frontend redirects the user to Stripe Checkout (or uses Stripe Elements).
4. On successful payment, Stripe hits `/api/applications/stripe/webhook` with the event (e.g., `checkout.session.completed` or `payment_intent.succeeded`).
5. Webhook handler validates event signature, finds the `application_id` in metadata, and marks the application as paid/complete in DB.

**Important**
- Use `STRIPE_SECRET` and `STRIPE_WEBHOOK_SECRET` in `.env`.
- When testing locally, use `stripe CLI` to forward webhooks or deploy webhook publicly.

---

## Postman
- Import `postman_collection.json`.
- The collection contains example requests for:
  - Auth register/login
  - Authenticated endpoints (requires Bearer token)
  - Jobs CRUD
  - Applications create / status update
  - Stripe webhook (example raw webhook payload)

---

## How I validated the repo
I reviewed the repository structure and `routes/api.php` to map endpoints and confirmed a seeder `AdminUserSeeder.php` exists to create an admin user.

---

## Next steps / recommendations
- Rotate the seeded admin password and secure `.env`.
- Add a proper Roles & Permissions package like [spatie/laravel-permission] and ensure role checks are centralized.
- Add Postman environment variables (base URL, bearer token) for easier importing.
- Add unit/feature tests for auth, jobs, applications, and payment webhook.

---

##  Databases
This project includes a pre-built database dump file for easy setup.  
The SQL file is located at: **databases/New Project 20250831.sql**
You can import this file directly into your MySQL database to get all the required tables, data, and roles **without** running migrations manually.




