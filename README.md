# Stark Vehicle Management System (VMS) — Flutter Web Frontend

A responsive, enterprise-grade Vehicle Management System frontend built with **Flutter Web**, strictly following **Clean Architecture**, feature-driven folder organization, and modern SaaS UI/UX design patterns.

The frontend interfaces directly with the independent Spring Boot REST API (`stark-vms-backend`) to provide real-time user authentication, JWT session security, fleet tracking, search, multi-attribute filtering, 0-indexed pagination, and complete vehicle lifecycle management (Create, Read, Update, Delete).

---

## 1. Project Overview

- **Project Name:** Stark Vehicle Management System (VMS)
- **Repository:** `stark_vms_frontend`
- **Application Target:** Flutter Web (Desktop, Tablet, and Mobile browsers)
- **Backend Architecture:** Java 21 / Spring Boot 4 REST API (`stark-vms-backend`)
- **Database:** MySQL 8 managed exclusively by the Spring Boot backend
- **Authentication:** Stateless Bearer JWT tokens stored in Web-secure encrypted storage

### Core Features
- **User Authentication:** New user registration with strict backend-aligned password complexity rules (`@StrongPassword`), credential validation, and JWT authentication.
- **Enterprise Application Shell:** Responsive desktop sidebar, compact tablet rail, and mobile navigation drawer with active route tracking and administrator profile integration.
- **Fleet Management & Data Table:** Monospace vehicle number badges, company, type, brand & model, color-coded status badges (`ACTIVE`, `MAINTENANCE`, `INACTIVE`, `RETIRED`), and inline actions.
- **Incremental Pagination:** Built with `infinite_scroll_pagination` starting at zero-indexed page `0` with page size `10` following the backend Spring Data JPA page contract.
- **Fleet Search & Filtering:** Case-insensitive vehicle number search with debounce, status selection pills, and instant reset capabilities.
- **Vehicle Registration & Editing:** Single reusable responsive form validating required fields and length constraints, with 409 duplicate vehicle number conflict error handling.
- **Secure Destruction:** Modal confirmation dialog identifying vehicle number and fleet operator before dispatching `DELETE /api/v1/vehicles/{id}` requests.
- **State & Skeleton Loading:** Smooth skeleton loading powered by `skeletonizer`, with empty search placeholders and retry-capable error views.

---

## 2. Technology Stack

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

## 3. Architecture Explanation

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

1. **Domain Layer:** Pure Dart business logic independent of UI widgets and HTTP implementations. Contains entities (`UserEntity`, `VehicleEntity`, `VehiclePageEntity`), use cases (`LoginUseCase`, `GetVehiclesUseCase`, `CreateVehicleUseCase`, etc.), and repository interfaces.
2. **Data Layer:** Handles API interaction, JSON serialization, and persistence. Contains Retrofit clients (`AuthApiService`, `VehicleApiService`), Request/Response DTO models, data sources, and repository implementations mapping DTOs to entities.
3. **Presentation Layer:** Riverpod notifiers (`AuthNotifier`, `VehicleFilterNotifier`, `VehicleFormNotifier`), responsive UI screens (`LoginScreen`, `RegisterScreen`, `VehicleListScreen`, `VehicleAddScreen`, `VehicleEditScreen`), and reusable widgets.
4. **Core Layer:** Cross-cutting infrastructure: Dio client setup with authorization & logging interceptors, Web-secure token storage, Hive initialization, centralized theme tokens, route definitions, and validation helpers.

---

## 4. Project Folder Structure

```text
lib/
├── core/
│   ├── config/
│   │   └── env_config.dart                  # Base URLs, timeouts, pagination defaults
│   ├── constants/
│   │   ├── api_constants.dart               # Exact REST endpoints & header constants
│   │   └── app_constants.dart               # Storage keys & system limits
│   ├── error/
│   │   ├── exceptions.dart                  # Custom domain exceptions
│   │   └── failures.dart                    # Clean architecture failure entities
│   ├── network/
│   │   ├── api_response.dart                # Generic Spring Boot ApiResponse<T> envelope
│   │   ├── page_response.dart               # Generic Spring Boot PageResponse<T> envelope
│   │   ├── error_response_dto.dart          # Backend ErrorResponse DTO with field validation map
│   │   ├── auth_interceptor.dart            # Injects Bearer JWT & handles 401 session expiry
│   │   └── dio_client.dart                  # Pre-configured Dio client with error mapper
│   ├── router/
│   │   ├── app_router.dart                  # GoRouter with ShellRoute & auth redirects
│   │   └── route_names.dart                 # Named route string paths
│   ├── storage/
│   │   ├── token_storage.dart               # Web Cryptography secure token storage
│   │   └── hive_service.dart                # Fast local storage for preferences
│   ├── theme/
│   │   ├── app_colors.dart                  # Enterprise SaaS slate/zinc/blue palette & status badges
│   │   └── app_theme.dart                   # Integrated shadcn_ui + Material 3 themes
│   ├── utils/
│   │   ├── toast_utils.dart                 # Standardized enterprise toast notifications
│   │   └── validators.dart                  # Strict validators matching backend annotations
│   └── widgets/
│       ├── app_badge.dart                   # Status badge with color-coded tokens
│       ├── app_button.dart                  # 5-variant button supporting loading spinners
│       ├── app_card.dart                    # Container card with header & actions
│       ├── app_text_field.dart              # Form text field with password toggle
│       ├── confirm_dialog.dart              # Modal confirmation dialog for destructive actions
│       ├── empty_state_view.dart            # Empty state illustration & CTA
│       ├── error_state_view.dart            # User-friendly error container with retry
│       ├── page_header.dart                 # Screen header with title, subtitle & breadcrumbs
│       └── app_shell/
│           ├── app_shell.dart               # Adaptive desktop/tablet/mobile layout container
│           ├── app_sidebar.dart             # Branding, navigation links & profile section
│           └── sidebar_item.dart            # Single navigation item with tooltip support
├── features/
│   ├── auth/
│   │   ├── data/
│   │   │   ├── datasources/                 # Retrofit AuthApiService & RemoteDataSource
│   │   │   ├── models/                      # Login, Register, User, and AuthResponse DTOs
│   │   │   └── repositories/                # AuthRepositoryImpl
│   │   ├── domain/
│   │   │   ├── entities/                    # UserEntity, AuthSessionEntity
│   │   │   ├── repositories/                # AuthRepository interface
│   │   │   └── usecases/                    # LoginUseCase, RegisterUseCase, LogoutUseCase
│   │   └── presentation/
│   │       ├── providers/                   # AuthNotifier & authProvider
│   │       ├── screens/                     # LoginScreen, RegisterScreen
│   │       └── widgets/                     # AuthLayout, PasswordRequirementItem
│   └── vehicles/
│       ├── data/
│       │   ├── datasources/                 # Retrofit VehicleApiService & RemoteDataSource
│       │   ├── models/                      # VehicleModel, VehiclePageResponseModel, VehicleRequestModel
│       │   └── repositories/                # VehicleRepositoryImpl
│       ├── domain/
│       │   ├── entities/                    # VehicleEntity, VehiclePageEntity
│       │   ├── repositories/                # VehicleRepository interface
│       │   └── usecases/                    # GetVehicles, GetById, Create, Update, Delete use cases
│       └── presentation/
│           ├── providers/                   # VehicleFilterNotifier, VehicleFormNotifier
│           ├── screens/                     # VehicleListScreen, VehicleAddScreen, VehicleEditScreen
│           └── widgets/                     # VehicleTable, VehicleMobileCard, VehicleFilterBar, VehicleForm, VehicleSkeleton
├── main.dart                                # Riverpod ProviderScope, Hive init, ShadApp.router
└── test/
    └── widget_test.dart                     # Unit tests for input validators
```

---

## 5. Installation Instructions

### Prerequisites
- [Flutter SDK](https://docs.flutter.dev/get-started/install) (Version `3.24.0` or newer; verified on `Flutter 3.47.9` / `Dart 3.13.7`)
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

The project utilizes `build_runner` for generating Retrofit HTTP clients (`.g.dart`) and JSON serializers (`json_serializable`). Generated files are version-controlled and already included, but if you modify any model or service contract, run:

```bash
# Run one-off build
dart run build_runner build --delete-conflicting-outputs

# Or run active file watcher during development
dart run build_runner watch --delete-conflicting-outputs
```

---

## 7. Environment & API Configuration

By default, the application connects to the local Spring Boot backend running on `http://localhost:8080/api/v1`.

You can configure the backend API URL dynamically at runtime or build time using Flutter's `--dart-define` flag:

### Local Development
```bash
flutter run -d chrome
```

### Pointing to a Custom or Staging API URL
```bash
flutter run -d chrome --dart-define=API_BASE_URL=https://staging-api.starkvms.com/api/v1
```

### Production API URL
```bash
flutter build web --dart-define=API_BASE_URL=https://api.starkvms.com/api/v1
```

---

## 8. Running the Application Locally

1. Ensure the Spring Boot backend (`stark-vms-backend`) is running and MySQL is active.
2. Launch Flutter Web in Chrome:
   ```bash
   flutter run -d chrome
   ```
3. The browser will open automatically at `http://localhost:PORT/`.
4. Use the navigation to:
   - **Register** a new account with an email and strong password (e.g. `AdminPass123!`).
   - **Sign In** to obtain an authenticated session.
   - Access the **Vehicle Fleet** dashboard to create, update, search, filter, and delete vehicle records.

---

## 9. Testing & Quality Verification

Run static code analysis and automated test suites:

```bash
# Execute static lint and semantic analysis (enforces 0 warnings)
flutter analyze

# Execute automated unit and validator tests
flutter test
```

---

## 10. Building for Production

Compile optimized, tree-shaken static web assets for deployment:

```bash
flutter build web --release --dart-define=API_BASE_URL=https://api.yourdomain.com/api/v1
```

The compiled output is located in the `build/web/` directory and can be served using any web server or CDN (Nginx, Apache, Cloudflare Pages, Firebase Hosting, AWS S3 / CloudFront, etc.).

### Example Nginx Configuration (SPA Routing)
```nginx
server {
    listen 80;
    server_name vms.yourdomain.com;
    root /var/www/stark_vms_frontend/build/web;
    index index.html;

    location / {
        try_files $uri $uri/ /index.html;
    }

    location ~* \.(?:ico|css|js|gif|jpe?g|png|woff2?|eot|ttf|svg)$ {
        expires 6M;
        access_log off;
        add_header Cache-Control "public";
    }
}
```

---

## 11. Security & Token Handling

- **Zero Hardcoded Secrets:** Authentication credentials, tokens, and sensitive data are never hardcoded in source files.
- **Secure Storage:** JWT tokens are stored via `flutter_secure_storage` utilizing browser Web Cryptography API and IndexedDB rather than unencrypted local storage.
- **Stateless Authorization:** The `AuthInterceptor` automatically attaches the active Bearer token to all outgoing vehicle REST calls.
- **Automatic Session Expiration:** Any `401 Unauthorized` response triggers automatic session invalidation, clears cached credentials, and safely redirects the user to the Login screen.
- **Protected Routing:** `GoRouter` redirect guards ensure unauthenticated access attempts to protected dashboard routes are rejected and routed to `/login`.
