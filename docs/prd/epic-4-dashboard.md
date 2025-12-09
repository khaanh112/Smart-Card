# Epic 4: Profile Management Dashboard

## Epic Goal

Enable users to manage existing profiles thông qua intuitive dashboard - edit information, regenerate cards, view analytics, và manage multiple profiles. Dashboard provides ongoing value sau initial profile creation.

---

## Story 4.1: User Dashboard Overview Page

**As a** logged-in user,
**I want** to see overview của all my profiles,
**so that** I can quickly access và manage them.

### Acceptance Criteria

1. GET /api/v1/profiles endpoint returns all profiles for authenticated user
2. Dashboard shows grid/list of profile cards
3. Each profile card displays: thumbnail, full name, slug, creation date, status (published/draft)
4. Quick actions on each card: View Profile, Edit, Download Cards, Delete
5. "Create New Profile" button prominently displayed
6. Empty state with illustration khi user has no profiles
7. Search/filter functionality: search by name, filter by status
8. Responsive layout: grid on desktop, list on mobile
9. Profile count displayed: "You have 3 profiles"
10. Loading states với skeletons during data fetch

---

## Story 4.2: Profile Editing Form

**As a** user,
**I want** to edit my profile information,
**so that** I can keep my profile up-to-date.

### Acceptance Criteria

1. Clicking "Edit" navigates to /dashboard/profiles/:profileId/edit
2. Form pre-populated với existing profile data từ database
3. Same form fields as creation wizard (personal info, work experience, social links)
4. Avatar update: can upload new photo hoặc keep existing
5. PUT /api/v1/profiles/:profileId endpoint updates profile
6. Validation: same rules as creation form
7. Changes saved to database via Prisma transaction
8. Success message: "Profile updated successfully"
9. Automatically regenerates card designs với updated info
10. "Cancel" button returns to dashboard without saving
11. Unsaved changes warning khi navigating away

---

## Story 4.3: Profile Analytics Dashboard

**As a** user,
**I want** to see analytics về my profile usage,
**so that** I know how many people viewed my profile và scanned my QR code.

### Acceptance Criteria

1. Analytics tracking model trong database: ProfileView { id, profileId, timestamp, source, ipAddress, userAgent }
2. Public profile page logs view: POST /api/v1/analytics/track-view (no auth required)
3. QR code scans tracked separately với source = "qr_scan"
4. GET /api/v1/profiles/:profileId/analytics returns aggregated data
5. Dashboard analytics section shows:
   - Total profile views (all time)
   - Views last 7 days, last 30 days
   - Total QR scans
   - Chart: views over time (line chart với Chart.js hoặc Recharts)
6. Top referral sources (if available from headers)
7. Device breakdown: mobile vs desktop
8. Privacy-focused: no personal data collected from visitors
9. Analytics cached trong Redis (1 hour TTL) cho performance
10. "Export Analytics" button downloads CSV report

---

## Story 4.4: QR Code Download & Sharing

**As a** user,
**I want** to download just the QR code,
**so that** I can use it trong other materials (presentations, emails, etc).

### Acceptance Criteria

1. Dashboard profile card has "Download QR Code" option
2. GET /api/v1/profiles/:profileId/qr-code endpoint returns QR code image
3. Multiple size options: Small (300x300), Medium (600x600), Large (1000x1000)
4. Format options: PNG (transparent), PNG (white bg), SVG
5. QR code preview modal before downloading
6. "Copy QR URL" button copies direct QR image link
7. Social sharing: "Share Profile" generates social media posts với profile link
8. WhatsApp share: pre-filled message với profile link
9. Email share: opens email client với profile link trong body
10. QR code watermark option: add small logo trong center (optional feature)

---

## Story 4.5: Profile Publish/Unpublish Toggle

**As a** user,
**I want** to unpublish my profile temporarily,
**so that** my profile URL returns 404 khi I don't want it public.

### Acceptance Criteria

1. Profile record has `isPublished` boolean field
2. Dashboard profile card shows toggle switch: "Published" / "Unpublished"
3. PATCH /api/v1/profiles/:profileId/publish endpoint updates status
4. Unpublished profiles return 404 khi accessed publicly
5. User can still view own unpublished profile trong dashboard (preview mode)
6. Badge indicator: "DRAFT" badge on unpublished profiles
7. Toggle confirmation modal: "Are you sure you want to unpublish?"
8. Analytics stop tracking khi unpublished
9. QR codes still generated but lead to 404 (user can republish later)
10. Bulk action: publish/unpublish multiple profiles

---

## Story 4.6: Profile Duplication

**As a** user,
**I want** to duplicate an existing profile,
**so that** I can quickly create variations for different purposes.

### Acceptance Criteria

1. "Duplicate" action on profile card
2. POST /api/v1/profiles/:profileId/duplicate creates copy
3. Duplicated profile has new unique slug (original-slug-copy-1)
4. All data copied: personal info, work experiences, social links
5. Avatar copied hoặc references same file
6. New profile starts as unpublished/draft
7. User redirected to edit form cho duplicated profile
8. Success message: "Profile duplicated. Make your changes below."
9. New card designs NOT generated immediately (only after user edits và publishes)
10. Duplicate count tracked (prevent abuse): max 10 duplicates per original

---

## Story 4.7: Profile Deletion

**As a** user,
**I want** to delete my profile,
**so that** I can remove profiles I no longer need.

### Acceptance Criteria

1. "Delete" action on profile card
2. Confirmation modal: "Are you sure? This cannot be undone."
3. User must type profile slug to confirm deletion (prevents accidents)
4. DELETE /api/v1/profiles/:profileId endpoint
5. Soft delete: profile.deletedAt timestamp set (not hard deleted)
6. Associated data soft deleted: work experiences, social links
7. Card files deleted từ storage (PNG, PDF, thumbnails)
8. Profile URLs return 410 Gone (not 404)
9. Deleted profiles not shown trong dashboard
10. Admin can recover within 30 days, then hard deleted
11. Analytics data preserved cho historical records

---

## Story 4.8: Card Design Theme Switching

**As a** user,
**I want** to change my profile theme sau khi created,
**so that** I can update my card design style.

### Acceptance Criteria

1. Profile edit page has "Change Theme" section
2. Shows current theme với thumbnail
3. "Browse Themes" button opens theme gallery modal
4. Same theme selection UI as creation wizard
5. PUT /api/v1/profiles/:profileId/theme updates themeId
6. Theme change triggers automatic card regeneration
7. Shows preview of profile với new theme before confirming
8. Confirmation: "Regenerate card designs với new theme?"
9. New PNG/PDF files generated và old files archived
10. User notified khi regeneration complete (in-app notification hoặc email)

---

## Story 4.9: Bulk Actions on Profiles

**As a** user with multiple profiles,
**I want** to perform actions on multiple profiles at once,
**so that** I can manage them efficiently.

### Acceptance Criteria

1. Checkbox on each profile card
2. "Select All" checkbox trong dashboard header
3. Bulk action bar appears khi profiles selected: "X profiles selected"
4. Bulk actions available: Publish, Unpublish, Download All Cards, Delete
5. Bulk publish: publishes all selected profiles
6. Bulk download: generates ZIP file với all card files
7. Bulk delete: confirms và deletes all selected (same confirmation rules)
8. Progress indicator cho bulk operations
9. Results summary: "5 profiles published, 1 failed"
10. Failed operations show error details

---

## Story 4.10: Dashboard Settings & Preferences

**As a** user,
**I want** to customize my dashboard experience,
**so that** it works best for my workflow.

### Acceptance Criteria

1. Settings page: /dashboard/settings
2. Display preferences: Grid view vs List view, items per page
3. Notification preferences: email notifications for analytics milestones (e.g., 100 views)
4. Default theme selection: auto-apply to new profiles
5. Account settings: update email, password, delete account
6. Privacy settings: allow/disallow analytics tracking
7. API access: generate API key cho developers (advanced feature)
8. Settings saved to user record trong database
9. Export all data: GDPR compliance, downloads JSON với all profile data
10. Dark mode toggle cho dashboard (optional enhancement)

---

## Dependencies & Sequencing

**Must Complete First:**
- Epic 2 completed (profiles exist)
- Epic 3 completed (cards exist)

**Can Develop in Parallel:**
- Stories 4.1-4.10 mostly independent
- 4.2 (edit) should complete early
- 4.8 (theme switching) depends on 4.2

---

## Definition of Done

- [ ] All 10 stories completed với acceptance criteria met
- [ ] Dashboard loads all user profiles correctly
- [ ] Can edit profiles và changes persist
- [ ] Analytics tracking working và displaying correctly
- [ ] Can publish/unpublish profiles
- [ ] Profile duplication và deletion work
- [ ] Theme switching triggers card regeneration
- [ ] Bulk actions functional
- [ ] Settings saved và applied
- [ ] Mobile responsive dashboard
- [ ] Unit tests cho dashboard controllers
- [ ] Integration tests cho CRUD operations
- [ ] Performance: dashboard loads under 1 second với 10+ profiles
