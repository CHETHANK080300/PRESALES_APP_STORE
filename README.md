# Appzillon App Store Frontend

This is the Flutter frontend for the internal "Appzillon App Store". It allows users to browse and download Android (APK) and iOS (IPA) apps. Administrators can upload new apps.

## Features

- **Enhanced Login Screen**: A visually rich login screen with a background image and company logo loaded from local assets. Includes form validation.
- **User and Admin Authentication**: Login functionality to authenticate users against the backend.
- **Dashboard**: A central dashboard page after login that displays a list of available apps and provides a link to the upload page.
- **Custom App Bar**: The dashboard features a custom app bar with the company logo and a profile icon that opens a menu with a "Sign Out" option.
- **Platform-Specific Downloads**:
    - Direct download for Android APKs.
    - `itms-services` link for iOS IPA installations.
- **Dedicated Upload Page**: A separate page for uploading new apps, complete with a multi-part form and a progress bar.

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
│   │   ├── dashboard/ (Dashboard)
│   │   └── admin/ (Upload Page & Form)
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

4.  **Add Local Assets**:
    The login screen and dashboard require a background image and a logo. You must add these to the project manually.
    - Create the directory: `assets/images/`
    - **Background Image**: Download the background image from the URL below and save it as `assets/images/bg-image.jpg`:
      ```
      https://digitalbankhitachi.appzillon.com:8502/corporate-admin/appzillon/styles/themes/bankAdmin/img/bg-image.jpg
      ```
    - **Logo**: Download the logo from the URL below and save it as `assets/images/nbf-dash-img.svg`:
      ```
      https://digitalbankhitachi.appzillon.com:8502/corporate-assisted/apps/styles/themes/CorporateOnboarding/img/nbf-dash-img.svg
      ```

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