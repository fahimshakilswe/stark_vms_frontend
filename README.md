# Stark Group VMS — Flutter Web Frontend

A responsive, enterprise-grade Vehicle Management System frontend built with **Flutter Web**, strictly adhering to **Clean Architecture**, feature-driven folder organization, and modern enterprise SaaS UI/UX design patterns.

The frontend interfaces directly with the Spring Boot REST API (`stark-vms-backend`) to provide real-time user authentication, JWT session security, fleet tracking, debounced search, multi-attribute filtering, 0-indexed page-based pagination, and complete vehicle lifecycle management (Create, Read, Update, Delete).

---

## 1. Project Overview

- **Application Title:** Stark Group VMS
- **Repository:** `stark_vms_frontend`
- **Application Target:** Flutter Web (Desktop, Tablet, and Mobile browsers)
- **Backend Architecture:** Java 21 / Spring Boot 4 REST API (`stark-vms-backend`)
- **Database:** MySQL 8 managed exclusively by the Spring Boot backend
- **Authentication:** Stateless Bearer JWT tokens stored in Web-secure storage

### Core Features
- **Live Fleet Dashboard:** Real-time summary cards displaying Total Vehicles, Available Vehicles, Active Vehicles, Inactive Vehicles, and Under Maintenance calculated directly from backend database records.
- **Enterprise Design System & Color Palette:**
  - Deep Blue: `#1F4E79` — Navigation, sidebar, headings, headers.
  - Corporate Blue: `#5B9BD5` — Primary actions, buttons, highlights.
  - Soft Gray: `#F5F7FA` — Page background.
  - White: `#FFFFFF` — Cards, forms, tables, surfaces.
  - Charcoal: `#1F2937` — Main text.
  - Green: `#2E7D32` — Active and success states.
  - Red: `#D32F2F` — Delete, destructive, and error actions.
- **Polished Data Table:** 12-column responsive shadcn-style table displaying Vehicle Number, Type, Brand, Model, Manufacturing Year, Color, Fuel Type, Seating Capacity, Driver Name, Driver Phone, Status badges, and row-level Edit/Delete actions.
- **Numbered Page-Based Pagination:** Zero-indexed pagination (`page=0`, `size=10`) with Previous/Next controls, `Showing X–Y of Z vehicles` range indicator, and `Page A of B` tracking driven by backend `totalElements`, `totalPages`, and `last`.
- **Debounced Multi-Field Search & Filtering:** 450ms debounced case-insensitive search across vehicle number, brand, model, and driver name with race-condition protection, combined with Vehicle Type, Fuel Type, and Status filters.
- **Reusable Add/Edit Vehicle Form:** Single unified form with a responsive two-column layout on desktop/tablet and single-column on mobile.
- **HTTP 409 Duplicate Vehicle Number Handling:** Extracts duplicate resource error messages directly from the backend response and renders them immediately beneath the Vehicle Number field while preserving all other entered form values.
- **shadcn_ui Dialog Delete Confirmation:** Modally displays the vehicle number in a confirmation dialog before executing backend deletion.
- **shadcn_ui Toast Feedback:** Rich toast notifications on creation, modification, and deletion.
- **Robust Connection Handling:** Graceful offline and network failure handling displaying: *"Unable to connect to the server. Please check your connection and try again."*

---

## 2. Vehicle Model & Enums

### Vehicle Fields
- `vehicleNumber`: Unique vehicle registration string (e.g. `DHA-METRO-GA-11-1001`)
- `vehicleType`: Category of vehicle (enum)
- `brand`: Manufacturer brand (e.g. `Toyota`, `Mercedes-Benz`)
- `model`: Model designation (e.g. `Corolla Altis`, `Sprinter`)
- `manufacturingYear`: Optional year of manufacture (`1900` to current year)
- `color`: Optional exterior color description
- `fuelType`: Engine fuel type (enum)
- `seatingCapacity`: Optional passenger seating capacity (`> 0`)
- `driverName`: Optional assigned driver name
- `driverPhone`: Optional assigned driver contact number
- `status`: Operational status (enum, default: `Available`)

### Backend Enums
- **VehicleType:** `CAR`, `SUV`, `MICROBUS`, `VAN`, `TRUCK`, `PICKUP`
- **FuelType:** `OCTANE`, `PETROL`, `DIESEL`, `CNG`, `LPG`
- **VehicleStatus:** `AVAILABLE`, `ACTIVE`, `INACTIVE`, `MAINTENANCE`

---

## 3. Technology Stack

| Layer / Concern | Technology | Package Version |
|---|---|---|
| **Framework** | Flutter Web (Dart SDK 3.13+) | `Flutter 3.47.9` |
| **Architecture** | Clean Architecture (Domain, Data, Presentation, Core) | Feature-Based |
| **State Management** | Riverpod | `flutter_riverpod: ^3.5.0` |
| **HTTP Client** | Dio & Retrofit | `dio: ^5.11.1`, `retrofit: ^4.10.0` |
| **Serialization** | JSON Annotation & Builder | `json_annotation: ^4.12.0`, `json_serializable: ^6.15.2` |
| **Code Generation** | Build Runner & Retrofit Generator | `build_runner: ^2.17.1`, `retrofit_generator: ^10.3.3` |
| **Routing** | GoRouter (ShellRoute + Auth Redirects) | `go_router: ^18.1.4` |
| **Secure Token Storage** | Flutter Secure Storage (Web Cryptography / IndexedDB) | `flutter_secure_storage: ^11.2.0` |
| **Local Preferences** | Hive | `hive: ^2.2.3`, `hive_flutter: ^1.1.0` |
| **Design System** | shadcn_ui + Material 3 Design Tokens | `shadcn_ui: ^0.61.2` |
| **Loading Skeletons** | Skeletonizer | `skeletonizer: ^3.0.0` |
| **Pagination** | Infinite Scroll Pagination | `infinite_scroll_pagination: ^6.0.0` |
| **Date Formatting** | Intl | `intl: ^0.20.3` |

---

## 4. Architecture Explanation

The application follows strict **Clean Architecture** principles separated into four cohesive layers:

```text
               ┌─────────────────────────────────────┐
               │         Presentation Layer          │
               │  Screens, Widgets, Riverpod State   │
               └──────────────────┬──────────────────┘
                                  │ depends on
                                  ▼
               ┌─────────────────────────────────────┐
               │            Domain Layer             │
               │ Entities, Use Cases, Repositories   │
               │      (Pure Dart, zero HTTP)         │
               └──────────────────▲──────────────────┘
                                  │ implemented by
                                  │
               ┌──────────────────┴──────────────────┐
               │             Data Layer              │
               │   DTOs, Models, Retrofit Services,  │
               │        Repository Implementations   │
               └──────────────────┬──────────────────┘
                                  │ configured by
                                  ▼
               ┌─────────────────────────────────────┐
               │             Core Layer              │
               │   Config, Storage, Network, Theme   │
               └─────────────────────────────────────┘
```

1. **Domain Layer:** Pure Dart business logic independent of UI widgets and HTTP implementations. Contains entities (`UserEntity`, `VehicleEntity`, `VehiclePageEntity`, `DashboardMetricsEntity`), enums (`VehicleType`, `FuelType`, `VehicleStatus`), use cases (`GetDashboardMetricsUseCase`, `GetVehiclesUseCase`, `CreateVehicleUseCase`, etc.), and repository interfaces.
2. **Data Layer:** Handles API interaction, JSON serialization, and persistence. Contains Retrofit clients (`VehicleApiService`, `AuthApiService`), Request/Response DTO models (`VehicleModel`, `VehicleRequestModel`), data sources, and repository implementations mapping DTOs to entities.
3. **Presentation Layer:** Riverpod notifiers (`AuthNotifier`, `VehicleFilterNotifier`, `VehicleFormNotifier`), responsive UI screens (`DashboardScreen`, `VehicleListScreen`, `VehicleAddScreen`, `VehicleEditScreen`, `LoginScreen`, `RegisterScreen`), and reusable widgets.
4. **Core Layer:** Cross-cutting infrastructure: Dio client setup with authorization & logging interceptors, Web-secure token storage, Hive initialization, centralized theme tokens matching the required corporate palette, route definitions, and validation helpers.

---

## 5. Installation Instructions

### Prerequisites
- [Flutter SDK](https://docs.flutter.dev/get-started/install) (Version `3.24.0` or newer)
- Google Chrome browser (for local web debugging)
- Running instance of the Spring Boot backend (`stark-vms-backend`) on `http://localhost:8080` (or configured remote URL)

### Clone & Install
```bash
# Clone the repository
git clone https://github.com/your-org/stark_vms_frontend.git
cd stark_vms_frontend

# Download all project dependencies
flutter pub get
```

---

## 6. Code Generation

The project utilizes `build_runner` for generating Retrofit HTTP clients (`.g.dart`) and JSON serializers (`json_serializable`). Whenever models or service contracts are modified, run:

```bash
# Run code generation
dart run build_runner build --delete-conflicting-outputs
```

---

## 7. Environment & API Configuration

By default, the application connects to the local Spring Boot backend running on `http://localhost:8080/api/v1`.

You can configure the backend API URL dynamically at runtime or build time using Flutter's `--dart-define` flag:

### Local Development
```bash
flutter run -d chrome
```

### Pointing to a Custom API URL
```bash
flutter run -d chrome --dart-define=API_BASE_URL=http://localhost:8080/api/v1
```

### Production Build
```bash
flutter build web --dart-define=API_BASE_URL=https://api.starkvms.com/api/v1
```

---

## 8. Verification & Testing

Execute static analysis and automated test suites:

```bash
# Verify static analysis (zero errors/warnings)
flutter analyze

# Run unit tests
flutter test

# Run build verification for Web
flutter build web
```
