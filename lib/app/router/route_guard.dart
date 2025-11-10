import 'package:auto_route/auto_route.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/auth/data/providers/auth_provider.dart';
import 'app_router.dart';

/// Route guard that checks if user is authenticated
class AuthGuard extends AutoRouteGuard {
  final Ref ref;

  AuthGuard(this.ref);

  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    final authState = ref.read(authProvider);

    if (authState.status == AuthStatus.authenticated) {
      // User is authenticated, allow navigation
      resolver.next();
    } else {
      // User is not authenticated, redirect to login
      router.replace(const LoginScreenRoute());
    }
  }
}

/// Route guard for public routes (redirects to home if already authenticated)
class PublicRouteGuard extends AutoRouteGuard {
  final Ref ref;

  PublicRouteGuard(this.ref);

  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    final authState = ref.read(authProvider);

    if (authState.status == AuthStatus.authenticated) {
      // User is already authenticated, redirect to home
      router.replace(const HomeScreenRoute());
    } else {
      // User is not authenticated, allow access to public route
      resolver.next();
    }
  }
}
