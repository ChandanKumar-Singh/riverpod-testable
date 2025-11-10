# Deployment Guide

This guide covers deployment strategies and best practices for the Testable Flutter App.

## Pre-Deployment Checklist

- [ ] All tests pass
- [ ] Code coverage meets requirements (>80%)
- [ ] Code analysis passes
- [ ] Environment variables configured
- [ ] API endpoints verified
- [ ] Security audit completed
- [ ] Performance testing completed
- [ ] Documentation updated
- [ ] Version number updated
- [ ] Changelog updated

## Android Deployment

### 1. Build Release APK

```bash
# Build APK
flutter build apk --release

# Build App Bundle (recommended for Play Store)
flutter build appbundle --release
```

### 2. Sign the APK

```bash
# Generate keystore (first time only)
keytool -genkey -v -keystore ~/upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload

# Configure signing in android/app/build.gradle
```

### 3. Upload to Play Store

1. Create app in Google Play Console
2. Upload App Bundle
3. Fill in store listing
4. Submit for review

## iOS Deployment

### 1. Build iOS App

```bash
# Build iOS app
flutter build ios --release
```

### 2. Archive in Xcode

1. Open `ios/Runner.xcworkspace` in Xcode
2. Select "Any iOS Device" as target
3. Product → Archive
4. Upload to App Store Connect

### 3. Submit to App Store

1. Create app in App Store Connect
2. Upload build
3. Fill in app information
4. Submit for review

## Web Deployment

### 1. Build Web App

```bash
# Build web app
flutter build web --release
```

### 2. Deploy to Hosting

**Firebase Hosting**:
```bash
firebase init hosting
firebase deploy --only hosting
```

**GitHub Pages**:
```bash
# Build and deploy to gh-pages branch
flutter build web --release
# Deploy to GitHub Pages
```

**Other Hosting**:
- Upload `build/web` directory to your hosting provider
- Configure server for SPA routing

## Environment Configuration

### Production Environment

```bash
# Android
flutter build apk --release \
  --dart-define=ENV=prod \
  --dart-define=BASE_URL=https://api.production.com

# iOS
flutter build ios --release \
  --dart-define=ENV=prod \
  --dart-define=BASE_URL=https://api.production.com

# Web
flutter build web --release \
  --dart-define=ENV=prod \
  --dart-define=BASE_URL=https://api.production.com
```

### Environment Variables

Create production `.env` file:

```env
BASE_URL=https://api.production.com
ENV=prod
ENABLE_LOGGING=false
```

## CI/CD Deployment

### GitHub Actions

Automated deployment via GitHub Actions:

```yaml
# .github/workflows/deploy.yml
name: Deploy

on:
  push:
    tags:
      - 'v*'

jobs:
  deploy-android:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: subosito/flutter-action@v2
      - run: flutter build appbundle --release
      - uses: r0adkll/upload-google-play@v1
        with:
          serviceAccountJsonPlainText: ${{ secrets.GOOGLE_PLAY_SERVICE_ACCOUNT }}
          packageName: com.example.app
          releaseFiles: build/app/outputs/bundle/release/app-release.aab
```

## Server Deployment

### Docker Deployment

```bash
# Build Docker image
docker build -t testable-server ./server

# Run container
docker run -d -p 3000:3000 testable-server
```

### Docker Compose

```bash
# Deploy with docker-compose
docker-compose up -d
```

### Cloud Deployment

**Heroku**:
```bash
heroku create testable-server
git push heroku main
```

**AWS ECS**:
- Create ECS cluster
- Deploy Docker container
- Configure load balancer

**Google Cloud Run**:
```bash
gcloud run deploy testable-server --source ./server
```

## Monitoring

### Error Tracking

**Sentry**:
```dart
// Configure Sentry in main.dart
import 'package:sentry_flutter/sentry_flutter.dart';

void main() async {
  await SentryFlutter.init(
    (options) {
      options.dsn = 'YOUR_SENTRY_DSN';
    },
    appRunner: () => runApp(MyApp()),
  );
}
```

**Firebase Crashlytics**:
```dart
// Configure Crashlytics
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
```

### Analytics

**Firebase Analytics**:
```dart
// Configure Analytics
import 'package:firebase_analytics/firebase_analytics.dart';

final analytics = FirebaseAnalytics.instance;
```

### Performance Monitoring

**Firebase Performance**:
```dart
// Configure Performance Monitoring
import 'package:firebase_performance/firebase_performance.dart';

final performance = FirebasePerformance.instance;
```

## Security

### API Security

- Use HTTPS for all API calls
- Implement token refresh
- Validate SSL certificates
- Use secure storage for tokens

### App Security

- Enable code obfuscation
- Use ProGuard/R8 for Android
- Enable app signing
- Implement certificate pinning

### Code Obfuscation

```bash
# Build with obfuscation
flutter build apk --release --obfuscate --split-debug-info=./debug-info
```

## Rollback Strategy

### Version Control

- Tag releases in Git
- Keep release branches
- Document known issues

### App Store Rollback

- Keep previous version available
- Monitor crash reports
- Have rollback plan ready

## Post-Deployment

### Monitoring

- Monitor error rates
- Track performance metrics
- Watch user feedback
- Monitor server logs

### Updates

- Plan regular updates
- Test updates thoroughly
- Communicate changes to users
- Maintain changelog

## Additional Resources

- [Flutter Deployment](https://flutter.dev/docs/deployment)
- [Google Play Console](https://play.google.com/console)
- [App Store Connect](https://appstoreconnect.apple.com)
- [Firebase Hosting](https://firebase.google.com/docs/hosting)

---

**Happy Deploying! 🚀**

