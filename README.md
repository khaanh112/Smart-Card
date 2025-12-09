# Smart QR Business Card Platform

A modern platform for creating smart business cards with QR codes and personal profile websites.

## 🚀 Quick Start

### Prerequisites

- Docker & Docker Compose installed
- Node.js 20+ (for local development outside Docker)
- Git

### Setup Instructions

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd smart-card-platform
   ```

2. **Create environment file**
   ```bash
   copy .env.example .env
   ```
   Edit `.env` and update the values as needed.

3. **Start all services**
   ```bash
   docker-compose up
   ```

4. **Access the application**
   - Frontend: http://localhost:5173
   - Backend API: http://localhost:3000
   - API Docs: http://localhost:3000/api/v1/docs
   - pgAdmin: http://localhost:5050
   - Health Check: http://localhost:3000/health

### Development Workflow

#### Backend Development

```bash
cd backend
npm install
npm run dev
```

#### Frontend Development

```bash
cd frontend
npm install
npm run dev
```

#### Database Migrations

```bash
cd backend
npx prisma migrate dev
npx prisma generate
```

#### Database Seeding

```bash
cd backend
npx prisma db seed
```

### Docker Commands

```bash
# Start services
docker-compose up

# Start in background
docker-compose up -d

# Stop services
docker-compose down

# View logs
docker-compose logs -f

# Rebuild containers
docker-compose up --build

# Remove volumes (careful - deletes data!)
docker-compose down -v
```

## 📁 Project Structure

```
├── backend/              # Express.js API
│   ├── src/
│   │   ├── routes/      # API routes
│   │   ├── controllers/ # Request handlers
│   │   ├── services/    # Business logic
│   │   ├── middleware/  # Express middleware
│   │   └── utils/       # Utility functions
│   ├── prisma/          # Database schema & migrations
│   ├── uploads/         # File uploads
│   └── package.json
│
├── frontend/            # React + Vite SPA
│   ├── src/
│   │   ├── components/  # React components
│   │   ├── pages/       # Page components
│   │   ├── themes/      # Profile themes
│   │   ├── hooks/       # Custom React hooks
│   │   ├── store/       # State management (Zustand)
│   │   └── utils/       # Utility functions
│   └── package.json
│
├── shared/              # Shared code (types, utils)
├── docker/              # Docker configurations
├── docs/                # Documentation
│   └── prd/            # Product Requirements
└── docker-compose.yml
```

## 🛠️ Tech Stack

### Frontend
- React 18+ (JavaScript/ES6+)
- Vite (Build tool)
- Tailwind CSS (Styling)
- React Router v6 (Routing)
- React Hook Form + Yup (Forms & Validation)
- Zustand (State management)
- Axios (HTTP client)

### Backend
- Node.js 20+ (JavaScript/ES6+)
- Express.js (Web framework)
- Prisma (ORM)
- PostgreSQL 15 (Database)
- Redis (Caching & Sessions)
- Passport.js (Authentication)
- JWT (Tokens)
- Puppeteer (Card generation)
- Sharp (Image processing)

### DevOps
- Docker & Docker Compose
- Nginx (Reverse proxy)
- PM2 (Process management)
- GitHub Actions (CI/CD)

## 📚 API Documentation

Once the backend is running, visit:
- **Swagger UI**: http://localhost:3000/api/v1/docs - Interactive API documentation with request/response examples
- **Health Check**: http://localhost:3000/health - API health status and service dependencies

### Available Endpoints

#### Authentication
- `POST /api/v1/auth/register` - Register new user
- `POST /api/v1/auth/login` - Login with email/password
- `POST /api/v1/auth/refresh` - Refresh access token
- `POST /api/v1/auth/logout` - Logout and invalidate tokens
- `GET /api/v1/auth/me` - Get current user (protected)

The Swagger documentation provides detailed information about:
- Request/response schemas
- Authentication requirements (JWT Bearer tokens)
- Example requests and responses
- Error codes and messages

## 🧪 Testing

```bash
# Backend tests
cd backend
npm test
npm run test:watch
npm run test:coverage

# Frontend tests
cd frontend
npm test
npm run test:e2e
```

## 🔧 Configuration

### pgAdmin Setup

1. Access pgAdmin at http://localhost:5050
2. Login with credentials from `.env`:
   - Email: admin@smartcard.com
   - Password: admin
3. Add server:
   - Name: SmartCard Local
   - Host: postgres
   - Port: 5432
   - Username: postgres
   - Password: (from .env)

### Google OAuth Setup

1. Go to Google Cloud Console
2. Create new project or select existing
3. Enable Google+ API
4. Create OAuth 2.0 credentials
5. Add authorized redirect URI: `http://localhost:3000/api/v1/auth/google/callback`
6. Copy Client ID and Secret to `.env`

## 📖 Documentation

- [Product Requirements (PRD)](docs/prd.md)
- [Epic 1: Foundation](docs/prd/epic-1-foundation.md)
- [Epic 2: Profile Creation](docs/prd/epic-2-profile-creation.md)
- [Epic 3: Card Generation](docs/prd/epic-3-card-generation.md)
- [Epic 4: Dashboard](docs/prd/epic-4-dashboard.md)
- [Epic 5: Profile Rendering](docs/prd/epic-5-profile-rendering.md)

## 🤝 Contributing

1. Create feature branch
2. Make changes
3. Write tests
4. Submit pull request

## 📄 License

MIT License

## 👥 Team

- Product Manager: [Name]
- Developer: [Name]

## 🐛 Troubleshooting

### Port already in use
```bash
# Check what's using the port
netstat -ano | findstr :3000
# Kill the process
taskkill /PID <pid> /F
```

### Docker container won't start
```bash
docker-compose down
docker-compose up --build
```

### Database connection issues
```bash
# Check if postgres is running
docker-compose ps
# View postgres logs
docker-compose logs postgres
```

### Reset everything
```bash
docker-compose down -v
docker-compose up --build
```
