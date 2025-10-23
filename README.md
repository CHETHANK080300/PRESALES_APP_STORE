# Internal App Store - Flutter Frontend

This is the Flutter frontend for an internal application store. It provides a user-friendly interface for team members to browse, download, and manage internal Android (APK) and iOS (IPA) applications.

## Features

*   **Authentication**: Secure login screen for users and admins.
*   **App Showcase**: A dashboard that displays a list of available apps with detailed information like version, build number, and status.
*   **Platform-Specific Downloads**:
    *   Direct APK download for Android.
    *   Seamless installation for iOS via `itms-services`.
*   **Admin Capabilities**: A dedicated page for admins to upload new application files (APKs/IPAs) along with their metadata.
*   **Responsive UI**: A clean, card-based layout that works on web and mobile.
*   **State Management**: Built with Riverpod for robust and scalable state management.
*   **Environment Configuration**: Uses a `.env` file to easily configure the backend API endpoint.

## Tech Stack

*   **Framework**: Flutter
*   **State Management**: `flutter_riverpod`
*   **Navigation**: `go_router`
*   **API Client**: `dio`
*   **Environment**: `flutter_dotenv`

## Prerequisites

*   [Flutter SDK](https://docs.flutter.dev/get-started/install) (version 3.x or higher)
*   A running instance of the [Spring Boot backend](<backend_repo_link_here>).

## Getting Started

Follow these instructions to get the project up and running on your local machine.

### 1. Clone the Repository

```sh
git clone <your-repo-url>
cd presales_app_store
```

### 2. Install Dependencies

```sh
flutter pub get
```

### 3. Configure Environment Variables

The application loads its API configuration from a `.env` file at the root of the project.

1.  **Create the `.env` file**:
    ```sh
    cp .env.example .env
    ```

2.  **Edit the `.env` file**:
    Open the newly created `.env` file and set the `API_BASE_URL` to point to your running backend instance.

    ```env
    # Example:
    API_BASE_URL=http://localhost:8092/api
    ```

### 4. Add Local Assets

This project uses a local background image and a logo. You need to create the assets folder and place the files there:

1.  Create the directory: `assets/images`
2.  Place your background file at: `assets/images/background.jpg`
3.  Place your logo file at: `assets/images/logo.svg`

The `pubspec.yaml` is already configured to include these assets.

### 5. Run the Application

You can run the application on any supported platform. To run it on the web (Chrome):

```sh
flutter run -d chrome
```

## Connecting to the Backend

This Flutter application is designed to work with a specific Spring Boot backend. Ensure that:

1.  The backend server is running.
2.  The `API_BASE_URL` in your `.env` file correctly points to the backend's address.
3.  The backend implements the required API endpoints for authentication (`/auth/login`), fetching apps (`/apps`), and uploading files (`/apps/upload`).

## Project Structure

The project follows a feature-first directory structure to keep the code organized and modular.

```
lib/
├── features/
│   ├── auth/             # Authentication feature (login)
│   │   ├── providers/
│   │   └── ui/
│   │       └── login_page.dart
│   ├── dashboard/        # Main dashboard and app list
│   │   ├── models/
│   │   ├── providers/
│   │   └── ui/
│   │       ├── dashboard_page.dart
│   │       └── widgets/
│   │           └── app_card.dart
│   └── upload/           # App upload feature
│       └── ui/
│           └── upload_page.dart
├── services/             # Core services (API, Auth)
│   ├── api_service.dart
│   └── auth_service.dart
├── routes/               # Navigation and routing
│   └── app_router.dart
├── shared/               # Shared widgets and utilities
│   └── common_app_bar.dart
└── main.dart             # App entry point
```