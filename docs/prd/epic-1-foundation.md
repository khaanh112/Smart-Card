# Epic 1: Foundation & Core Infrastructure

## Epic Goal

Xây dựng foundation vững chắc cho toàn bộ platform bao gồm Docker environment, database schema với Prisma, authentication system với JWT + OAuth, và basic user management. Epic này delivers một working API với health check, user registration/login, và seeded data, providing technical foundation cho tất cả subsequent features.

---

## Story 1.1: Project Setup & Docker Environment

**As a** developer,
**I want** a fully configured Docker development environment,
**so that** team có consistent development setup và dễ dàng onboard new developers.

### Acceptance Criteria

1. Monorepo structure được setup với frontend/, backend/, shared/, và docker/ folders
2. Docker Compose file định nghĩa tất cả services: frontend (Vite), backend (Express), postgres, redis, pgadmin
3. Tất cả containers start successfully với `docker-compose up`
4. Frontend accessible tại localhost:5173, backend tại localhost:3000, pgAdmin tại localhost:5050
5. Hot reload hoạt động cho cả frontend (Vite HMR) và backend (nodemon)
6. Environment variables được load từ .env files với validation
7. README.md có clear instructions cho setup và development workflow
8. pgAdmin pre-configured với postgres connection

---

## Story 1.2: Prisma Setup & Database Schema

**As a** developer,
**I want** a well-designed database schema với Prisma ORM,
**so that** data structure support tất cả requirements và có thể evolve safely với migrations.

### Acceptance Criteria

1. Prisma initialized trong backend với schema.prisma file
2. Database connection string configured trong .env
3. Prisma schema defines models: User, Profile, WorkExperience, SocialLink, Theme, Card, Payment
4. User model có fields: id (UUID), email (unique), passwordHash, googleId (nullable), createdAt, updatedAt
5. Profile model có fields: id, userId, slug (unique), fullName, title, phone, address, avatarUrl, themeId, isPublished
6. WorkExperience model has relation to Profile (one-to-many): id, profileId, company, position, startDate, endDate, description, displayOrder
7. SocialLink model has relation to Profile (one-to-many): id, profileId, platform (enum), url, displayOrder
8. Theme model stores theme configurations: id, name, thumbnailUrl, configJson
9. Card model: id, profileId, qrCodeUrl, pngFileUrl, pdfFileUrl, createdAt
10. Payment model: id, userId, profileId, amount, currency, status, paymentMethod, transactionId, createdAt
11. Proper relations (@relation) và indexes (@@index) được define
12. Migration file được generate và apply thành công: `npx prisma migrate dev`
13. Prisma Client được generate và import được trong code

---

## Story 1.3: User Registration with Email/Password

**As a** new user,
**I want** to register an account with email and password,
**so that** I can access the platform and create my profile.

### Acceptance Criteria

1. POST /api/v1/auth/register endpoint accepts { email, password, fullName }
2. Password được hash bằng bcrypt (salt rounds: 10) trước khi lưu database
3. Email validation: valid format và uniqueness check với Prisma
4. Password validation: minimum 8 characters, contains letter và number
5. Successful registration creates user record với Prisma Client
6. Returns JWT access token (15min expiry) và refresh token (7 days)
7. Tokens được stored in httpOnly cookies với secure flag
8. Error responses: 400 cho invalid input, 409 cho duplicate email
9. Response body includes: { user: { id, email, fullName }, accessToken }

---

## Story 1.4: User Login with Email/Password

**As a** registered user,
**I want** to login with my email and password,
**so that** I can access my account and manage profiles.

### Acceptance Criteria

1. POST /api/v1/auth/login endpoint accepts { email, password }
2. User lookup bằng Prisma: `prisma.user.findUnique({ where: { email } })`
3. Password được verify bằng bcrypt.compare()
4. Successful login returns JWT access token và refresh token in httpOnly cookies
5. JWT payload contains: { userId, email }
6. Invalid credentials return 401 error với message "Invalid email or password"
7. Rate limiting middleware: maximum 5 login attempts per 15 minutes per IP
8. Login updates user's lastLoginAt timestamp trong database

---

## Story 1.5: JWT Token Refresh Mechanism

**As a** logged-in user,
**I want** my session to be automatically refreshed,
**so that** I don't have to login again mỗi 15 minutes.

### Acceptance Criteria

1. POST /api/v1/auth/refresh endpoint accepts refresh token from httpOnly cookie
2. Endpoint validates refresh token signature và expiry using JWT library
3. If valid, generates new access token (15min) và returns in cookie
4. If invalid/expired, returns 401 và clears cookies
5. Frontend Axios interceptor automatically calls refresh khi 401 response
6. Refresh token rotation: new refresh token issued mỗi lần refresh (security best practice)
7. Old refresh tokens added to Redis blacklist với TTL

---

## Story 1.6: OAuth Login with Google

**As a** user,
**I want** to login using my Google account,
**so that** I can quickly access the platform without creating new password.

### Acceptance Criteria

1. Google OAuth credentials configured trong .env (GOOGLE_CLIENT_ID, GOOGLE_CLIENT_SECRET)
2. GET /api/v1/auth/google initiates OAuth flow và redirects to Google consent screen
3. Passport.js GoogleStrategy configured với callback URL
4. Callback URL /api/v1/auth/google/callback handles OAuth response
5. If user email exists trong database, login existing user và return tokens
6. If new user, create user record với Prisma: `prisma.user.create({ data: { email, googleId, fullName } })`
7. Full name và email populated từ Google profile data
8. Successful OAuth redirects to frontend với tokens in cookies
9. Error handling cho OAuth failures redirects to frontend với error query param

---

## Story 1.7: Protected Route Middleware

**As a** developer,
**I want** authentication middleware to protect API routes,
**so that** only authenticated users can access protected resources.

### Acceptance Criteria

1. Middleware function `authenticate` extracts JWT from httpOnly cookie hoặc Authorization header
2. If valid token, verifies signature và expiry
3. Decodes JWT payload và attaches `req.user = { id, email }` to request object
4. Calls next() để continue request processing
5. If missing/invalid token, returns 401 với { error: "Unauthorized" }
6. Middleware can be applied: `router.get('/protected', authenticate, controller)`
7. Token blacklist check với Redis trước khi accepting token
8. Proper error messages cho different failure scenarios (expired, invalid signature, etc.)

---

## Story 1.8: User Logout

**As a** logged-in user,
**I want** to logout from my account,
**so that** my session is terminated và tokens invalidated.

### Acceptance Criteria

1. POST /api/v1/auth/logout endpoint clears httpOnly cookies (access token, refresh token)
2. Adds refresh token to Redis blacklist với TTL = remaining token lifetime
3. Returns 200 với { message: "Logged out successfully" }
4. Frontend clears any local state/cache và redirects to landing page
5. Subsequent requests với old tokens return 401
6. Works correctly even if no active session (idempotent)

---

## Story 1.9: Database Seeding with Prisma

**As a** developer,
**I want** database seeding với sample themes và test users using Prisma,
**so that** I can develop và test features without manual data entry.

### Acceptance Criteria

1. Prisma seed script located at `prisma/seed.js`
2. Package.json has: `"prisma": { "seed": "node prisma/seed.js" }`
3. Seed script creates 3-5 sample themes với Prisma Client:
   - Theme 1: "Modern Minimal" (clean white/blue design) với config JSON
   - Theme 2: "Professional Dark" (dark mode với gold accents)
   - Theme 3: "Creative Colorful" (vibrant colors)
4. Seed creates 2 test users: `testuser@example.com` (password: Test1234)
5. Test user 1 has complete profile với work experience và social links
6. Seeding script uses `upsert` để be idempotent (can run multiple times)
7. Command `npx prisma db seed` executes successfully
8. Seed logs clear messages về created/updated records

---

## Story 1.10: Health Check & API Documentation Endpoint

**As a** developer/DevOps,
**I want** health check endpoints và basic API documentation,
**so that** I can monitor service status và understand available endpoints.

### Acceptance Criteria

1. GET /health returns 200 với `{ status: "healthy", timestamp: ISO8601, version: "1.0.0" }`
2. Health check tests database connection: `await prisma.$queryRaw\`SELECT 1\``
3. Health check tests Redis connection: `await redis.ping()`
4. If database down, returns 503 với `{ status: "unhealthy", error: "Database unavailable" }`
5. If Redis down, returns 503 với details
6. GET /api/v1/docs serves Swagger UI interface
7. Swagger auto-generated từ Express routes với JSDoc comments
8. All auth endpoints documented với example request/response bodies
9. Swagger includes authentication scheme (Bearer token)
10. README.md links to API documentation

---

## Dependencies & Sequencing

**Must Complete First:**
- Story 1.1 (Docker setup) → Prerequisite cho all other stories
- Story 1.2 (Prisma schema) → Prerequisite cho 1.3-1.9

**Can Develop in Parallel (after 1.1, 1.2):**
- Stories 1.3, 1.4, 1.5, 1.6, 1.7, 1.8 (auth system)
- Story 1.9 (seeding) can start once schema stable

**Complete Last:**
- Story 1.10 (documentation) should complete sau khi auth endpoints done

---

## Definition of Done

- [ ] All 10 stories completed với acceptance criteria met
- [ ] Docker environment starts cleanly: `docker-compose up`
- [ ] Prisma migrations applied successfully
- [ ] Can register, login, logout, refresh tokens
- [ ] OAuth Google login working
- [ ] Database seeded với themes và test users
- [ ] Health check endpoint returns healthy status
- [ ] API documentation accessible
- [ ] Unit tests written cho core auth logic (bcrypt, JWT)
- [ ] Integration tests cho auth endpoints
- [ ] Code reviewed và merged to main branch
