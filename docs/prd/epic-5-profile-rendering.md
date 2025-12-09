# Epic 5: Public Profile Website Rendering

## Epic Goal

Implement dynamic, beautifully rendered public profile websites với theme system, responsive design, optimized performance, và SEO-friendly URLs. Profile websites là core deliverable - must load fast, look professional, và work perfectly trên all devices.

---

## Story 5.1: Public Profile Route & Data Fetching

**As a** visitor,
**I want** to access profile websites via clean URLs,
**so that** I can view người's profile information.

### Acceptance Criteria

1. Public route: GET /:slug (e.g., platform.com/john-doe)
2. Backend endpoint: GET /api/v1/public/profiles/:slug returns profile data
3. No authentication required cho public profiles
4. Query includes: profile, user (name), workExperiences, socialLinks, theme
5. Prisma query với relations: `include: { workExperiences: true, socialLinks: true, theme: true }`
6. Returns 404 nếu profile not found hoặc isPublished = false
7. Returns 410 Gone nếu profile deleted
8. Data structure: { profile: {...}, workExperiences: [...], socialLinks: [...], theme: {...} }
9. Response cached trong Redis (5 min TTL) cho performance
10. Cache invalidated khi profile updated

---

## Story 5.2: Theme Rendering System

**As a** system,
**I want** a flexible theme rendering engine,
**so that** profiles render beautifully according to selected theme.

### Acceptance Criteria

1. Theme React components trong `/frontend/src/themes/` folder
2. Each theme exports a ProfileComponent: `ModernMinimalTheme`, `ProfessionalDarkTheme`, `CreativeColorfulTheme`
3. Theme component receives props: { profile, workExperiences, socialLinks }
4. Theme configuration JSON defines: colors (primary, secondary, background, text), fonts, layout style
5. Dynamic component loading: `const ThemeComponent = themes[profile.theme.name]`
6. Fallback theme nếu theme not found
7. Theme CSS scoped với CSS modules hoặc styled-components
8. Consistent component structure: Header, About, Experience, Social Links, Footer sections
9. Theme preview mode trong dashboard uses same components
10. Documentation cho creating new themes

---

## Story 5.3: Responsive Profile Layout

**As a** visitor on any device,
**I want** profile websites to look great on my screen,
**so that** I have optimal viewing experience.

### Acceptance Criteria

1. All themes use Tailwind responsive utilities: `sm:`, `md:`, `lg:`, `xl:`
2. Mobile-first design: optimized for portrait phone screens (375px+)
3. Tablet layout: adjusted spacing và font sizes (768px+)
4. Desktop layout: wider containers, multi-column layouts where appropriate (1024px+)
5. Images responsive: `max-w-full h-auto`, avatar displays correctly on all sizes
6. Touch-friendly: buttons min 44x44px, adequate spacing
7. Horizontal scrolling prevented: `overflow-x-hidden`
8. Viewport meta tag: `<meta name="viewport" content="width=device-width, initial-scale=1">`
9. Testing on real devices: iPhone, Android, iPad, desktop browsers
10. No layout shifts (CLS score < 0.1)

---

## Story 5.4: Profile Section - Header với Avatar

**As a** visitor,
**I want** to see profile owner's name, title, và photo prominently,
**so that** I immediately know whose profile this is.

### Acceptance Criteria

1. Header section at top of profile page
2. Avatar image: circular, 150-200px diameter, centered or left-aligned depending on theme
3. Full name displayed: large, bold font (32-48px)
4. Title/position displayed below name: medium font (18-24px), lighter weight
5. Avatar lazy loaded với placeholder
6. Fallback avatar nếu no photo uploaded (initials hoặc default icon)
7. Animations: subtle fade-in on page load
8. Accessible: proper alt text for avatar image
9. High-DPI support: avatar served at 2x resolution
10. Header background color/gradient từ theme configuration

---

## Story 5.5: Profile Section - Contact Information

**As a** visitor,
**I want** to see contact details,
**so that** I can reach out to the profile owner.

### Acceptance Criteria

1. Contact section displays: email, phone, address (if provided)
2. Email displayed as clickable mailto link: `<a href="mailto:...">`
3. Phone displayed as clickable tel link: `<a href="tel:...">`
4. Address displayed with location icon (React Icons)
5. Icons next to each contact item (envelope, phone, map pin)
6. Copy-to-clipboard buttons next to email và phone (optional enhancement)
7. Responsive: stacked on mobile, grid/flex on desktop
8. Privacy: user can choose to hide specific fields
9. Anti-spam: email obfuscated trong HTML (prevent scrapers)
10. Click tracking: logs clicks on contact links (analytics)

---

## Story 5.6: Profile Section - Work Experience Timeline

**As a** visitor,
**I want** to see work experience displayed as timeline,
**so that** I understand the profile owner's career progression.

### Acceptance Criteria

1. Work experiences sorted by startDate descending (most recent first)
2. Each entry shows: company name, position, dates, description
3. Timeline visual: vertical line connecting experiences với dots/icons
4. Date formatting: "Jan 2020 - Present" hoặc "Jan 2020 - Dec 2022"
5. "Present" for ongoing positions (endDate is null)
6. Description supports line breaks và basic formatting
7. Animations: entries fade/slide in on scroll (Intersection Observer)
8. Responsive: timeline adapts to mobile (simpler layout)
9. Empty state: message nếu no work experiences
10. Maximum description length: truncate với "Read more" expand

---

## Story 5.7: Profile Section - Social Links với Icons

**As a** visitor,
**I want** to see social media links với recognizable icons,
**so that** I can easily connect on different platforms.

### Acceptance Criteria

1. Social links section displays buttons/icons for each link
2. Platform-specific icons: LinkedIn, Facebook, Instagram, Twitter, GitHub, etc (React Icons)
3. Icon buttons style: circular hoặc rounded squares, theme colors
4. Hover effects: scale, color change, tooltip showing platform name
5. Links open trong new tab: `target="_blank" rel="noopener noreferrer"`
6. Display order matches user's specified displayOrder
7. Responsive: flex-wrap ensures icons don't overflow
8. Animations: icons animate on hover (subtle bounce, rotate)
9. Accessibility: aria-labels for screen readers
10. Click tracking: logs social link clicks

---

## Story 5.8: SEO Optimization

**As a** profile owner,
**I want** my profile to be SEO-friendly,
**so that** people can find me via search engines.

### Acceptance Criteria

1. Dynamic meta tags: `<title>`, `<meta name="description">`, Open Graph tags
2. Title format: "{Full Name} - {Title} | Platform Name"
3. Meta description: First 160 chars of profile summary hoặc generated từ name + title
4. Open Graph tags: og:title, og:description, og:image (avatar), og:url
5. Twitter Card tags: twitter:card, twitter:title, twitter:description, twitter:image
6. Canonical URL: `<link rel="canonical" href="...">`
7. Structured data: JSON-LD schema.org Person markup
8. Sitemap: profiles included trong sitemap.xml (if applicable)
9. Robots.txt: allows indexing of profile pages
10. Page load speed optimized (LCP < 2.5s) for SEO ranking

---

## Story 5.9: Performance Optimization

**As a** visitor,
**I want** profile pages to load instantly,
**so that** I have smooth browsing experience.

### Acceptance Criteria

1. Server-side rendering (SSR) hoặc Static Site Generation (SSG) for initial HTML
2. Code splitting: theme components lazy loaded
3. Image optimization: avatars served via CDN, optimized formats (WebP với fallback)
4. Critical CSS inlined trong `<head>`, rest loaded async
5. JavaScript bundle size minimized: tree-shaking, minification
6. Fonts optimized: subset fonts, font-display: swap
7. Caching headers: Cache-Control set appropriately
8. Prefetching: DNS prefetch cho external resources
9. Lighthouse score: Performance > 90, Accessibility > 90
10. Monitoring: track Core Web Vitals (LCP, FID, CLS)

---

## Story 5.10: Profile Page Enhancements

**As a** visitor,
**I want** additional features to enhance my experience,
**so that** I get maximum value từ profile page.

### Acceptance Criteria

1. "Download vCard" button: generates .vcf file with contact info (vcard library)
2. QR code displayed at bottom: small QR pointing to profile URL (meta!)
3. Share buttons: share profile on social media directly từ profile page
4. Dark mode toggle: visitors can switch to dark theme (saved in localStorage)
5. Print stylesheet: profile prints nicely on paper
6. Language switcher: if i18n implemented, toggle Vietnamese/English
7. "Report Profile" link: abuse reporting (optional safety feature)
8. View counter: "Profile viewed X times" (if user enables)
9. Custom domain support: if user has custom domain, profile accessible there (advanced)
10. Animations disabled cho prefers-reduced-motion users (accessibility)

---

## Dependencies & Sequencing

**Must Complete First:**
- Epic 2 completed (profiles exist với data)
- Epic 1 story 1.9 (themes seeded)

**Sequential Development:**
- 5.1 (data fetching) → 5.2 (theme system) must complete first
- 5.3-5.7 (sections) can develop in parallel sau 5.2
- 5.8 (SEO) can parallel với sections
- 5.9 (performance) is optimization pass sau 5.1-5.8
- 5.10 (enhancements) is last (nice-to-haves)

---

## Definition of Done

- [ ] All 10 stories completed với acceptance criteria met
- [ ] Public profile URLs accessible và render correctly
- [ ] All themes implemented và look professional
- [ ] Fully responsive on mobile, tablet, desktop
- [ ] All profile sections display correctly
- [ ] SEO meta tags populated
- [ ] Lighthouse performance score > 90
- [ ] Load time under 2 seconds on 4G
- [ ] Tested on multiple browsers (Chrome, Firefox, Safari, Edge)
- [ ] Tested on real devices (iOS, Android)
- [ ] Accessibility audit passed (keyboard navigation, screen readers)
- [ ] Unit tests cho theme rendering logic
- [ ] E2E tests covering profile page load và interactions
