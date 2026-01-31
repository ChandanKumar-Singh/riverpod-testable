import 'package:flutter/material.dart';
import 'package:testable/layers/l0_physical/l0_screen.dart';
import 'package:testable/layers/l1_compute/l1_screen.dart';
import 'package:testable/layers/l2_fabrics/l2_screen.dart';
import 'package:testable/layers/l3_control/l3_screen.dart';
import 'package:testable/layers/l4_models/l4_screen.dart';
import 'package:testable/layers/l5_agents/l5_screen.dart';
import 'package:testable/layers/l6_products/l6_screen.dart';
import 'package:testable/layers/l7_humans/l7_screen.dart';

class RootScreen extends StatefulWidget {
  const RootScreen({super.key});

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  final PageController _pageController = PageController();

  final List<Widget> _pages = const [
    L0PhysicalScreen(),
    L1ComputeScreen(),
    L2FabricsScreen(),
    L3ControlScreen(),
    L4ModelsScreen(),
    L5AgentsScreen(),
    L6ProductsScreen(),
    L7HumansScreen(),
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
