import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:testable/shared/theme/theme_switcher.dart';
import 'package:toastification/toastification.dart';
import '../../../../core/utils/toasts/toasts.dart';
import '../../data/providers/auth_provider.dart';

@RoutePage()
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Login'), actions: [ThemeSwitcher()]),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: authState.status == AuthStatus.loading
                  ? null
                  : () {
                    // throw Exception('sdfsdfdsfdsfsdf');
                      AppToastification.show(
                        type: ToastificationType.error,
                        style: ToastificationStyle.flat,
                        title: "Component updates available.",
                        // message: "Component updates available.",
                        actions: [
                          ToastAction(
                            label: 'View',
                            icon: Icons.open_in_new,
                            onPressed: () => print('sfdsfdsfsdfsdfsdfsdf'),
                          ),
                        ],
                      );

                      // ref
                      //     .read(authProvider.notifier)
                      //     .login(emailController.text, passwordController.text);
                    },
              child: authState.status == AuthStatus.loading
                  ? const CircularProgressIndicator()
                  : const Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
