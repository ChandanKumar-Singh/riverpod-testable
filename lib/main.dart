import 'package:flutter/material.dart';
import 'package:testable/core/theme/app_theme.dart';
import 'package:testable/ui/dashboard/noc_screen.dart';

void main() {
  runApp(const OneCoreApp());
}

class OneCoreApp extends StatelessWidget {
  const OneCoreApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'One Core System',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: const NOCScreen(),
    );
  }
}
