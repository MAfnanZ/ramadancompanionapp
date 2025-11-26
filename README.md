# ramadancompanionapp

A Flutter mobile app providing prayer times, Qibla direction, and Ramadan Calendar to track Imsa and Iftar times.

## Features
- Daily prayer times based on location.
- Ramadan calendar with Hijri dates.
- Qibla direction using device compass.

## Getting Started

### Prerequisites
- Flutter SDK installed (>= 3.0.0)
- Dart SDK
- An IDE such as VSCode or Android Studio
- A device or emulator to run the app

### Running the App
1. Clone this repository:
   ```shell
   git clone https://github.com/MAfnanZ/ramadancompanionapp.git
   cd ramadancompanionapp
   ```

2. Run flutter pub get
    ```shell
    flutter pub get
    ```

3. Run flutter 
    ```shell
    flutter run
    ```

### Pre-created test Account
email: tester@rma.com
password: 1234qwerT

### Build
1. Build android apk
    ```shell
    flutter build apk --target-platform=android-arm64
    ```
2. Apk directory
    build\app\outputs\flutter-apk\app-release.apk

## App Structure
- lib/main.dart: App entry point, initializes providers.
- lib/pages/: Screens for navigation, including Prayer Times, Ramadan      Calendar, Qibla and Profile pages
- lib/widgets/: Reusable UI components like buttons and list tiles.
- lib/tools/: Helper functions for time formatting and typedef.
- lib/services/: Manages Firebase Auth and API calls, organized into domain (core entities), models (data structures), repo (API/network handling), and provider (state management).

1. Authentication
    - Repository: lib/services/auth/domain/repos/auth_repo.dart – Defines the abstract interface for authentication.  
    - Implementation: lib/services/auth/data/firebase_auth_repo.dart - Concrete implementation that handles Firebase login, register, logout, and user state management.
    - Model: lib/services/auth/domain/models/app_user.dart - Represents user data.
    - Provider: lib/services/auth/presentation/provider/auth_provider.dart – Uses ChangeNotifier to expose auth state (AuthInitial, AuthLoading,  AuthAuthenticated, AuthUnauthenticated) to the UI.
    - States: lib/services/auth/presentation/provider/auth_states.dart - Defines the various authentication states (initial, loading, authenticated, unauthenticated, error) used by the AuthProvider to manage and reflect login state changes in the UI.

2. Prayer API
    - Repository: lib/services/api/domain/repos/prayer_repo.dart – Provides all prayer-related operations by calling PrayerApi and converting responses into models.
    - HttpClient: lib/services/api/data/http_client.dart - Builds URLs, performs GET requests, decodes JSON safely, and returns either a map, list, or raw response.
    - Prayer API: lib/services/api/data/prayer_api.dart - Fetch prayer times, next prayer, current Hijri year, and Ramadan Sehri/Iftar calendar. This layer only deals with URLs and raw JSON responses, while the repository converts them into models.
    - Model: lib/services/api/domain/models - Represent prayer data such as prayer times.
    - Provider: lib\services\api\presentation\provider\prayer_provider.dart - It calls the PrayerRepo to fetch prayer data, then exposes the results to widgets while handling loading/error states.
