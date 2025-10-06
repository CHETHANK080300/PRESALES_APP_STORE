# App Store Frontend

This is the Flutter frontend for the internal app store. It allows users to browse and download Android (APK) and iOS (IPA) apps. Administrators can upload new apps.

## Features

- User and Admin login.
- View a list of available apps.
- Download APKs directly.
- Trigger iOS app installation via `itms-services`.
- Admin dashboard to upload new apps with metadata.
- Multipart file upload with a progress bar.

## Tech Stack

- **Framework**: Flutter
- **State Management**: Riverpod
- **API Client**: Dio
- **Environment**: flutter_dotenv
- **Secure Storage**: flutter_secure_storage (for mobile)
- **Web Storage**: shared_preferences (for web)

## Project Structure

The project is structured to separate concerns and group files by feature.

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
    The frontend needs to know the base URL of the backend server. This is configured using an environment file.

    - Create a file named `.env` in the root of the project.
    - Add the following line to the file, replacing the URL with your backend's address:
      ```
      API_BASE_URL=http://localhost:8080/api
      ```
    - A `.env.example` file is provided as a template.

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

Ensure your backend server is running and accessible at the `API_BASE_URL` you configured in the `.env` file. The `api_service.dart` file handles the communication with these endpoints, and `auth_service.dart` manages the JWT token for authenticated requests.