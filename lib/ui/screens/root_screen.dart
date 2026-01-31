import 'package:flutter/material.dart';
import 'package:testable/ui/dashboard/global_overwatch_screen.dart';
import 'package:testable/ui/fleet/fleet_command_screen.dart';
import 'package:testable/ui/guardrails/system_guardrails_screen.dart';
import 'package:testable/ui/matrix/inference_matrix_screen.dart';
import 'package:testable/ui/trace/agent_trace_screen.dart';

class RootScreen extends StatefulWidget {
  const RootScreen({super.key});

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  final PageController _pageController = PageController();

  final List<Widget> _pages = const [
    GlobalOverwatchScreen(),
    AgentTraceScreen(),
    FleetCommandScreen(),
    InferenceMatrixScreen(),
    SystemGuardrailsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        scrollDirection: Axis.vertical,
        physics: const BouncingScrollPhysics(),
        children: _pages,
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
