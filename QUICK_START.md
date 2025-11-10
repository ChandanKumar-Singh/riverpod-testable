# 🚀 Quick Start Guide

## Prerequisites

1. Flutter SDK (3.8.1+)
2. Dart SDK
3. Node.js (for server)
4. Android Studio / Xcode (for mobile development)

## Setup Steps

### 1. Install Dependencies

```bash
flutter pub get
cd server && npm install
```

### 2. Generate Model Files

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### 3. Create Environment File

Create `.env` file in the root directory:
```
BASE_URL=http://localhost:3000
```

### 4. Start the Server

```bash
cd server
npm run dev
```

### 5. Run the App

```bash
flutter run
```

### 6. Run Tests

```bash
flutter test
```

## Features

### ✅ Authentication
- Login with email/password
- OTP-based login
- Session management
- Secure token storage

### ✅ User Profile
- View profile
- Update profile
- Profile management

### ✅ Payments
- View payments
- Create payments
- Payment history

### ✅ Theme
- Light/Dark theme
- Theme persistence
- System theme detection

### ✅ Localization
- English
- Hindi
- Language switching

### ✅ Connectivity
- Online/Offline detection
- Connectivity banners
- Network status

## App Structure

- **Home Screen**: Main dashboard with feature cards
- **Profile Screen**: User profile management
- **Payment Screen**: Payment management
- **Settings Screen**: App settings
- **About Screen**: App information

## API Endpoints

The app uses the mock server at `http://localhost:3000`:

- `POST /login` - Login
- `POST /register` - Register
- `GET /users` - Get users
- `POST /users` - Create user
- `GET /posts` - Get posts
- `POST /posts` - Create post
- `POST /upload` - Upload file

## Testing

Run all tests:
```bash
flutter test
```

Run with coverage:
```bash
flutter test --coverage
```

## Building

### Android
```bash
flutter build apk
```

### iOS
```bash
flutter build ios
```

### Web
```bash
flutter build web
```

## Troubleshooting

### Issue: Model files not generated
**Solution**: Run `flutter pub run build_runner build --delete-conflicting-outputs`

### Issue: Server not connecting
**Solution**: Check if server is running on port 3000 and BASE_URL in .env is correct

### Issue: Tests failing
**Solution**: Run `flutter pub get` and ensure all dependencies are installed

## Support

For issues or questions, please refer to the main README.md or PROJECT_ANALYSIS.md files.


