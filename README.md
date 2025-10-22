# Appzillon App Store Frontend

This is the Flutter frontend for the internal "Appzillon App Store". It allows users to browse and download Android (APK) and iOS (IPA) apps. Administrators can upload new apps.

## Features

- **Router-Based Navigation**: Uses `go_router` for a robust, URL-based navigation system with redirects.
- **Enhanced Login Screen**: A visually rich login screen with a background image and company logo loaded from local assets. Includes form validation.
- **Card-Based App Dashboard**: A modern, card-based layout to display the list of available applications, based on the new design.
- **Consistent UI**: A common app bar is used across all post-login screens for a consistent look and feel.
- **Profile & Sign Out**: The app bar includes a profile menu with a "Sign Out" option.
- **Platform-Specific Downloads**:
    - Direct download for Android APKs.
    - `itms-services` link for iOS IPA installations.
- **Dedicated Upload Page**: A separate page, accessible from the dashboard, for uploading new apps with a multi-part form and progress bar.
- **Debug Banner Removed**: The debug mode banner has been removed for a cleaner look.

## Tech Stack

- **Framework**: Flutter
- **Navigation**: go_router
- **State Management**: Riverpod
- **API Client**: Dio
- **SVG Rendering**: flutter_svg
- **Environment**: flutter_dotenv
- **Secure Storage**: flutter_secure_storage (for mobile)
- **Web Storage**: shared_preferences (for web)

## Project Structure

The project follows a clean architecture, separating concerns into features, services, and reusable components.

```
lib/
├── src/
│   ├── common/ (Reusable widgets, e.g., CommonAppBar)
│   ├── features/
│   │   ├── auth/ (Login)
│   │   ├── dashboard/ (Dashboard)
│   │   ├── apps/ (App List & Card)
│   │   └── admin/ (Upload Page & Form)
│   ├── models/ (Data models, e.g., App)
│   ├── routing/ (GoRouter configuration)
│   └── services/ (API, Authentication)
└── main.dart (App entry point)
```

## Setup and Configuration

1.  **Install Flutter**: Ensure you have the Flutter SDK installed. Follow the [official documentation](https://flutter.dev/docs/get-started/install) for instructions.

2.  **Clone the repository**:
    ```bash
    git clone <repository-url>
    cd presales_app_store
    ```

3.  **Install dependencies**:
    ```bash
    flutter pub get
    ```

4.  **Add Local Assets**:
    The login screen and dashboard require a background image and a logo. You must add these to the project manually.
    - Create the directory: `assets/images/`
    - **Background Image**: Download the background image and save it as `assets/images/background.jpg`.
    - **Logo**: Download the logo and save it as `assets/images/logo.svg`.

5.  **Configure the Backend API**:
    The frontend is configured to connect to a backend API via an environment file.
    - A `.env` file is required in the project root. A `.env.example` file is provided as a template.
    - The `API_BASE_URL` is pre-configured to point to a Postman mock server.
    - The `.env` file is included in `.gitignore` and should not be committed.

## How to Run

- **Web**:
  ```bash
  flutter run -d chrome
  ```
- **Mobile (Android/iOS)**:
  Make sure you have a device connected or an emulator/simulator running.
  ```bash
  flutter run
  ```