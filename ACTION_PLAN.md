# 🎯 Action Plan - Critical Fixes & Improvements

## 🔴 CRITICAL FIXES (Fix Immediately)

### 1. Fix Storage Provider Initialization
**File**: `lib/core/di/providers.dart`
**Issue**: Storage provider throws UnimplementedError
**Fix**:
```dart
// In bootstrap() function in main.dart, ensure storage is initialized:
final storageProvider = Provider<LocalStorage>((ref) {
  return LocalStorageAdapter(); // Or your storage implementation
});
```

### 2. Fix Authentication Login Flow
**File**: `lib/features/auth/data/providers/auth_provider.dart`
**Issue**: Hardcoded OTP values, doesn't use email/password
**Fix**:
```dart
Future<void> login(String email, String password) async {
  state = state.copyWith(status: AuthStatus.loading);
  final res = await _repo.login(email, password); // Use actual parameters
  if (res.isSuccess && res.data != null) {
    await _repo.saveSession(res.data!, token: res.data!.token);
    state = AuthState(status: AuthStatus.authenticated, user: res.data);
  } else {
    state = AuthState(
      status: AuthStatus.unauthenticated,
      error: res.message ?? 'Login failed',
    );
  }
}
```

### 3. Fix Login Screen Button
**File**: `lib/features/auth/presentation/screens/login_screen.dart`
**Issue**: Shows toast instead of calling login
**Fix**:
```dart
onPressed: authState.status == AuthStatus.loading
    ? null
    : () {
        ref.read(authProvider.notifier).login(
          emailController.text,
          passwordController.text,
        );
      },
```

### 4. Fix Route History Duplicate Entry
**File**: `lib/app/router/app_router.dart`
**Issue**: Entry added twice (line 102 and 105)
**Fix**: Remove duplicate `addEntry` call on line 105

### 5. Fix Token Injection in API Service
**File**: `lib/core/services/api_service.dart`
**Issue**: Token not added to headers
**Fix**: Implement proper token injection using tokenGetter from httpClient

---

## 🟠 HIGH PRIORITY IMPROVEMENTS

### 6. Implement Route Guards
**File**: `lib/app/router/route_guard.dart`
**Action**: Implement authentication guard for protected routes

### 7. Implement Token Refresh
**File**: `lib/core/services/api_service.dart`
**Action**: Implement token refresh logic in `_tryRefreshToken()`

### 8. Add Error Reporting
**Action**: Integrate Sentry or Firebase Crashlytics

### 9. Complete User Feature
**Action**: Implement user profile, settings, and data management

### 10. Complete Payment Feature (if needed)
**Action**: Implement payment flow, history, and management

---

## 🟡 MEDIUM PRIORITY IMPROVEMENTS

### 11. Add Unit Tests
**Action**: Write tests for business logic, repositories, and providers

### 12. Add Widget Tests
**Action**: Test UI components and screens

### 13. Improve Error Handling
**Action**: Add user-friendly error messages and recovery strategies

### 14. Add Loading States
**Action**: Implement loading indicators for async operations

### 15. Add Empty States
**Action**: Create empty state widgets for lists and data

---

## 📋 Quick Reference: File Locations

### Critical Files to Fix
- `lib/core/di/providers.dart` - Storage provider
- `lib/features/auth/data/providers/auth_provider.dart` - Auth logic
- `lib/features/auth/presentation/screens/login_screen.dart` - Login UI
- `lib/app/router/app_router.dart` - Route history bug
- `lib/core/services/api_service.dart` - Token injection

### Files to Implement
- `lib/app/router/route_guard.dart` - Route guards
- `lib/features/user/` - User feature
- `lib/features/payment/` - Payment feature
- `test/` - Test files

### Files to Enhance
- `lib/shared/widgets/` - UI components
- `lib/core/errors/` - Error handling
- `lib/core/utils/` - Utility functions

---

## 🚀 Implementation Order

1. **Week 1**: Fix all critical bugs
2. **Week 2**: Implement route guards and token refresh
3. **Week 3**: Complete authentication flow
4. **Week 4**: Implement user feature
5. **Week 5**: Add testing
6. **Week 6**: Improve UI/UX
7. **Week 7**: Add monitoring and analytics

---

## 📝 Notes

- Test each fix thoroughly before moving to the next
- Update tests as you fix bugs
- Document changes in commit messages
- Review code with team before merging


