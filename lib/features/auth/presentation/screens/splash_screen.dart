import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:testable/app/router/app_router.dart';

import '../../data/providers/auth_provider.dart';

@RoutePage()
class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(authProvider, (prev, next) {
      if (next.status == AuthStatus.authenticated) {
        context.replaceRoute(const HomeScreenRoute());
      } else if (next.status == AuthStatus.unauthenticated) {
        context.replaceRoute(const LoginScreenRoute());
      }
    });

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            Text('Loading...', style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }
}
