import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:testable/app/router/app_router.dart';

import '../../data/providers/auth_provider.dart';

@RoutePage()
class SplashScreen extends ConsumerWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(authProvider, (prev, next) {
      if (next.status == AuthStatus.authenticated) {
        context.replaceRoute(const HomeScreenRoute());
      } else if (next.status == AuthStatus.unauthenticated) {
        context.replaceRoute(const LoginScreenRoute());
      }
    });

    return Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
