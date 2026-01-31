import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:testable/core/theme/app_colors.dart';
import 'package:testable/ui/dashboard/providers/dashboard_providers.dart';
import 'package:testable/ui/dashboard/widgets/dashboard_grid.dart';
import 'package:testable/ui/dashboard/widgets/dashboard_header.dart';

class GlobalOverwatchScreen extends ConsumerWidget {
  const GlobalOverwatchScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isFocusMode = ref.watch(
      dashboardStateProvider.select((s) => s.isFocusMode),
    );

    return Scaffold(
      backgroundColor: isFocusMode
          ? context.appColors.bgPrimary
          : context.appColors.bgSecondary,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [
              const DashboardHeader(),
              Expanded(
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 300),
                  opacity: 1.0,
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return const DashboardGrid();
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
