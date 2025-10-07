# Appzillon App Store Frontend

This is the Flutter frontend for the internal "Appzillon App Store". It allows users to browse and download Android (APK) and iOS (IPA) apps. Administrators can upload new apps.

## Features

- **Enhanced Login Screen**: A visually rich login screen with a background image and company logo loaded from the network.
- **User and Admin Authentication**: Login functionality to authenticate users against the backend.
- **App Listing**: View a list of available apps with their name, version, and purpose.
- **Platform-Specific Downloads**:
    - Direct download for Android APKs.
    - `itms-services` link for iOS IPA installations.
- **Admin Dashboard**: A tabbed view for admins to either view the app list or upload new applications.
- **Multipart File Upload**: An upload form with a progress bar for uploading app files (APK/IPA) and their metadata.

## Tech Stack

- **Framework**: Flutter
- **State Management**: Riverpod
- **API Client**: Dio
- **SVG Rendering**: flutter_svg
- **Environment**: flutter_dotenv
- **Secure Storage**: flutter_secure_storage (for mobile)
- **Web Storage**: shared_preferences (for web)

## Project Structure

The project follows a clean architecture, separating concerns into features and layers.

```
lib/
├── src/
│   ├── features/
│   │   ├── auth/ (Login)
│   │   ├── apps/ (App List)
│   │   └── admin/ (Admin Dashboard, Upload Form)
│   ├── models/ (Data models, e.g., App)
│   ├── services/ (API, Authentication)
│   └── utils/ (Utilities)
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

4.  **Configure the Backend API**:
    The frontend is configured to connect to a backend API. This is managed via an environment file.

    - A `.env` file is required in the project root. A `.env.example` file is provided as a template.
    - The `API_BASE_URL` is pre-configured to point to a Postman mock server:
      ```
      API_BASE_URL=https://3fb50b4c-b75e-45ae-8588-482f660d5cb8.mock.pstmn.io/api
      ```
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

## Connecting to the Spring Boot Backend

This frontend is designed to work with a Java Spring Boot backend that exposes the following endpoints:

- `POST /api/auth/login`
- `GET /api/apps`
- `POST /api/apps/upload`

Ensure your backend server is running and accessible at the `API_BASE_URL` you configured in the `.env` file. The `api_service.dart` handles all communication with these endpoints.