# GoQueue - Project Status, Remaining Work & Step-by-Step Approach

## 1. Executive Summary & Current Status

**GoQueue** is a smart salon queue and appointment booking cross-platform application built in Flutter.
The platform design envisions 3 core roles:
1. **Customer (User)**: Salon discovery, service selection, slot/queue booking, tracking, appointment history, profile.
2. **Salon Manager**: Live queue management, stylist assignment, schedule and working hours, customer check-ins.
3. **Super Admin**: Multi-salon onboarding, role management, revenue/payouts, analytics, platform promotions.

### Current Implementation Assessment
* **Splash & Onboarding**: Fully implemented (`SplashPage` with role selection shortcuts).
* **Authentication Flow**: Complete UI implemented (Login, Sign Up with role switcher, OTP Verification, Forgot Password, Reset Password, Success screen, `AuthService` stub).
* **Customer (User) App**:
  - `UserHomePage`: Implemented with greetings, active queue banner, categories, nearby salons, and popular services.
  - `SalonsListPage`: Implemented with filters, search, and salon cards.
  - `SalonDetailPage`: Implemented with tabs (Services, Stylists, Reviews, About), dynamic queue preview, and booking action modal.
  - `SearchPage`: Implemented with query filtering, category tags, and results.
  - `ServicesListPage`: Implemented for browsing services.
  - `AppointmentsPage`: Implemented with tabs (Upcoming, In Queue, Completed, Cancelled).
* **Data Layer & State**:
  - Currently relying on static mock models (`MockUserData`, in-memory states).
  - No persistent backend (Firebase / REST API) or centralized state management (Bloc / Provider / Riverpod).
* **Manager & Admin Panels**:
  - Defined in `RouteNames` and documented in architectural plans, but **no pages, widgets, or business logic exist yet** in `lib/features/manager/` or `lib/features/admin/`.

---

## 2. Detailed Remaining Things (Gap Analysis)

### A. Customer (User) Features
- [x] **Dedicated Booking Flow Screens**:
  - `userSelectDateTime` (`/user/select-date-time`): Interactive calendar and slot selector with dynamic wait-time estimation.
  - `userBookingSummary` (`/user/booking-summary`): Confirmation screen breaking down selected salon, stylist, service fees, taxes, and applied coupons.
  - `userPayment` (`/user/payment`): Payment method selection (Card, UPI, Netbanking, Pay at Salon) and transaction state simulation.
- [x] **Live Queue Tracker & Ticket Screen**:
  - Live animated queue status screen (e.g., "3 people ahead of you", estimated wait time counter, QR code for arrival check-in).
  - Push/local notifications for turn alert ("You're next in 10 minutes").
- [x] **User Profile & Settings**:
  - Profile view and edit screen (Name, Phone, Email, Avatar).
  - Saved/Favorite Salons screen.
  - Notification and language preferences.
- [x] **Offers & Promotions**:
  - Promo code listing and coupon redemption flow.

### B. Salon Manager Features (Entire Module Missing)
- [x] **Manager Authentication & Salon Linking**:
  - Manager login page with salon verification.
- [x] **Manager Dashboard**:
  - Real-time KPIs: Active Queue count, Today's Appointments, Active Stylists, Total Revenue today.
- [x] **Live Queue Operations**:
  - Queue board: Call next customer, mark in-service, mark completed, mark no-show.
  - Walk-in customer quick entry (add customer directly to queue).
- [x] **Stylist / Staff Management**:
  - Assign stylist to queue tickets.
  - Toggle stylist availability (Active, On Break, Off-duty).
- [x] **Schedule & Hours Configuration**:
  - Operating hours per weekday, holiday calendar, slot duration configuration.
- [x] **Services & Catalog Management**:
  - Add, edit, or disable salon services and pricing.

### C. Super Admin Panel (Entire Module Missing)
- [x] **Admin Dashboard & Analytics**:
  - Platform-wide statistics: total salons, active users, daily bookings, platform commission revenue.
- [x] **Salon Approval & Onboarding**:
  - Review submitted salon applications, approve/reject, configure commission rates.
- [x] **User & Manager Directory**:
  - View all registered users, ban/unban, view audit logs.
- [x] **Discounts & Campaign Engine**:
  - Platform-wide banner management and coupon creation.
- [x] **Settlements & Payouts**:
  - Payout ledger to salon bank accounts.

### D. Architecture, State & Backend Integration
- [x] **State Management**:
  - Introduce an app-wide state management solution (`provider` with `QueueProvider`) for managing queue state, auth sessions, and cart/booking flow.
- [x] **Local Storage**:
  - Secure storage / `shared_preferences` for caching auth tokens, queue position, and user preferences.
- [ ] **Backend / API Layer**:
  - Connect to a real backend (Node.js/Go/Firebase/Supabase).
  - Replace mock repositories with HTTP/WebSocket services for live queue synchronization.
- [ ] **Real-time Synchronization**:
  - WebSockets or Firebase Realtime DB / Firestore for instant queue number updates.

---

## 3. Step-by-Step Approach (Roadmap)

```text
Phase 1: Complete User Journey  -->  Phase 2: Architecture & State
         │                                       │
Phase 4: Super Admin Panel      <--  Phase 3: Salon Manager Panel
         │
Phase 5: Real-Time Backend & QA
```

### Phase 1: Complete the Customer (User) Journey (UI & Mock Flow)
1. **Step 1.1 - Booking & Checkout Flow**:
   - Implement `SelectDateTimePage` with date picker, slot grid, and stylist selection.
   - Implement `BookingSummaryPage` with breakdown and coupon entry.
   - Implement `PaymentPage` with dummy payment gateways and success routing.
2. **Step 1.2 - Live Queue Pass / Ticket**:
   - Create a dedicated `LiveQueueTicketPage` accessible from `UserHomePage` or `AppointmentsPage`.
   - Add QR code generation for arrival verification.
3. **Step 1.3 - User Profile & Offers**:
   - Build `UserProfilePage` with account details, favorite salons, and logout trigger.
   - Build `OffersPage` to view promo banners and discount codes.
4. **Step 1.4 - Routing & Navigation**:
   - Wire all new screens into `AppRouter` and test the complete customer booking cycle.

### Phase 2: State Management & Architecture Hardening
1. **Step 2.1 - Add Dependencies**:
   - Add state management (`flutter_bloc` or `provider`), storage (`shared_preferences` / `flutter_secure_storage`), and networking (`dio` / `http`).
2. **Step 2.2 - Centralize Business Logic**:
   - Refactor Auth, Queue, and Booking from static mocks into reactive state stores (Cubit/Bloc/Notifiers).
   - Enable realistic queue updates (timer-based or reactive updates).

### Phase 3: Salon Manager Module
1. **Step 3.1 - Manager Shell & Navigation**:
   - Create `ManagerDashboardPage` with bottom navigation or responsive drawer.
2. **Step 3.2 - Live Queue Board**:
   - Build Kanban/List queue interface: Waiting -> In Chair -> Done.
   - Implement quick walk-in registration modal.
3. **Step 3.3 - Staff & Service Configuration**:
   - CRUD interface for salon services and staff roster management.

### Phase 4: Super Admin Panel
1. **Step 4.1 - Admin Layout**:
   - Create a desktop/tablet-optimized responsive dashboard layout.
2. **Step 4.2 - Salon & Manager Management**:
   - List registered salons, verify documents, assign managers.
3. **Step 4.3 - Platform Analytics & Campaigns**:
   - Metrics cards, revenue charts, and banner/coupon managers.

### Phase 5: Backend Integration, Real-Time Sync & Testing
1. **Step 5.1 - API Contracts & Authentication**:
   - Integrate JWT login, token refresh, and role-based route guards.
2. **Step 5.2 - WebSocket / Push Notifications**:
   - Implement WebSocket connection for live queue position decrements and push notifications.
3. **Step 5.3 - End-to-End Testing & Polish**:
   - Comprehensive widget tests for checkout, queue transitions, and role navigation.
   - Performance and UI polish across Android, iOS, and Web.
