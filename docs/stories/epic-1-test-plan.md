# Epic 1: Foundation & Core Infrastructure - Test Plan

## Overview
This document provides a comprehensive testing guide for Epic 1, covering all 10 stories and their acceptance criteria.

## Prerequisites
- Docker Desktop installed and running
- Node.js 20+ installed
- Google OAuth credentials configured (for Story 1.6)
- PostgreSQL and Redis running via Docker
- Backend server running on port 3000
- Frontend server running on port 5173

## Setup Steps

```bash
# 1. Start Docker services
docker-compose up -d

# 2. Wait for services to be ready (30 seconds)
# Check services are running
docker-compose ps

# 3. Apply database migrations
cd backend
npx prisma migrate dev

# 4. Generate Prisma Client
npx prisma generate

# 5. Seed database
npx prisma db seed

# 6. Start backend server
npm run dev

# 7. In new terminal, start frontend
cd frontend
npm run dev
```

---

## Story 1.1: Project Setup & Docker Environment

### Test Checklist
- [ ] **AC1**: Monorepo structure exists (frontend/, backend/, shared/, docker/)
  ```bash
  # Verify folder structure
  ls -la
  ```

- [ ] **AC2**: Docker Compose defines all services
  ```bash
  # Check docker-compose.yml contains: frontend, backend, postgres, redis, pgadmin
  cat docker-compose.yml
  ```

- [ ] **AC3**: All containers start successfully
  ```bash
  docker-compose up
  # Verify all 5 services show "healthy" or "running"
  docker-compose ps
  ```

- [ ] **AC4**: Services accessible at correct ports
  - Frontend: http://localhost:5173
  - Backend: http://localhost:3000
  - pgAdmin: http://localhost:5050

- [ ] **AC5**: Hot reload works
  - Edit `backend/src/index.js` - verify nodemon restarts
  - Edit `frontend/src/App.jsx` - verify Vite HMR updates

- [ ] **AC6**: Environment variables load correctly
  ```bash
  # Check .env file exists and is loaded
  cd backend && cat .env
  ```

- [ ] **AC7**: README has clear instructions
  - Open README.md
  - Verify setup, development, and Docker commands are documented

- [ ] **AC8**: pgAdmin pre-configured
  - Visit http://localhost:5050
  - Login with credentials from .env
  - Verify postgres connection exists

---

## Story 1.2: Prisma Setup & Database Schema

### Test Checklist
- [ ] **AC1**: Prisma initialized
  ```bash
  cd backend
  ls prisma/schema.prisma
  ```

- [ ] **AC2**: Database connection configured
  ```bash
  # Check DATABASE_URL in .env
  cat .env | grep DATABASE_URL
  ```

- [ ] **AC3-10**: Schema models defined correctly
  ```bash
  # View schema
  cat prisma/schema.prisma
  # Verify models: User, Profile, WorkExperience, SocialLink, Theme, Card, Payment
  ```

- [ ] **AC11**: Relations and indexes defined
  ```bash
  # Check for @relation and @@index in schema
  cat prisma/schema.prisma | grep -E "@relation|@@index"
  ```

- [ ] **AC12**: Migration applied successfully
  ```bash
  npx prisma migrate dev
  # Should show migration applied
  ```

- [ ] **AC13**: Prisma Client generates and imports
  ```bash
  npx prisma generate
  # Check import works
  node -e "import { PrismaClient } from '@prisma/client'; const prisma = new PrismaClient(); console.log('✅ Prisma Client works');"
  ```

---

## Story 1.3: User Registration with Email/Password

### Test Checklist
- [ ] **AC1-5**: Register new user
  ```bash
  curl -X POST http://localhost:3000/api/v1/auth/register \
    -H "Content-Type: application/json" \
    -d '{
      "email": "test@example.com",
      "password": "Test1234",
      "fullName": "Test User"
    }'
  # Should return 201 with user object and accessToken
  ```

- [ ] **AC3**: Email validation
  ```bash
  # Invalid email format
  curl -X POST http://localhost:3000/api/v1/auth/register \
    -H "Content-Type: application/json" \
    -d '{"email": "invalid-email", "password": "Test1234", "fullName": "Test"}' \
  # Should return 400
  ```

- [ ] **AC4**: Password validation
  ```bash
  # Too short password
  curl -X POST http://localhost:3000/api/v1/auth/register \
    -H "Content-Type: application/json" \
    -d '{"email": "test2@example.com", "password": "abc", "fullName": "Test"}' \
  # Should return 400
  ```

- [ ] **AC8**: Duplicate email error
  ```bash
  # Try to register with same email twice
  # Should return 409
  ```

- [ ] **AC6-7**: Tokens in httpOnly cookies
  - Check response headers for Set-Cookie
  - Verify accessToken and refreshToken cookies

---

## Story 1.4: User Login with Email/Password

### Test Checklist
- [ ] **AC1-5**: Successful login
  ```bash
  curl -X POST http://localhost:3000/api/v1/auth/login \
    -H "Content-Type: application/json" \
    -d '{
      "email": "test@example.com",
      "password": "Test1234"
    }'
  # Should return 200 with user and tokens
  ```

- [ ] **AC6**: Invalid credentials
  ```bash
  curl -X POST http://localhost:3000/api/v1/auth/login \
    -H "Content-Type: application/json" \
    -d '{"email": "test@example.com", "password": "wrongpass"}'
  # Should return 401
  ```

- [ ] **AC7**: Rate limiting
  ```bash
  # Make 6 login attempts rapidly
  for i in {1..6}; do
    curl -X POST http://localhost:3000/api/v1/auth/login \
      -H "Content-Type: application/json" \
      -d '{"email": "test@example.com", "password": "wrong"}';
  done
  # 6th request should return 429
  ```

---

## Story 1.5: JWT Token Refresh Mechanism

### Test Checklist
- [ ] **AC1-3**: Token refresh works
  ```bash
  # First login to get refresh token
  curl -X POST http://localhost:3000/api/v1/auth/login \
    -H "Content-Type: application/json" \
    -c cookies.txt \
    -d '{"email": "test@example.com", "password": "Test1234"}'

  # Then refresh
  curl -X POST http://localhost:3000/api/v1/auth/refresh \
    -b cookies.txt
  # Should return new accessToken
  ```

- [ ] **AC4**: Invalid token handling
  ```bash
  curl -X POST http://localhost:3000/api/v1/auth/refresh \
    -H "Cookie: refreshToken=invalid"
  # Should return 401 and clear cookies
  ```

- [ ] **AC6**: Token rotation
  - Verify each refresh returns a new refreshToken
  - Check old token is different from new token

- [ ] **AC7**: Redis blacklist
  ```bash
  # Check Redis for blacklisted tokens
  docker exec -it <redis-container> redis-cli
  KEYS blacklist:*
  ```

---

## Story 1.6: OAuth Login with Google

### Test Checklist
- [ ] **AC1**: Google OAuth credentials configured
  ```bash
  cat backend/.env | grep GOOGLE_CLIENT
  ```

- [ ] **AC2**: OAuth initiation
  - Visit http://localhost:3000/api/v1/auth/google
  - Should redirect to Google consent screen

- [ ] **AC3-4**: Callback handling
  - Complete Google OAuth flow
  - Should redirect back to callback URL

- [ ] **AC5**: Existing user login
  - Register with email/password first
  - Then use Google OAuth with same email
  - Should link googleId to existing account

- [ ] **AC6**: New user creation
  - Use Google OAuth with new email
  - Should create new user with googleId

- [ ] **AC7**: Profile data extraction
  - Verify fullName and email populated from Google

- [ ] **AC8**: Successful redirect
  - Should redirect to frontend with cookies

- [ ] **AC9**: Error handling
  - Cancel OAuth flow
  - Should redirect with error parameter

---

## Story 1.7: Protected Route Middleware

### Test Checklist
- [ ] **AC1-4**: Valid token access
  ```bash
  # Login first
  curl -X POST http://localhost:3000/api/v1/auth/login \
    -H "Content-Type: application/json" \
    -c cookies.txt \
    -d '{"email": "test@example.com", "password": "Test1234"}'

  # Access protected route
  curl http://localhost:3000/api/v1/auth/me -b cookies.txt
  # Should return user info
  ```

- [ ] **AC5**: Missing token
  ```bash
  curl http://localhost:3000/api/v1/auth/me
  # Should return 401
  ```

- [ ] **AC6**: Middleware application
  - Verify /api/v1/auth/me route uses authenticate middleware
  - Check routes/auth.routes.js

- [ ] **AC7**: Blacklist check
  - Logout (blacklists token)
  - Try using old token
  - Should return 401

---

## Story 1.8: User Logout

### Test Checklist
- [ ] **AC1-3**: Successful logout
  ```bash
  # Login first
  curl -X POST http://localhost:3000/api/v1/auth/login \
    -H "Content-Type: application/json" \
    -c cookies.txt \
    -d '{"email": "test@example.com", "password": "Test1234"}'

  # Logout
  curl -X POST http://localhost:3000/api/v1/auth/logout -b cookies.txt
  # Should return 200 and clear cookies
  ```

- [ ] **AC2**: Token blacklisted
  ```bash
  # Check Redis blacklist
  docker exec -it <redis-container> redis-cli
  KEYS blacklist:*
  ```

- [ ] **AC5**: Old tokens invalid
  ```bash
  # Try using old accessToken after logout
  curl http://localhost:3000/api/v1/auth/me -b cookies.txt
  # Should return 401
  ```

- [ ] **AC6**: Idempotent logout
  ```bash
  # Logout twice
  curl -X POST http://localhost:3000/api/v1/auth/logout
  # Should return 200 both times
  ```

---

## Story 1.9: Database Seeding with Prisma

### Test Checklist
- [ ] **AC1-2**: Seed script location
  ```bash
  ls prisma/seed.js
  cat package.json | grep "prisma.*seed"
  ```

- [ ] **AC3**: Themes seeded
  ```bash
  npx prisma db seed
  # Check themes created
  npx prisma studio
  # Open Themes table, verify 3-5 themes exist
  ```

- [ ] **AC4-5**: Test users and profiles
  ```bash
  # Check User table for testuser@example.com
  # Verify profile with work experience and social links
  ```

- [ ] **AC6**: Idempotent seeding
  ```bash
  # Run seed twice
  npx prisma db seed
  npx prisma db seed
  # Should not create duplicates
  ```

- [ ] **AC7**: Successful execution
  ```bash
  npx prisma db seed
  # Should complete without errors
  ```

- [ ] **AC8**: Clear logging
  - Verify seed script logs created/updated records

---

## Story 1.10: Health Check & API Documentation

### Test Checklist
- [ ] **AC1**: Health endpoint format
  ```bash
  curl http://localhost:3000/health
  # Should return: {"status":"healthy","timestamp":"...","version":"1.0.0"}
  ```

- [ ] **AC2**: Database connection check
  ```bash
  # Stop postgres
  docker stop <postgres-container>
  curl http://localhost:3000/health
  # Should return 503 with database: "disconnected"
  
  # Start postgres
  docker start <postgres-container>
  curl http://localhost:3000/health
  # Should return 200 with database: "connected"
  ```

- [ ] **AC3**: Redis connection check
  ```bash
  # Stop Redis
  docker stop <redis-container>
  curl http://localhost:3000/health
  # Should return 503 with redis: "disconnected"
  
  # Start Redis
  docker start <redis-container>
  ```

- [ ] **AC4-5**: Unhealthy status
  - Stop services
  - Verify 503 response with error details

- [ ] **AC6-7**: Swagger UI
  - Visit http://localhost:3000/api/v1/docs
  - Verify Swagger UI loads

- [ ] **AC8**: Endpoints documented
  - Check all auth endpoints visible in Swagger
  - Verify example requests/responses

- [ ] **AC9**: Authentication scheme
  - Check Bearer token authentication documented
  - Verify "Authorize" button in Swagger UI

- [ ] **AC10**: README link
  ```bash
  cat README.md | grep -i "api documentation"
  ```

---

## Integration Testing

### End-to-End User Flows

#### Flow 1: Complete Registration → Login → Logout
```bash
# 1. Register
curl -X POST http://localhost:3000/api/v1/auth/register \
  -H "Content-Type: application/json" \
  -c cookies.txt \
  -d '{"email": "e2e@example.com", "password": "Test1234", "fullName": "E2E Test"}'

# 2. Access protected route
curl http://localhost:3000/api/v1/auth/me -b cookies.txt

# 3. Logout
curl -X POST http://localhost:3000/api/v1/auth/logout -b cookies.txt

# 4. Try accessing protected route (should fail)
curl http://localhost:3000/api/v1/auth/me -b cookies.txt
```

#### Flow 2: Token Refresh Flow
```bash
# 1. Login
curl -X POST http://localhost:3000/api/v1/auth/login \
  -c cookies.txt \
  -d '{"email": "test@example.com", "password": "Test1234"}'

# 2. Wait 1 minute

# 3. Refresh token
curl -X POST http://localhost:3000/api/v1/auth/refresh -b cookies.txt

# 4. Access protected route with new token
curl http://localhost:3000/api/v1/auth/me -b cookies.txt
```

#### Flow 3: Google OAuth (Manual)
1. Visit http://localhost:3000/api/v1/auth/google
2. Complete Google OAuth
3. Verify redirect to frontend with cookies
4. Access http://localhost:3000/api/v1/auth/me
5. Should show user info from Google

---

## Performance Testing

### Rate Limiting Tests
```bash
# Test login rate limiting (5 attempts per 15 min)
for i in {1..10}; do
  curl -X POST http://localhost:3000/api/v1/auth/login \
    -H "Content-Type: application/json" \
    -d '{"email": "test@example.com", "password": "wrong"}' \
    -w "\nStatus: %{http_code}\n"
done
# Requests 6-10 should return 429
```

---

## Security Testing

### JWT Security
- [ ] Tokens use httpOnly cookies
- [ ] Secure flag set in production
- [ ] SameSite attribute configured
- [ ] Refresh token rotation implemented
- [ ] Token blacklist in Redis

### Password Security
- [ ] Passwords hashed with bcrypt
- [ ] Salt rounds = 10
- [ ] Password validation enforced
- [ ] No passwords in logs

### OAuth Security
- [ ] State parameter used (by Passport)
- [ ] HTTPS required in production
- [ ] Callback URL validated

---

## Database Testing

### Schema Verification
```bash
# Connect to database
docker exec -it <postgres-container> psql -U postgres -d smartcard_db

# Check tables
\dt

# Verify User table structure
\d "User"

# Check indexes
\di
```

### Data Integrity
- [ ] Foreign keys enforced
- [ ] Unique constraints work
- [ ] Cascading deletes configured
- [ ] Timestamps auto-populated

---

## Redis Testing

### Connection and Operations
```bash
# Connect to Redis
docker exec -it <redis-container> redis-cli

# Test basic operations
SET test "value"
GET test

# Check blacklist keys
KEYS blacklist:*

# Check TTL
TTL blacklist:<token>
```

---

## Cleanup After Testing

```bash
# Stop services
docker-compose down

# Remove volumes (delete all data)
docker-compose down -v

# Remove test users
npx prisma studio
# Manually delete test records

# Clear Redis
docker exec -it <redis-container> redis-cli FLUSHALL
```

---

## Test Results Template

```markdown
## Epic 1 Test Results - [Date]

### Environment
- OS: [Windows/Mac/Linux]
- Node.js: [version]
- Docker: [version]
- Database: PostgreSQL 15
- Redis: 7

### Story Results
- [ ] Story 1.1: Project Setup - PASS/FAIL
- [ ] Story 1.2: Prisma Setup - PASS/FAIL
- [ ] Story 1.3: User Registration - PASS/FAIL
- [ ] Story 1.4: User Login - PASS/FAIL
- [ ] Story 1.5: Token Refresh - PASS/FAIL
- [ ] Story 1.6: Google OAuth - PASS/FAIL
- [ ] Story 1.7: Protected Routes - PASS/FAIL
- [ ] Story 1.8: User Logout - PASS/FAIL
- [ ] Story 1.9: Database Seeding - PASS/FAIL
- [ ] Story 1.10: Health Check & Docs - PASS/FAIL

### Issues Found
[List any issues discovered during testing]

### Notes
[Additional observations or recommendations]
```

---

## Automated Testing

### Unit Tests (Future)
```bash
cd backend
npm test
npm run test:coverage
```

### Integration Tests (Future)
```bash
npm run test:integration
```

### E2E Tests (Future)
```bash
cd frontend
npm run test:e2e
```
