# Epic 3: Card Design & QR Generation System

## Epic Goal

Build automated card design generation system với QR code integration, multiple card templates, và high-quality export (PNG/PDF) ready for printing. Users receive print-ready files immediately sau khi profile created.

---

## Story 3.1: QR Code Generation Service

**As a** system,
**I want** to generate high-resolution QR codes cho profile URLs,
**so that** users có QR codes để in trên business cards.

### Acceptance Criteria

1. QR generation module using `qrcode` library
2. Function `generateQRCode(url)` accepts profile URL
3. Generates QR code với options: size 1000x1000px, error correction level H (high)
4. Output format: PNG với transparent background
5. QR code saved to file storage (local dev / cloud prod)
6. Returns QR code URL: { qrCodeUrl: "https://..." }
7. QR codes stored trong `/qrcodes/:profileId.png`
8. Testing: Generated QR codes scannable với smartphone cameras
9. Handles errors: invalid URL, file storage failures
10. Function called automatically during profile creation workflow

---

## Story 3.2: Card Template System

**As a** developer,
**I want** a flexible card template system,
**so that** we can easily add new card designs trong future.

### Acceptance Criteria

1. Card templates defined as HTML/CSS files trong `/templates/cards/` folder
2. Initial templates: `modern-minimal.html`, `professional-dark.html`, `creative-colorful.html`
3. Each template has placeholders: `{{fullName}}`, `{{title}}`, `{{qrCodeUrl}}`, `{{themeColor}}`
4. Template engine (Handlebars hoặc EJS) renders HTML với profile data
5. CSS includes print-ready specifications: 9cm x 5cm với 3mm bleed
6. Templates use web-safe fonts hoặc embedded fonts
7. Each template has corresponding config JSON: dimensions, color scheme, font family
8. Templates responsive to theme selection (colors adapt to user's chosen theme)
9. Template selection logic: card template matches website theme
10. Documentation cho creating new templates

---

## Story 3.3: Card Design Rendering với Puppeteer

**As a** system,
**I want** to render HTML card templates to high-resolution images,
**so that** users receive print-quality card files.

### Acceptance Criteria

1. Puppeteer installed và configured trong Docker container
2. Function `renderCardDesign(templateHtml, outputPath)` launches headless browser
3. Loads rendered HTML into Puppeteer page
4. Sets viewport: 1063 x 591 px (9cm x 5cm at 300 DPI với bleed)
5. Takes screenshot với options: fullPage, omitBackground (for transparency support)
6. Saves PNG file to storage
7. Returns file path/URL
8. Puppeteer runs inside Docker với necessary dependencies (fonts, chromium)
9. Resource cleanup: browser instances closed properly
10. Timeout handling: max 30 seconds per render
11. Error handling: rendering failures logged và reported

---

## Story 3.4: PNG Card File Generation

**As a** user,
**I want** a PNG version của card design,
**so that** I can preview và share digitally.

### Acceptance Criteria

1. POST /api/v1/cards/generate endpoint triggered sau profile creation
2. Accepts profileId as parameter
3. Fetches profile data từ database (name, title, QR code URL, theme)
4. Selects appropriate card template based on theme
5. Renders template với Handlebars + profile data
6. Calls Puppeteer rendering function
7. Generates PNG at 300 DPI (high resolution)
8. Saves PNG file: `/cards/:profileId/card.png`
9. Creates Card record trong database: { profileId, qrCodeUrl, pngFileUrl }
10. Returns PNG download URL
11. File size optimized (under 5MB) using Sharp
12. Preview PNG also generated (72 DPI) cho web display

---

## Story 3.5: PDF Card File Generation

**As a** user,
**I want** a PDF version của card design,
**so that** I can send directly to print shops.

### Acceptance Criteria

1. Same endpoint /api/v1/cards/generate creates both PNG và PDF
2. Puppeteer `page.pdf()` method generates PDF từ rendered HTML
3. PDF settings: format custom (9cm x 5cm), printBackground: true, margin: 0
4. Includes 3mm bleed area trong PDF
5. CMYK color profile applied cho print compatibility (using pdf-lib if needed)
6. PDF file saved: `/cards/:profileId/card.pdf`
7. Updates Card record: { pdfFileUrl }
8. PDF file size reasonable (under 10MB)
9. PDF viewable trong standard PDF readers
10. Testing: PDF prints correctly at actual size

---

## Story 3.6: Card Regeneration

**As a** user,
**I want** to regenerate my card design sau khi updating profile info,
**so that** my printed cards reflect latest information.

### Acceptance Criteria

1. POST /api/v1/cards/:cardId/regenerate endpoint cho authenticated users
2. Verifies user owns the card (via profile ownership)
3. Fetches latest profile data từ database
4. Deletes old card files từ storage
5. Regenerates QR code (if profile URL changed - though it shouldn't)
6. Regenerates PNG và PDF files với latest data
7. Updates Card record với new file URLs và updatedAt timestamp
8. Returns new download links
9. Old files cleaned up (prevents storage bloat)
10. Rate limiting: max 5 regenerations per profile per day

---

## Story 3.7: Bulk Card Generation (Multiple Designs)

**As a** user,
**I want** to generate card designs trong multiple templates,
**so that** I can choose which design to print.

### Acceptance Criteria

1. POST /api/v1/cards/generate-all endpoint accepts profileId và array of template IDs
2. Loops through requested templates
3. Generates separate PNG/PDF for each template
4. Files organized: `/cards/:profileId/:templateName/card.png`
5. Creates multiple Card records linked to same profile
6. Returns array of card objects với download URLs
7. Async processing: returns job ID immediately, processes in background
8. Job status endpoint: GET /api/v1/cards/jobs/:jobId returns progress
9. Webhook/notification khi generation complete
10. Max 5 templates per request (prevent abuse)

---

## Story 3.8: Card Preview Thumbnail Generation

**As a** user,
**I want** to see thumbnail previews của card designs,
**so that** I can quickly browse options trước khi downloading.

### Acceptance Criteria

1. During card generation, creates thumbnail version
2. Thumbnail dimensions: 400x225px (maintains aspect ratio)
3. Uses Sharp to resize PNG: `sharp(pngBuffer).resize(400, 225).toFile()`
4. Thumbnail URL stored: `/cards/:profileId/thumbnail.png`
5. Card record includes: { thumbnailUrl }
6. Thumbnails displayed trong dashboard và preview screens
7. Lazy loading implemented cho thumbnail galleries
8. Thumbnails load fast (under 100KB each)

---

## Story 3.9: Print Specifications Validation

**As a** system,
**I want** to validate card designs meet print requirements,
**so that** users receive print-ready files.

### Acceptance Criteria

1. Validation function checks generated files:
   - Resolution: exactly 300 DPI
   - Dimensions: 9cm x 5cm (1063 x 591 px at 300 DPI)
   - Bleed area: 3mm included
   - Color mode: RGB (CMYK conversion optional for PDF)
2. PDF validation: page size correct, no compression artifacts
3. QR code size: minimum 2cm x 2cm trong design (scannable)
4. Text readability: minimum 8pt font size
5. Validation runs automatically sau generation
6. Failed validation logs error và notifies admin
7. Validation report stored: `/cards/:profileId/validation.json`
8. Dashboard shows validation status badge (passed/failed)

---

## Story 3.10: Card File Delivery & Download Management

**As a** user,
**I want** reliable download links cho my card files,
**so that** I can access them anytime.

### Acceptance Criteria

1. GET /api/v1/cards/:cardId/download/:fileType endpoint (fileType: png, pdf, thumbnail)
2. Authenticates user owns the card
3. Generates signed URL if using cloud storage (S3 presigned URL)
4. Sets proper Content-Disposition header: `attachment; filename="card.png"`
5. Content-Type headers: image/png, application/pdf
6. Download tracking: logs download count trong Card record
7. Rate limiting: max 50 downloads per hour per user
8. Expired files handling: regenerate if file older than 30 days
9. Zip file option: GET /api/v1/cards/:cardId/download-all returns ZIP với PNG+PDF
10. Mobile-friendly download (works on iOS Safari, Chrome Mobile)

---

## Dependencies & Sequencing

**Must Complete First:**
- Epic 2 completed (profiles created, QR codes needed)

**Sequential Development:**
- 3.1 (QR generation) → 3.2 (templates) → 3.3 (Puppeteer) → 3.4, 3.5 (PNG/PDF generation)
- 3.6 (regeneration) depends on 3.4, 3.5
- 3.7 (bulk generation) depends on 3.4, 3.5
- 3.8 (thumbnails) depends on 3.4
- 3.9 (validation) can parallel với 3.4-3.8
- 3.10 (download) is last

---

## Definition of Done

- [ ] All 10 stories completed với acceptance criteria met
- [ ] QR codes generated correctly và scannable
- [ ] Card templates render beautifully
- [ ] PNG và PDF files print-ready (300 DPI)
- [ ] Users can download card files
- [ ] Card regeneration works
- [ ] Validation ensures print quality
- [ ] Puppeteer runs stable trong Docker
- [ ] Unit tests cho QR generation và template rendering
- [ ] Integration tests cho full card generation flow
- [ ] Load testing: can generate 100 cards concurrently
- [ ] Documentation for adding new templates
