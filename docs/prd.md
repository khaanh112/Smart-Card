# Smart QR Business Card Platform - Product Requirements Document (PRD)

## Goals and Background Context

### Goals

- Tạo ra giải pháp business card thông minh kết hợp NFC/QR code để thay thế card giấy truyền thống
- Tự động hóa hoàn toàn quy trình từ nhập thông tin → thanh toán → tạo website profile → generate QR/card design
- Cho phép người dùng tự customize website profile cá nhân với nhiều theme khác nhau
- Cung cấp file ảnh card design ready-to-print để user có thể tự in hoặc đưa cho nhà in
- Tạo trải nghiệm liền mạch cho end-user từ đặt hàng online đến nhận file design và website profile

### Background Context

Trong thời đại digital transformation, business card giấy truyền thống đang dần lỗi thời - dễ thất lạc, không cập nhật được thông tin, và thiếu tính tương tác. Smart card với QR code/NFC mang lại giải pháp hiện đại: người nhận chỉ cần quét để truy cập profile online luôn được cập nhật, bao gồm social links, experience, portfolio, và contact information.

Tuy nhiên, việc tạo ra một hệ sinh thái hoàn chỉnh (web profile + card design) thường phức tạp và tốn kém cho cá nhân. Dự án này nhằm tự động hóa toàn bộ value chain: một platform cho phép bất kỳ ai cũng có thể tạo smart card chuyên nghiệp chỉ với vài bước đơn giản - nhập thông tin, chọn theme, thanh toán, và nhận được cả website profile lẫn file card design chất lượng cao (print-ready) để tự in hoặc gửi nhà in.

### Change Log

| Date | Version | Description | Author |
|------|---------|-------------|--------|
| 2025-12-02 | 0.1 | Initial PRD creation | PM |

## Requirements

### Functional

**FR1:** Hệ thống phải cho phép người dùng nhập thông tin cá nhân bao gồm: tên, title/position, email, số điện thoại, địa chỉ, và các social media links (LinkedIn, Facebook, Instagram, Twitter, GitHub, etc.)

**FR2:** Hệ thống phải cho phép người dùng nhập thông tin work experience bao gồm: company name, position, duration, và mô tả công việc

**FR3:** Hệ thống phải cung cấp gallery các pre-designed themes cho website profile để người dùng xem preview và lựa chọn

**FR4:** Hệ thống phải tích hợp payment gateway để xử lý thanh toán online (VNPay, MoMo, hoặc Stripe)

**FR5:** Sau khi thanh toán thành công, hệ thống phải tự động tạo một website profile với subdomain hoặc custom URL unique cho người dùng (ví dụ: platform.com/username hoặc username.platform.com)

**FR6:** Website profile được tạo phải hiển thị đầy đủ thông tin người dùng đã nhập theo theme đã chọn, bao gồm social links, work experience, và contact info

**FR7:** Hệ thống phải tự động generate mã QR code chứa link đến website profile của người dùng

**FR8:** Hệ thống phải tự động tạo file design card hoàn chỉnh (format PNG/PDF high resolution) bao gồm: tên người dùng, title, và QR code được đặt theo layout template chuyên nghiệp

**FR9:** Người dùng phải có thể download file card design (PNG/PDF) sau khi thanh toán thành công

**FR10:** Người dùng phải có thể login vào dashboard để chỉnh sửa thông tin profile của mình sau khi đã tạo

**FR11:** Khi người dùng cập nhật thông tin profile, website profile phải tự động cập nhật ngay lập tức mà không cần tạo QR code mới

**FR12:** Hệ thống phải lưu trữ upload ảnh profile/avatar của người dùng và hiển thị trên website profile

### Non Functional

**NFR1:** Website profile phải load trong vòng dưới 2 giây trên mobile device với 4G connection

**NFR2:** QR code được generate phải có độ phân giải đủ cao để có thể in rõ nét trên card kích thước standard (9cm x 5cm)

**NFR3:** File card design phải có chất lượng print-ready (ít nhất 300 DPI) với bleed area chuẩn

**NFR4:** Hệ thống phải responsive và hoạt động tốt trên cả desktop và mobile browsers

**NFR5:** Payment transaction phải được mã hóa và tuân thủ các chuẩn bảo mật thanh toán online

**NFR6:** Website profile phải có uptime ít nhất 99.5%

**NFR7:** Hệ thống phải hỗ trợ ít nhất 1000 concurrent users trong quá trình thanh toán và tạo profile

**NFR8:** Database phải backup tự động hàng ngày để tránh mất dữ liệu người dùng

## User Interface Design Goals

### Overall UX Vision

Platform cần mang lại trải nghiệm "effortless professionalism" - một quy trình đơn giản, trực quan mà bất kỳ ai cũng có thể hoàn thành trong 5-10 phút mà không cần kiến thức design hay technical. Interface phải clean, modern, và professional để phản ánh chất lượng của sản phẩm cuối (smart business card). Wizard-style flow giúp người dùng không bị overwhelmed với quá nhiều lựa chọn cùng lúc.

### Key Interaction Paradigms

- **Multi-step Wizard**: Chia quy trình thành các bước rõ ràng (1. Info Input → 2. Theme Selection → 3. Preview → 4. Payment → 5. Download), với progress indicator để user biết mình đang ở đâu
- **Live Preview**: Khi chọn theme hoặc nhập thông tin, user thấy preview real-time của website profile và card design
- **Drag & Drop**: Cho phép reorder work experience entries hoặc social links một cách trực quan
- **One-click Social Connect**: Tích hợp OAuth để import info từ LinkedIn/Facebook thay vì nhập manual
- **Mobile-first Input**: Form design tối ưu cho mobile typing vì nhiều users sẽ điền trên điện thoại

### Core Screens and Views

1. **Landing Page** - Giới thiệu product với demo samples, pricing, và CTA rõ ràng
2. **Registration/Login Screen** - Đơn giản với social login options
3. **Info Input Form** - Multi-step wizard với các tabs: Personal Info, Work Experience, Social Links, Upload Photo
4. **Theme Gallery** - Grid layout showcasing available themes với thumbnail preview và "Select" button
5. **Preview Screen** - Split view: bên trái là website profile preview, bên phải là card design preview
6. **Payment Screen** - Clean checkout với multiple payment methods và order summary
7. **Success/Download Screen** - Confirmation với download buttons cho card files và link đến live profile
8. **User Dashboard** - Overview của profiles đã tạo, edit profile button, regenerate card design option
9. **Profile Editor** - Same form như Info Input nhưng pre-filled, với save changes functionality

### Accessibility

**WCAG AA Compliance** - Đảm bảo contrast ratios, keyboard navigation, screen reader compatibility cho form inputs và buttons. Alt text cho theme previews và card designs.

### Branding

- **Modern Minimalist**: Clean lines, ample white space, sans-serif fonts (như Inter, Poppins)
- **Professional Color Palette**: Primary color nên convey trust và professionalism (navy blue, deep teal, hoặc charcoal)
- **Subtle Animations**: Smooth transitions giữa wizard steps, micro-interactions khi hover buttons
- **Card Design Aesthetic**: Showcase high-quality mockups of physical cards trong marketing materials để communicate product value

### Target Device and Platforms

**Web Responsive** - Hỗ trợ đầy đủ trên:
- Desktop browsers (Chrome, Firefox, Safari, Edge)
- Mobile browsers (iOS Safari, Chrome Mobile)
- Tablet devices

Optimized for mobile-first experience vì nhiều users sẽ tạo profile và share trên mobile. Website profiles phải load nhanh trên cả 3G/4G connections.

## Technical Assumptions

### Repository Structure

**Monorepo** - Sử dụng monorepo đơn giản để quản lý:
- Frontend (React SPA)
- Backend API (Express.js)
- Shared utilities
- Docker configurations

**Rationale**: Monorepo đơn giản giúp quản lý code dễ dàng trong một repo, phù hợp cho demo project.

### Service Architecture

**Modular Monolithic Architecture với Docker** bao gồm:
- **Frontend Container**: React SPA served by Nginx
- **Backend API Container**: Express.js REST API (modular structure: auth, profiles, cards, payments modules)
- **PostgreSQL Container**: Database cho user data, profiles, và transactions
- **Redis Container**: Session storage và caching cho performance
- **File Storage**: Local volumes (development) / Cloud storage (production - S3 hoặc Cloudflare R2)

**Rationale**: 
- Modular monolith giữ simplicity nhưng vẫn organized và scalable
- Docker containers cho consistent deployment
- Express.js với module pattern dễ maintain và test
- PostgreSQL cho relational data với ACID compliance
- Redis cho session management và caching - improve performance đáng kể
- Có thể deploy production-ready nhưng không phức tạp như microservices

### Testing Requirements

**Production-Level Testing** bao gồm:
- Unit tests cho core business logic (profile generation, QR code generation, payment processing)
- Integration tests cho critical API endpoints (auth, profile creation, payment flow)
- E2E tests cho main user journey (signup → create profile → download)
- Manual testing với Docker Compose dev environment và seeded data

**Rationale**: Production app cần reliable testing, nhưng không cần 100% coverage. Focus vào critical paths và business logic.

### Tech Stack

**Frontend:**
- **Framework**: React 18+ với JavaScript (ES6+)
- **Build Tool**: Vite (fast dev server, optimized production builds)
- **Styling**: Tailwind CSS cho utility-first styling
- **Routing**: React Router v6
- **Form Handling**: React Hook Form + Yup validation
- **State Management**: Zustand hoặc Redux Toolkit cho wizard state
- **HTTP Client**: Axios với interceptors cho auth
- **UI Components**: Headless UI hoặc Radix UI (với Tailwind)
- **PropTypes**: prop-types library cho component validation

**Backend:**
- **Runtime**: Node.js 20+ với JavaScript (ES6+ modules)
- **Framework**: Express.js với modular middleware architecture
- **ORM**: Prisma cho type-safe database access với PostgreSQL (relationships, transactions)
- **Authentication**: JWT với refresh tokens + bcrypt password hashing + OAuth2 (Google)
- **Payment**: VNPay hoặc Stripe integration (real payment gateway cho production)
- **Validation**: express-validator cho comprehensive request validation
- **API Documentation**: Swagger/OpenAPI cho API docs (auto-generated từ code)

**Profile Generation:**
- **Template Engine**: EJS hoặc Handlebars với theme templates
- **Static File Serving**: Nginx serving generated HTML/CSS/JS
- **Theme System**: JSON-based configuration với template mapping

**Card Design Generation:**
- **Image Generation**: Puppeteer (HTML/CSS → High-res PNG/PDF)
- **QR Code Library**: qrcode hoặc qr-image (high resolution)
- **Image Processing**: Sharp cho optimization và format conversion
- **Design Templates**: HTML/CSS templates với variable injection

**Database:**
- **Primary DB**: PostgreSQL 15+
- **Schema Management**: Prisma schema và migrations với version control
- **Connection Pooling**: Built-in Prisma pooling
- **Backup Strategy**: Automated daily backups (cron job + pg_dump) cho production

**Infrastructure & DevOps:**
- **Containerization**: Docker + Docker Compose
- **Reverse Proxy**: Nginx (routing, SSL/TLS, static files, gzip compression)
- **Caching Layer**: Redis cho sessions và frequently accessed data
- **File Storage**: Local volumes (dev) / Cloud storage (prod - Cloudflare R2 hoặc AWS S3)
- **Monitoring**: Winston logging với log files + Sentry cho error tracking (free tier)
- **Process Management**: PM2 trong production container cho auto-restart
- **CI/CD**: GitHub Actions cho automated testing và build (optional deploy)

**Development Tools:**
- **Package Manager**: npm hoặc pnpm
- **Testing**: Jest (unit) + Supertest (API integration) + Playwright (E2E)
- **Code Quality**: ESLint + Prettier + Husky (pre-commit hooks)
- **API Testing**: Postman collection hoặc REST Client files

### Additional Technical Assumptions and Requests

- **Profile URLs**: Path-based URLs (platform.com/:username) với unique slug validation
- **QR Code Format**: Dynamic QR codes pointing to profile URLs (có thể track scans)
- **Card Design Output**: Generate cả PNG (preview) và PDF (300+ DPI print-ready)
- **Theme System**: 3-5 pre-built themes stored in database, dễ dàng add themes mới
- **Code Style**: ES6+ features (arrow functions, async/await, destructuring, modules)
- **API Architecture**: RESTful API với clear structure (/api/v1/auth, /api/v1/profiles, /api/v1/cards)
- **File Upload**: Multer middleware với validation (file type, size, image dimensions)
- **Authentication Flow**: JWT access tokens (15min) + refresh tokens (7 days) stored in httpOnly cookies
- **Rate Limiting**: Express-rate-limit cho auth endpoints và expensive operations (card generation)
- **CORS Configuration**: Properly configured CORS cho frontend domain
- **Environment Management**: .env files (dev/staging/prod) với validation
- **Database Seeding**: Prisma seed scripts với 3-5 sample themes và test accounts
- **Logging**: Winston với file rotation và different log levels (error, warn, info, debug)
- **Error Handling**: Centralized error handling middleware với proper HTTP status codes
- **Security**: Helmet.js cho security headers, input sanitization, SQL injection prevention
- **Scalability Target**: 100-500 concurrent users, có thể scale horizontal với load balancer nếu cần
- **Internationalization**: Vietnamese primary, English support, i18n structure sẵn cho future languages

### Docker Architecture

**Development (docker-compose.dev.yml):**
```
- frontend (React dev server với Vite hot reload, port 5173)
- backend (Express with nodemon hot reload, port 3000)
- postgres (port 5432, với persistent volume)
- redis (port 6379)
- pgadmin (DB management UI, port 5050)
```

**Production (docker-compose.prod.yml):**
```
- nginx (reverse proxy, SSL termination, port 80/443)
- frontend (optimized production build served by nginx)
- backend (Express với PM2, behind nginx proxy)
- postgres (với automated backups)
- redis (persistent storage enabled)
```

**Deployment:** Docker Compose production-ready, có thể deploy lên VPS (DigitalOcean, Linode, Railway) hoặc PaaS (Render, Fly.io). Không cần Kubernetes - Docker Compose + reverse proxy là đủ cho scale nhỏ-trung bình.

## Epic List

**Epic 1: Foundation & Core Infrastructure**
Setup project foundation với Docker, database, authentication system, và basic user management để establish technical infrastructure cho toàn bộ platform.

**Epic 2: Profile Creation Workflow**
Implement complete user journey từ info input form → theme selection → preview → payment integration → profile generation, delivering core value proposition của product.

**Epic 3: Card Design & QR Generation System**
Build automated card design generation với QR code integration, multiple card templates, và high-quality export (PNG/PDF) ready for printing.

**Epic 4: Profile Management Dashboard**
Enable users to manage existing profiles thông qua dashboard, edit information, regenerate cards, và view analytics.

**Epic 5: Public Profile Website Rendering**
Implement dynamic profile website rendering với theme system, responsive design, optimized performance, và SEO-friendly URLs.

---

**Note:** Chi tiết từng Epic được document trong các file riêng:
- `docs/prd/epic-1-foundation.md`
- `docs/prd/epic-2-profile-creation.md`
- `docs/prd/epic-3-card-generation.md`
- `docs/prd/epic-4-dashboard.md`
- `docs/prd/epic-5-profile-rendering.md`

