# GoQueue ✂️⏱️

> **Next-Generation Smart Salon Queue & Appointment Booking Platform**  
> Streamlining salon visits with real-time queue management, multi-role dashboards, and appointment scheduling.

---

## 📌 Overview

**GoQueue** is a cross-platform Flutter application built to digitize salon and grooming service operations. It solves long wait times and unstructured scheduling by offering live queue monitoring, pre-booking, service discovery, and a 3-tier role-based management ecosystem for **Customers**, **Salon Managers**, and **Platform Administrators**.

---

## 🚀 Key Features by Panel

### 👤 1. Customer (User) Panel
* **Discovery & Search**: Browse nearby salons, ratings, opening hours, and available stylists.
* **Service Catalog**: Explore haircuts, styling, treatments, and combo packages with pricing.
* **Smart Booking & Queue Tracking**:
  * Book appointment slots or join a live virtual queue.
  * Real-time queue status and estimated wait time.
  * Easy rescheduling and cancellation flows.
* **Payments & Offers**: Integrated payment methods, discount coupons, and booking summary receipts.
* **Profile & History**: Manage past appointments, favorite salons, and personal profile details.

### 👔 2. Salon Manager Panel
* **Manager Dashboard**: Live metrics for current queue count, today's appointments, and active stylists.
* **Schedule & Working Hours**: Configure daily business hours, shift timings, and salon availability.
* **Queue & Service Management**: Add/edit services, price updates, duration settings, and walk-in queue management.
* **Customer & Staff Control**: Monitor customer arrival check-ins and assign stylists dynamically.

### 🛡️ 3. Super Admin Panel
* **Central Analytics & Reports**: Revenue analytics, total bookings, salon performance, and customer trends.
* **Multi-Salon Management**: Onboard new salons, verify listings, and assign managers.
* **Role & Permission Management**: Granular control over manager and staff roles and access levels.
* **Offers & Promotions**: Create platform-wide campaigns, discount banners, and promo codes.
* **Payment Settlements**: Overview of transactions, commissions, and payouts.

---

## 🏗️ Architecture & Project Structure

The project implements **Clean Architecture** paired with a **Modular Feature-First** folder structure:

```text
lib/
├── app/                  # Application bootstrap, routing & design system
│   ├── router/           # Centralized Route configuration (AppRouter & RouteNames)
│   └── theme/            # Design tokens (AppColors, AppRadius, AppSpacing, AppTheme)
├── core/                 # Shared foundational services, utils & primitives
│   ├── constants/        # Global constants (AppConstants, Assets, API URLs)
│   ├── extensions/       # Context, String, and helper extensions
│   ├── services/         # Global singletons (NavigationService, Storage, Notifications)
│   ├── utils/            # Validators, Date/Time formatters, Helpers
│   └── widgets/          # Reusable atomic UI components (AppButton, AppTextField, AppCard)
├── features/             # Domain & feature modules
│   ├── splash/           # Walkthrough & Onboarding flows
│   ├── auth/             # Login, Sign Up, OTP, Forgot & Reset Password
│   ├── user/             # Customer discovery, queue, booking & payment
│   ├── manager/          # Manager dashboard, schedule, queue management
│   └── admin/            # Super Admin panel, analytics, role management
└── shared/               # Cross-feature widgets and response models
    ├── models/           # Common DTOs & pagination models
    └── widgets/          # AppScaffold, custom cards, table components
```

---

## 🎨 Design System

GoQueue follows a clean, modern aesthetic inspired by the Figma design system:
* **Primary Palette**: Deep Indigo / Violet (`#6C5CE7`)
* **Accents**: Soft Coral (`#FF7675`) & Mint Cyan (`#00CEC9`)
* **Backgrounds**: Ultra-clean Off-White (`#F8F9FD`) with crisp White Cards (`#FFFFFF`)
* **Typography & Shapes**: Modern curved cards (`12px` - `16px` radius) with smooth drop shadows.

---

## 🛠️ Tech Stack & Requirements

* **Framework**: [Flutter](https://flutter.dev) (v3.13+ / Dart 3+)
* **Architecture**: Clean Architecture (Feature-First)
* **Design Pattern**: Domain-Driven Modular Design
* **Target Platforms**: Android, iOS, Web

---

## 🏁 Getting Started

### Prerequisites
Make sure you have Flutter installed:
```bash
flutter --version
```

### Installation
1. Clone the repository:
   ```bash
   git clone https://github.com/kkalariya988-spec/GoQueue.git
   cd GoQueue
   ```

2. Fetch dependencies:
   ```bash
   flutter pub get
   ```

3. Run static analysis:
   ```bash
   flutter analyze
   ```

4. Launch the application:
   ```bash
   flutter run
   ```

---

## 📄 License
This project is proprietary and developed by **Khushi Kalariya** for **GoQueue**.
