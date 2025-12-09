# 🚀 Hướng Dẫn Deploy Smart QR Business Card

## ✅ Checklist Trước Khi Deploy

- [x] Code không có lỗi
- [x] Đã xóa Google OAuth
- [x] Đã xóa Redis references
- [x] Đã xóa theme selection
- [x] API URL sử dụng environment variables
- [x] Wizard hoàn chỉnh với 5 steps
- [x] Authentication hoạt động (email/password)
- [x] Avatar upload hoạt động
- [x] QR code generation hoạt động
- [x] Analytics hoạt động

---

## 📦 Stack Deploy

**Frontend**: Vercel  
**Backend**: Railway hoặc Render  
**Database**: Neon PostgreSQL (free tier)  
**File Storage**: Cần upgrade lên Cloudinary

---

## 🎯 Option 1: Vercel + Railway (Recommended)

### 1. Deploy Database - Neon PostgreSQL

1. Truy cập https://neon.tech
2. Tạo account và project mới
3. Copy `DATABASE_URL` (dạng: `postgresql://user:pass@host/dbname`)
4. Lưu lại để dùng cho backend

### 2. Deploy Backend - Railway

#### Bước 1: Chuẩn bị code

Tạo file `railway.json` trong thư mục `backend/`:

```json
{
  "$schema": "https://railway.app/railway.schema.json",
  "build": {
    "builder": "NIXPACKS"
  },
  "deploy": {
    "startCommand": "npm run start",
    "restartPolicyType": "ON_FAILURE",
    "restartPolicyMaxRetries": 10
  }
}
```

Tạo file `.dockerignore` trong `backend/`:

```
node_modules
npm-debug.log
.env
.git
.gitignore
README.md
uploads
```

#### Bước 2: Deploy lên Railway

1. Truy cập https://railway.app
2. Login với GitHub
3. Click "New Project" → "Deploy from GitHub repo"
4. Chọn repo của bạn
5. Chọn thư mục `backend`

#### Bước 3: Set Environment Variables

Vào Settings → Variables, thêm:

```env
NODE_ENV=production
PORT=3000
DATABASE_URL=<your-neon-postgresql-url>
JWT_SECRET=<generate-strong-secret-here>
JWT_REFRESH_SECRET=<generate-another-strong-secret>
FRONTEND_URL=https://your-app.vercel.app
UPLOAD_DIR=/uploads
MAX_FILE_SIZE=5242880
```

**Generate JWT secrets:**
```bash
node -e "console.log(require('crypto').randomBytes(32).toString('hex'))"
```

#### Bước 4: Run Migration

Trong Railway terminal:
```bash
npx prisma migrate deploy
npx prisma generate
```

#### Bước 5: Lấy Backend URL

Copy URL từ Railway (dạng: `https://your-app.up.railway.app`)

### 3. Deploy Frontend - Vercel

#### Bước 1: Chuẩn bị code

Tạo file `vercel.json` trong thư mục `frontend/`:

```json
{
  "rewrites": [
    { "source": "/(.*)", "destination": "/index.html" }
  ],
  "headers": [
    {
      "source": "/(.*)",
      "headers": [
        {
          "key": "X-Frame-Options",
          "value": "DENY"
        },
        {
          "key": "X-Content-Type-Options",
          "value": "nosniff"
        }
      ]
    }
  ]
}
```

Update `frontend/.env.production`:

```env
VITE_API_URL=https://your-backend.up.railway.app
```

#### Bước 2: Deploy lên Vercel

**Cách 1: CLI (Recommended)**

```bash
# Install Vercel CLI
npm install -g vercel

# Navigate to frontend folder
cd frontend

# Deploy
vercel

# Hoặc deploy production
vercel --prod
```

**Cách 2: GitHub Integration**

1. Truy cập https://vercel.com
2. Login với GitHub
3. Click "Add New Project"
4. Import repo của bạn
5. Set Root Directory: `frontend`
6. Set Environment Variables:
   - `VITE_API_URL`: Backend URL từ Railway

#### Bước 3: Update Backend FRONTEND_URL

Quay lại Railway → Settings → Variables:
- Update `FRONTEND_URL` = URL từ Vercel (dạng: `https://your-app.vercel.app`)
- Redeploy backend

---

## 🎯 Option 2: Full Stack trên Railway

### 1. Deploy Database

- Tạo PostgreSQL service trong Railway
- Copy `DATABASE_URL`

### 2. Deploy Backend

- Deploy như hướng dẫn trên
- Add environment variables

### 3. Deploy Frontend

1. Tạo service mới cho Frontend
2. Root Directory: `frontend`
3. Build Command: `npm run build`
4. Start Command: `npm run preview`
5. Environment Variables:
   - `VITE_API_URL`: Backend URL

---

## 📝 Cấu Hình File Upload (Cloudinary)

### 1. Tạo Cloudinary Account

1. Truy cập https://cloudinary.com
2. Đăng ký free tier
3. Vào Dashboard → Copy:
   - Cloud Name
   - API Key
   - API Secret

### 2. Update Backend Code

Cài package:
```bash
cd backend
npm install cloudinary multer-storage-cloudinary
```

Update `backend/src/controllers/profile.controller.js`:

```javascript
import { v2 as cloudinary } from 'cloudinary';
import { CloudinaryStorage } from 'multer-storage-cloudinary';

cloudinary.config({
  cloud_name: process.env.CLOUDINARY_CLOUD_NAME,
  api_key: process.env.CLOUDINARY_API_KEY,
  api_secret: process.env.CLOUDINARY_API_SECRET
});

const storage = new CloudinaryStorage({
  cloudinary: cloudinary,
  params: {
    folder: 'avatars',
    allowed_formats: ['jpg', 'png', 'jpeg'],
    transformation: [{ width: 500, height: 500, crop: 'limit' }]
  }
});

export const upload = multer({ storage });
```

### 3. Add Environment Variables

Railway/Vercel:
```env
CLOUDINARY_CLOUD_NAME=your-cloud-name
CLOUDINARY_API_KEY=your-api-key
CLOUDINARY_API_SECRET=your-api-secret
```

---

## 🔒 Security Checklist

- [ ] Change JWT_SECRET và JWT_REFRESH_SECRET
- [ ] Enable HTTPS only
- [ ] Set secure CORS policy
- [ ] Enable rate limiting
- [ ] Add helmet.js headers
- [ ] Validate all user inputs
- [ ] Sanitize file uploads
- [ ] Use environment variables (không commit .env)

---

## 🧪 Test Sau Khi Deploy

1. **Register & Login**
   - Tạo account mới
   - Login thành công
   - Token được lưu

2. **Create Profile**
   - Step 1: Personal Info
   - Step 2: Work Experience
   - Step 3: Social Links
   - Step 4: Avatar Upload
   - Step 5: Preview & Create

3. **Profile Features**
   - View public profile
   - Edit profile
   - Analytics dashboard
   - QR code download

4. **Performance**
   - Page load < 3s
   - API response < 500ms
   - Image upload < 5s

---

## 📊 Monitoring

### Railway
- Dashboard → View Logs
- Metrics tab → CPU, Memory usage
- Set up alerts

### Vercel
- Analytics → Page views
- Speed Insights → Performance
- Error tracking

---

## 🔄 CI/CD (Optional)

### GitHub Actions

Tạo `.github/workflows/deploy.yml`:

```yaml
name: Deploy

on:
  push:
    branches: [ main ]

jobs:
  deploy-backend:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - name: Deploy to Railway
        run: railway up
        env:
          RAILWAY_TOKEN: ${{ secrets.RAILWAY_TOKEN }}

  deploy-frontend:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - name: Deploy to Vercel
        run: vercel --prod --token=${{ secrets.VERCEL_TOKEN }}
```

---

## 🆘 Troubleshooting

### Lỗi CORS
```javascript
// backend/src/index.js
app.use(cors({
  origin: process.env.FRONTEND_URL,
  credentials: true
}));
```

### Database Connection Failed
- Kiểm tra DATABASE_URL
- Whitelist IP ở Neon
- Run migrations

### 500 Internal Server Error
- Check Railway logs
- Verify environment variables
- Check Prisma client generated

### File Upload Failed
- Verify Cloudinary credentials
- Check file size limits
- Test with curl

---

## 📞 Support

Nếu gặp vấn đề:
1. Check logs trên Railway/Vercel
2. Verify environment variables
3. Test locally với production build
4. Check database connections

---

## 🎉 Done!

App của bạn đã live tại:
- **Frontend**: https://your-app.vercel.app
- **Backend API**: https://your-backend.railway.app
- **Docs**: https://your-backend.railway.app/api/v1/docs

**Next Steps:**
- Add custom domain
- Setup CDN
- Enable monitoring
- Add more features!
