# Epic 2: Profile Creation Workflow

## Epic Goal

Implement complete end-to-end user journey từ info input form → theme selection → preview → payment integration → profile generation. Epic này delivers core value proposition của product: user có thể tạo smart card profile trong 5-10 phút và nhận được website profile URL + card design files sau khi thanh toán.

---

## Story 2.1: Profile Info Input Form - Personal Info Step

**As a** logged-in user,
**I want** to fill in my personal information trong form wizard,
**so that** my profile website có complete contact details.

### Acceptance Criteria

1. Frontend wizard Step 1 có form fields: Full Name, Title/Position, Email, Phone, Address
2. Form validation với Yup schema: required fields, email format, phone format
3. React Hook Form manages form state với real-time validation
4. Progress indicator shows "Step 1 of 4" 
5. "Next" button disabled nếu validation fails
6. Form data temporarily stored trong Zustand state (wizard context)
7. Mobile-responsive form layout với Tailwind CSS
8. Auto-save to localStorage every 30 seconds (prevent data loss)

---

## Story 2.2: Profile Info Input Form - Work Experience Step

**As a** user,
**I want** to add multiple work experiences,
**so that** my profile showcases my professional background.

### Acceptance Criteria

1. Frontend wizard Step 2 cho work experience entries
2. "Add Experience" button opens modal/expandable form
3. Each entry has: Company, Position, Start Date, End Date (optional - "Present"), Description
4. Can add multiple work experience entries (minimum 1, maximum 10)
5. Entries can be reordered với drag & drop (react-beautiful-dnd hoặc dnd-kit)
6. Each entry has Edit và Delete buttons
7. Display order saved for later rendering
8. Validation: Company và Position required, dates valid
9. "Back" button returns to Step 1, "Next" proceeds to Step 3

---

## Story 2.3: Profile Info Input Form - Social Links Step

**As a** user,
**I want** to add my social media links,
**so that** visitors can connect với tôi trên các platforms.

### Acceptance Criteria

1. Frontend wizard Step 3 cho social media links
2. Supported platforms: LinkedIn, Facebook, Instagram, Twitter, GitHub, Website, Other
3. Platform selector (dropdown) + URL input field
4. "Add Link" button adds new social link entry
5. URL validation: valid format, platform-specific validation (e.g., LinkedIn URL must contain linkedin.com)
6. Can add up to 10 social links
7. Each entry can be reordered (drag & drop), edited, deleted
8. Display order saved
9. Icons displayed next to platform names (React Icons library)
10. "Back" to Step 2, "Next" to Step 4

---

## Story 2.4: Profile Avatar Upload

**As a** user,
**I want** to upload my profile photo,
**so that** my card và website có professional appearance.

### Acceptance Criteria

1. Frontend có upload area với drag & drop support
2. Clicking upload area opens file picker (accept: image/jpeg, image/png)
3. Image preview displayed immediately after selection
4. Client-side validation: file size max 5MB, dimensions min 200x200px
5. POST /api/v1/profiles/upload-avatar endpoint accepts multipart/form-data
6. Backend uses Multer middleware cho file handling
7. Image processed với Sharp: resize to 500x500px, optimize quality
8. File saved to local storage (dev) hoặc uploaded to cloud (prod)
9. Returns avatar URL: { avatarUrl: "https://..." }
10. Cropping tool (react-image-crop) allows user to crop image before upload
11. Error handling: file too large, invalid format, upload failed

---

## Story 2.5: Theme Selection Gallery

**As a** user,
**I want** to browse và select a theme cho my profile website,
**so that** my profile matches my personal style.

### Acceptance Criteria

1. GET /api/v1/themes endpoint returns available themes từ database
2. Frontend displays theme gallery in grid layout (responsive: 1 col mobile, 2-3 cols desktop)
3. Each theme card shows: thumbnail image, theme name, "Select" button
4. Clicking theme card shows larger preview modal với sample profile
5. Selected theme highlighted với border/checkmark
6. Can switch theme selection before proceeding
7. Theme selection stored trong wizard state
8. "Back" returns to social links step
9. "Next" proceeds to preview screen với selected theme applied

---

## Story 2.6: Live Preview Screen

**As a** user,
**I want** to preview my profile website và card design trước khi thanh toán,
**so that** I can confirm everything looks correct.

### Acceptance Criteria

1. Preview screen shows split view: left = website profile preview, right = card design preview
2. Website preview renders profile data với selected theme (iframe hoặc component preview)
3. Card preview shows mockup với user's name, title, QR code placeholder
4. Preview is interactive: can scroll website preview
5. "Edit" button returns to previous wizard steps
6. Mobile view: stacked layout (website preview on top, card preview below)
7. Data pulled từ Zustand wizard state
8. Có toggle để switch giữa desktop/mobile preview cho website
9. "Proceed to Payment" button enabled when user confirms preview
10. Warning message if required fields missing

---

## Story 2.7: Payment Integration - VNPay

**As a** user,
**I want** to pay for my profile creation via VNPay,
**so that** I can complete my order và nhận deliverables.

### Acceptance Criteria

1. Payment screen shows order summary: Profile creation, Price, Selected theme
2. POST /api/v1/payments/create endpoint creates payment record trong database (status: pending)
3. Generates VNPay payment URL với order details
4. Redirects user to VNPay payment gateway
5. VNPay callback URL: /api/v1/payments/vnpay-callback
6. Callback verifies payment signature với VNPay secret key
7. If payment successful: update payment record (status: completed), create profile record
8. If payment failed: update payment record (status: failed), show error message
9. Successful payment triggers profile generation workflow
10. Returns success URL với payment confirmation

---

## Story 2.8: Profile Generation After Payment

**As a** user,
**I want** my profile automatically generated sau khi thanh toán thành công,
**so that** I immediately have access to my profile website.

### Acceptance Criteria

1. Payment success callback triggers profile creation workflow
2. POST /api/v1/profiles/create creates Profile record với Prisma:
   - Generate unique slug từ full name (lowercase, hyphenated, with random suffix if duplicate)
   - Save all personal info, avatar URL, theme ID
   - Set isPublished = true
3. Create WorkExperience records linked to profile
4. Create SocialLink records linked to profile với display order
5. Generate profile URL: `https://platform.com/:slug`
6. Transaction ensures all records created atomically (Prisma transaction)
7. If generation fails, payment marked as refund_pending
8. Returns profile data: { profileId, slug, profileUrl }
9. Email notification sent với profile link (optional)

---

## Story 2.9: Success Screen với Download Links

**As a** user,
**I want** to see success confirmation và access my deliverables,
**so that** I can download my card files và share my profile link.

### Acceptance Criteria

1. Success screen shows congratulations message
2. Displays profile URL as clickable link: `https://platform.com/:slug`
3. "Copy Link" button copies URL to clipboard
4. Section showing card design previews (PNG and PDF)
5. "Download PNG" button downloads card design PNG file
6. "Download PDF" button downloads card design PDF file
7. "View My Profile" button opens profile website in new tab
8. "Go to Dashboard" button navigates to user dashboard
9. Social share buttons: share profile link on Facebook, Twitter, LinkedIn
10. Email confirmation sent với summary và links (uses nodemailer)

---

## Story 2.10: Form Data Persistence & Recovery

**As a** user,
**I want** my form data saved automatically,
**so that** I don't lose my work nếu browser crashes hoặc I navigate away.

### Acceptance Criteria

1. Wizard form data auto-saved to localStorage every 30 seconds
2. On page load, check localStorage for draft data
3. If draft found và user authenticated, show "Resume Draft" prompt
4. Clicking "Resume" loads data into wizard state
5. Clicking "Start New" clears draft
6. Draft cleared automatically sau khi profile created successfully
7. Draft includes: personal info, work experiences, social links, avatar URL, theme selection
8. Draft has timestamp và expires after 7 days
9. Multiple drafts supported (tied to user ID)

---

## Dependencies & Sequencing

**Must Complete First:**
- Epic 1 completed (auth system và database ready)

**Sequential Stories:**
- 2.1 → 2.2 → 2.3 (wizard steps must be built in order)
- 2.4 can parallel với 2.1-2.3
- 2.5 depends on seeded themes (Epic 1 Story 1.9)
- 2.6 depends on 2.1-2.5 complete
- 2.7-2.8 can be developed in parallel (payment + profile generation)
- 2.9 depends on 2.7-2.8
- 2.10 can be developed anytime after 2.1-2.3

---

## Definition of Done

- [ ] All 10 stories completed với acceptance criteria met
- [ ] User can complete entire wizard flow từ info input → payment
- [ ] Profile created successfully trong database sau payment
- [ ] Success screen displays với profile link và download options
- [ ] Form data persists to localStorage
- [ ] Payment integration working với VNPay sandbox
- [ ] Unit tests cho form validation logic
- [ ] Integration tests cho payment flow
- [ ] E2E test covering full user journey
- [ ] Mobile responsive design verified
- [ ] Code reviewed và merged
