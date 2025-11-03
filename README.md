# 📱 Flutter Video Chat Demo

A **clean architecture Flutter app** demonstrating authentication, real-time video calling (using Agora SDK), and user listing with offline caching.  
Designed to be close to store-ready and follow production-level standards in structure, maintainability, and error handling.

---

## 🚀 Features Overview

### ✅ **Task 1 — Authentication & Login**
- Login with email/password using [ReqRes API](https://reqres.in/api/login)
- Input validation (empty/email format)
- Network connectivity check (offline indicator)
- Persists login session with `AuthLocalSource` (SharedPreferences)
- Redirects authenticated users directly to the next screen

### ✅ **Task 2 — Video Call Screen (Agora SDK Integration)**
- Integrated **Agora SDK** (`agora_rtc_engine`)
- One-to-one real-time video calling
- Hardcoded meeting/channel ID for simplicity
- Local + remote video preview
- Mute/unmute and enable/disable camera controls
- Screen share support (optional)
- Proper architecture separation:
    - `VideoCallRepository` → Agora SDK integration
    - `VideoCallNotifier` → UI control
- Connection monitoring & graceful disconnection

### ✅ **Task 3 — User List (REST API Integration + Offline Cache)**
- Fetch users from ReqRes (`/api/users`)
- Display round avatar, name, email, and mock phone number
- Smooth pagination
- Offline cache using `UserLocalSource`
- Refresh & auto-reload when network is back

---

## 🧩 Architecture Overview

This project follows **Clean Architecture** and **Feature-First Foldering** using **Riverpod** for state management.

```
lib/
 ├── core/
 │    ├── api/
 │    │    └── api_client.dart
 │    ├── di/
 │    │    └── providers.dart
 │    └── utils/
 │         ├── network_checker.dart
 │         └── app_constants.dart
 │
 ├── features/
 │    ├── auth/
 │    │    ├── data/
 │    │    │    ├── datasources/
 │    │    │    │    ├── auth_remote_source.dart
 │    │    │    │    └── auth_local_source.dart
 │    │    │    └── repositories/
 │    │    │         └── auth_repository_impl.dart
 │    │    ├── domain/
 │    │    │    └── repositories/
 │    │    │         └── auth_repository.dart
 │    │    └── presentation/
 │    │         └── login_screen.dart
 │
 │    ├── video_call/
 │    │    ├── data/
 │    │    │    └── repositories/video_call_repository_impl.dart
 │    │    ├── domain/
 │    │    │    └── repositories/video_call_repository.dart
 │    │    └── presentation/
 │    │         ├── video_call_screen.dart
 │    │         └── notifiers/video_call_notifier.dart
 │
 │    └── users/
 │         ├── data/
 │         │    ├── datasources/
 │         │    │    ├── user_remote_source.dart
 │         │    │    └── user_local_source.dart
 │         │    └── repositories/user_repository_impl.dart
 │         ├── domain/
 │         │    └── repositories/user_repository.dart
 │         └── presentation/user_list_screen.dart
 │
 └── main.dart
```

---

## 🧠 State Management
Using **Riverpod + StateNotifier** for reactive, testable state.

Example:
```dart
final authNotifierProvider =
    StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(ref.read(authRepositoryProvider));
});
```

---

## 🧩 SDK Setup — Agora

### 1️⃣ Create Agora Project
- Go to [Agora Console](https://console.agora.io/)
- Create a project → note down your **App ID**
- (Optional) Generate **temporary tokens** for testing

### 2️⃣ Add App ID to Code
In `VideoCallRepositoryImpl`:
```dart
await _engine.initialize(const RtcEngineContext(
  appId: AppConstants.AGORA_API_ID,
  channelProfile: ChannelProfileType.channelProfileCommunication,
));
```

### 3️⃣ Permissions
Add required permissions in both Android & iOS:

#### Android (`AndroidManifest.xml`)
```xml
<uses-permission android:name="android.permission.CAMERA" />
<uses-permission android:name="android.permission.RECORD_AUDIO" />
<uses-permission android:name="android.permission.INTERNET" />
```

#### iOS (`Info.plist`)
```xml
<key>NSCameraUsageDescription</key>
<string>Camera access required for video calls</string>
<key>NSMicrophoneUsageDescription</key>
<string>Microphone access required for video calls</string>
```

---

## 🧰 Build & Run Instructions

### Prerequisites
- Flutter (latest stable)
- Android Studio / Xcode
- Agora App ID
- Internet connection

### Run Commands
```bash
flutter clean
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
flutter run
```

---

## 🌐 API Reference
Using [ReqRes](https://reqres.in) for mock API calls:
- **Login:** `POST https://reqres.in/api/login`
- **Users List:** `GET https://reqres.in/api/users?page=2`

---

## 🧠 Assumptions & Limitations

| Area | Notes |
|------|-------|
| Authentication | Mock login only, not secure |
| Video Call | Agora test App ID; not for production |
| User List | Mock data from ReqRes |
| Offline Cache | Local caching via SharedPreferences (can be replaced with Hive) |
| Push Notifications | Currently mocked |
| Screen Share | Available only for supported devices |

---

## 🔒 Permissions Required
- Camera
- Microphone
- Internet
- Network State

Handled gracefully with permission requests and fallbacks.

---

## 🧪 Testing
Each feature layer is testable:
- Repositories are mock-friendly
- Use-case layer supports dependency injection

---

## 👨‍💻 Author
**Video Chat Demo App**  
Built with ❤️ using Flutter + Riverpod + Agora SDK
