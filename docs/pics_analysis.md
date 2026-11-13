# `pics/` — Design Reference Analysis

> Scope: all 70 files in `pics/`.
> Method: file metadata + pixel sampling (palette) + OCR of every screen (Windows OCR, `en-US`), plus
> cross-checking against `lib/`, `assets/` and `app_router.dart`. This model cannot view images directly,
> so **text, layout coordinates, counts and colours are high-confidence; exact illustration/icon/photo
> details are not verified visually.**

---

## 1. Inventory

| Bucket | Count | Notes |
|---|---:|---|
| Screen mockups | **59** | All exactly `402 × 874` px (portrait phone frame) |
| Role banner strips | 3 | `ADMIN PANEL.png` (1007×110), `MANAGER PANEL.png` (1249×113), `USER PANEL.png` (892×113); text only, transparent background |
| Tiny text crops | 8 | `9876543210`, `ABC`, `abc@gmail.com`, `B.Tech`, `Male`, `Profile`, `Rajkot`, `Rajkot-1` (16–59 px wide) — leftover Figma text-layer exports, not screens |
| **Total** | **70** | |

- 5 exact-duplicate pairs (MD5): `Admin/Manager Forgot password`, `Admin/Manager Reset password`,
  `Manager Create Account` = `sign up`, `Manager Success screen` = `success screen`, `Rajkot` = `Rajkot-1`.
- Therefore **55 unique mockups**, of which ~52 are visually distinct designs.
- Two more near-duplicates (same layout, different nav label): `login` ≈ `Manager login 2` and
  `splash screen 4` ≈ `Manager login 1` ≈ `Admin login 1`.

### Breakdown by area (59 files)

| Area | Screens | Notes |
|---|---:|---|
| Onboarding / entry | 4 | `Splash Screen 1–3` + `splash screen 4` (welcome, Login / Sign Up) |
| Customer (User) | 20 | 6 auth + 14 product screens |
| Manager | 18 | 7 auth + 11 product screens |
| Admin | 17 | 6 auth + 11 product screens (4 of the 11 are role copies of manager screens) |
| **Total** | **59** | |

---

## 2. Screen map

### 2.1 Onboarding
| File | Content |
|---|---|
| `Splash Screen 1` | Brand block (`QueueGo` / `ONLINE SALON BOOKING` / `Book. Relax. Enjoy.`) + illustration + **“Your Beauty, Your Time.”** + copy + `Next` |
| `Splash Screen 2` | **“Professional Care, Just for You.”** + `Next` / `Back` |
| `Splash Screen 3` | **“Book in Minutes, Not Hours.”** + `Next` / `Back` |
| `splash screen 4` | Same brand block + two buttons: `Login` / `Sign Up` (entry selector) |

### 2.2 Shared auth flow (role-copied)
Same 6-step flow exists for User, Manager and Admin:

1. **Role entry** (`Admin login 1`, `Manager login 1`, `splash screen 4`) — Login / Sign Up.
2. **Login form** — “Welcome Back!”, full name, email, password, `Forgot Password?`, `Login`,
   “Don’t have an account? Sign Up”.
3. **Create Account** (`sign up`, `Manager Create Account`) — name, email, mobile, password, confirm,
   Terms & Privacy checkbox, `Create Account`, `Already have an account? Log In`.
   *No Admin sign-up screen — correct, admins are provisioned.*
4. **Forgot Password** — email field, `Send Reset Link`, `Back to Login`.
5. **OTP Verification** — 6-digit copy, resend timer `(00:45)`, `Verify OTP`, `Back to Login`.
6. **Reset Password** — new + confirm, `Reset Password`.
7. **Success** — “Password reset successful!”, `Back to Login`.

> Admin has no step 3. Manager and User flows are pixel duplicates for 4 of the 6 steps — one parametric
> auth UI with a role/accent flag is enough.

### 2.3 Customer (User) panel
Bottom nav (5 tabs): **Home · Salons · Services · Bookings · Profile**

| # | Screen | Key content / interactions observed |
|---|---|---|
| 1 | `Home page` | Greeting + headline “Book • Beauty • Relax / Your Style, Your Time, Your Queue.”, 2-field search (service + location), `Find Salons`, Popular Services (Haircut, Hair Styling, Hair Coloring, Makeup), Top Salons cards (rating, reviews, distance, address, popular services, “Starting from”, `View salon`, `Book NOW`) |
| 2 | `Salon` | Salon list: Glow & Glam 4.8 (1.2k, 2.5 km), Style Studio 4.7 (932, 4.1 km), Luxe Salon & Spa 4.5 (178, 3.1 km); tags, open-until, `View Salon` |
| 3 | `Search saloon` | Search field, Recent searches + `Clear All`, Popular searches (Haircut, Hair Spa, Facial, Nails, Makeup, Manicure), Search suggestions (best salons near me, hair color, bridal makeup, men’s grooming, spa and massage) |
| 4 | `view saloon` | Hero image, name/rating/distance/open-until, `Directions` + `Call`, Services tab, About (description, opening hours Mon–Sun, address), `Book Appointment` |
| 5 | `services` | “Beauty & Care Services”, category chips (All / Haircut / Hair Styling / Hair Coloring / Makeup), `See all`, service cards with duration + price (₹299–₹1299) |
| 6 | `view services` | Hero, Hair Coloring, 60 mins, ₹1299, Description, Duration, Price, `Select Staff` |
| 7 | `staff` | 5 stylist cards (specialty + rating + reviews + radio), `Select Staff` |
| 8 | `Select Date & time` | Month strip, date strip (20–26), time-slot grid (09 AM–05 AM…), `Pay Now` |
| 9 | `Select Date & time-1` | **Booking Details**: Confirmed chip, salon + address, service, price, staff, date/time, `Reschedule` / `Cancel Booking`, Booking Summary (Service Amount, Total) |
| 10 | `Booking summary` | Confirmation: “Booking Confirmed !!!”, Booking ID `#Q020250426001`, `View Booking`, `Back to Home` |
| 11 | `Booking` | My Bookings tabs: **Upcoming / Completed / Cancelled**; cards with salon, service, date, time, price, status |
| 12 | `Cancel Booking` | Salon/service summary, reason radios (schedule / personal / another salon / other), `Confirm Cancellation` |
| 13 | `Reschedule Booking` | Salon/service summary, date strip, slot grid, `Confirm Reschedule` |
| 14 | `User Profile` | Avatar, name + “user”, email, phone, Personal Information (name/email/phone/DOB), Language, Theme |

**Not designed for the user flow:** payment method / checkout screen (only a `Pay Now` button),
notifications, reviews/ratings, favourites, address/map picker, settings, empty/error states.

### 2.4 Manager panel
Bottom nav: **Dashboard · Bookings · Customers · Menu · Profile**

| # | Screen | Key content |
|---|---|---|
| 1 | `Manager Dashboard` | KPIs (Total Bookings 24, Revenue ₹12,450, Total customers, Avg rating 4.8, +10.2%), Booking Overview chart (“This Week”), Upcoming Appointments (Priya 10:00, Neha 11:30, Sneha 01:00, status chips), `View All` |
| 2 | `Booking Appointments` | `Today` filter + `All Services` filter, stats Total 6 / Confirmed 3 / Pending 3 / Cancelled 1, appointment cards, “Showing 4 of 6” |
| 3 | `Salon schedule` | `Upcoming` / `All Bookings` tabs, week strip Mon 12 – Sun 18, “Today, 15 Aug 2026”, 4 timeline cards (service, staff, duration, status, time) |
| 4 | `Customer Management` | Total 18 / Active 16 / Inactive 2, search, 5 customer cards with phone + last booking, “Showing 5 of 18” |
| 5 | `Staff Management` | Total 6 / Active 5 / On Leave / Inactive, search, staff cards (role, phone, branch, joined date, status) |
| 6 | `Service Management` | Category chips, service cards with price + duration (Hair Cut, Hair Spa, Pedicure, Manicure, Facial, Nails) |
| 7 | `Working Hours` | Salon status “Currently Open”, month/date strip, “Today, 15 May 2026”, Opening 09:30 AM, Break 01:00–02:00 PM, Closing 08:30 PM, `Save Changes` |
| 8 | `Offers & Discounts` | Tabs All Offers / Services / Packages, “Special event” chip, 5 offer cards with % and validity |
| 9 | `Payment` | Payment Overview (₹50,000 total, 32%), Payment Methods (Cash / Others), Recent Transactions (date, service, amount, status: Pending / Completed), “By Riya” |
| 10 | `Menu` | Staff Management, Service Management, Salon Schedule, Working Hours, Offers & Discounts, Payment, `Log Out` |
| 11 | `Manager Profile` | Avatar, name, “Salon Manager”, email, phone, Personal Information, Salon & Role Details (Salon, Role, Joined On), Others (Language, Theme) |

### 2.5 Admin panel
Bottom nav: **Dashboard · Manager · Customers · Menu · Profile**

| # | Screen | Key content |
|---|---|---|
| 1 | `Admin Dashboard` | Total Bookings 24, Total Revenue ₹12,450, Total customers, Avg Ratings 4.8 (+10.2%), Booking Overview chart, Bookings by service donut (48 total), **Notification feed** (new booking, new customer, payment received ₹1,200, new review) |
| 2 | `Admin Salon Management` | ⚠️ Content is actually **Salon Schedule** (identical to `Salon schedule`) — file is misnamed/mis-designed |
| 3 | `Admin Staff Management` | Same design as manager staff screen, admin nav |
| 4 | `Admin Customer Management` | Same design as manager customer screen, admin nav |
| 5 | `Manager Management` | Manager profile/detail: Priya Sharma, Salon Manager, contact, Personal Information, Permissions, `Deactivate` |
| 6 | `Role & Permissions` | Total roles, role list (Admin full access, Manager manages staff…), permission matrix (Module × Admin/Manager), “Showing 5 permissions” |
| 7 | `Reports and analytics` | Bookings by service donut, Insights (Revenue +15%, Haircut top service, satisfaction 4.6/5, “Increase prices”), Booking Overview chart |
| 8 | `Admin Offers & Discounts` | Same as manager offers, admin nav |
| 9 | `Admin Payment` | Same as manager payments (salon-level earnings), admin nav |
| 10 | `Admin Menu` | Staff Management, Salon Management, Reports & Analytics, Role & Permissions, Offers & Discounts, Payment, `Log Out` |
| 11 | `Admin Profile` | Administrator profile (Anita Shah), Personal Info, Salon & Role Details, Others |

**Not designed for admin:** platform-wide salon list / onboarding / verification, add-edit salon form,
commission & settlement/payout screens, global analytics filters, audit log, admin management CRUD.

---

## 3. Shared layout & visual system

Layout is highly systematic across all 59 screens:

```
y≈16    status bar (9:41 / 10:52)
y≈58    "QueueGo" logo (in-panel screens, x≈68)
y≈104   page title (24–28 px, bold)          ← in-app shell
y≈127   one/two-line subtitle (muted)
y≈190   search / filters / stat cards
y≈250–800 content cards (16 px gap, 16 px side padding)
y≈848   5-tab bottom navigation (icon + label)
```

- Detail/flow screens (`view saloon`, `view services`, `staff`, `Cancel/Reschedule`, `Select Date`,
  `Booking summary`, auth) replace the bottom nav with a **back arrow** and a full-width primary CTA at
  `y≈750–800`.
- Auth screens share a centred brand block at `y≈205–278`, form starting `y≈340`, then a muted
  `Back to Login` link at the bottom.
- Recurring components: stat tile (value + label + delta), status chip (dot + label), search field with
  filter pill, bottom nav, section header with `View All →`, 2-column service grid, horizontal date strip,
  3×N time-slot grid, offer card with % badge, full-width pill CTA, transaction row.

### Confirmed palette (pixel-sampled)

| Role | Colour | Evidence |
|---|---|---|
| Primary / brand berry | `#B1326A` (also `#C2185B`, `#A71958` in mockups) | 4–6% of most screens, matches `AppColors.primary` |
| Accent pink | `#FF81AE` | highlights, gradients |
| Soft pink surface | `#F8D8E4`, `#F8DDE6`, `#FCEDF3`, `#FFF3F7` | page background / input fields / cards |
| Card / page | `#FFFFFF` | 31–78% of every screen |
| Heading text | `#03035A` (deep navy) | titles |
| Body/muted | `#607092` / `#9EA8BD` | subtitles, captions |
| Success | `#039D52` / `#2ED573` | Confirmed, Completed |
| Warning | `#FFA502` (approx.) | Pending |
| Danger | `#FF4757` / `#CC1155` | Cancelled, errors |

> The mockups match `lib/app/theme/app_colors.dart` (berry/magenta + navy). The **README design section is
> stale**: it claims Indigo `#6C5CE7` with coral/mint. Update the README to the berry palette.

---

## 4. Domain model implied by the screens

```
User        (name, email, phone, dob, role, language, theme, status: active|inactive)
Role        (Admin, Manager, Staff, User) + module permissions matrix
Salon       (name, address, city, rating, reviewCount, distanceKm, tags[], openUntil,
             description, openingHours[7], image)
Manager     (user ref, salon ref, joinedOn, permissions[], status)
StaffMember (name, specialty, phone, branch, joinedOn, rating, reviews,
             status: active | onLeave | inactive)
Service     (name, category, description, durationMin, price, image)
Booking     (id, salon, service, staff, customer, date, time, amount,
             status: confirmed | pending | inProgress | completed | cancelled)
Offer       (title, description, discount, validTill, scope: all|service|package, badge)
Transaction (date, service, customer, amount, method, status: pending|completed)
PaymentMethod (cash / others)
Insight     (label, trend, value)
```

Status vocabularies to standardise app-wide: booking `Confirmed / Pending / In Progress / Completed /
Cancelled`; people `Active / On Leave / Inactive`; money `Pending / Completed`.

---

## 5. Duplicates, role copies & mislabels

- **Role copies (same pixels, different bottom nav):** Customer Management, Staff Management,
  Offers & Discounts, Payment, Menu, Profile, Salon Schedule. Admin only changes the second nav tab
  (`Bookings` → `Manager`).
- **Mislabeled files:**
  - `Admin Salon Management.png` → shows the **Salon Schedule** screen.
  - `Manager Management.png` → shows a **manager detail/profile** page, not a list.
  - `Payment.png` / `Admin Payment.png` → show **salon earnings** (not a customer checkout).
  - `Select Date & time-1.png` → is the **Booking Details** screen, not a date picker.
- **Copy defects to fix in UI:** “Saloon” vs “Salon”, “Hair Stylish” (should be Stylist),
  “Completød”, “BOOk NOW”, “Facial Glow Offer — cet off”, dates mix 2025 and 2026
  (“Today, 15 Aug 2026” vs bookings in Apr–May 2025), “We’re sent a 6-digit OTP” (should be “We’ve sent”).
- **Nav inconsistency:** three different 5-tab sets exist (User / Manager / Admin); some admin screens
  still show `Manager` in the second slot, which is intentional for admin, but must be role-driven.

---

## 6. Gap analysis vs current codebase

| Item | State |
|---|---|
| Implemented pages | 9: splash, onboarding, login, signup, OTP, forgot, reset, success |
| Declared routes | ~30 (`RouteNames`) covering user, manager, admin |
| Wired routes | Only the 9 auth/splash pages; every panel route falls through to the “No route defined” placeholder |
| Models / repositories / state | None (no `lib/shared/models`, no state-management or network dependency in `pubspec.yaml`) |
| Assets | Only auth/onboarding slices in `assets/images/` (18 files); 59 mockups not yet sliced |
| Design tokens | `AppColors` matches the mockups; `README.md` palette is outdated |
| Reusable widgets | `AppButton`, `AppTextField` only — no shell/bottom-nav, stat card, status chip, search field, section header, empty state |

So: `pics/` is the **complete specification for the remaining ~85% of the app**, and the router already
names most destinations.

---

## 7. Recommended build order

1. **Shared UI kit** — `AppScaffold` (logo header + title/subtitle), `RoleBottomNav` (3 variants),
   `StatusChip`, `StatTile`, `AppSearchField`, `SectionHeader`, `EmptyState`, `AppCard`.
2. **Domain layer + mock data** — models above, one seeded repository per role so every screen can run
   without a backend.
3. **Customer flow** (highest value, 14 screens):
   home → salon list → search → salon detail → services → service detail → staff → date/time →
   payment (needs design) → booking summary → bookings → booking details → cancel/reschedule → offers →
   profile.
4. **Manager flow** (11 screens) on the shared shell, reusing customer management/staff/offers/payment/menu/profile.
5. **Admin flow** (11 screens), reusing the shared role-copy screens; add the missing salon-list,
   manager-list and permission editing.
6. **Wire the router** with role guards, remove placeholder fallbacks, add loading/empty/error states,
   then slice the remaining mockup artwork into `assets/images/` with snake_case names.

Estimated remaining UI surface: **~46 unique screens** (55 unique mockups − 9 already built).
