import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:testable/shared/widgets/alert_cards.dart';

/// Usage examples widget to demonstrate all cards
@RoutePage()
class AlertCardsDemoScreen extends StatelessWidget {
  const AlertCardsDemoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Alert Cards Gallery')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildSectionTitle('Basic Alert Cards'),
            const ErrorAlertCard(
              title: 'Operation Failed',
              message:
                  'The requested operation could not be completed. Please try again.',
            ),
            const SizedBox(height: 12),
            const SuccessAlertCard(
              title: 'Profile Updated',
              message: 'Your profile has been successfully updated.',
            ),
            const SizedBox(height: 12),
            const InfoAlertCard(
              title: 'New Feature Available',
              message: 'Check out the new dashboard with enhanced analytics.',
            ),
            const SizedBox(height: 12),
            const WarningAlertCard(
              title: 'Action Required',
              message:
                  'Your subscription will expire in 3 days. Please renew to continue.',
            ),

            const SizedBox(height: 24),

            _buildSectionTitle('Specialized Cards'),
            const LoadingAlertCard(
              title: 'Processing Payment',
              message: 'Please wait while we process your transaction...',
            ),
            const SizedBox(height: 12),
            const PremiumFeatureCard(
              featureName: 'Advanced Analytics',
              message:
                  'Get detailed insights and reports with our premium plan.',
            ),
            const SizedBox(height: 12),
            const EmptyStateCard(
              title: 'No Projects Yet',
              message:
                  'Create your first project to get started with our platform.',
              actionText: 'Create Project',
            ),

            const SizedBox(height: 24),

            _buildSectionTitle('Error Scenarios'),
            const LoginErrorCard(
              message:
                  'Invalid email or password. Please check your credentials.',
            ),
            const SizedBox(height: 12),
            const NetworkErrorCard(showBorder: true),
            const SizedBox(height: 12),
            const MaintenanceCard(
              scheduledTime: '2:00 AM - 4:00 AM',
              estimatedDuration: '2 hours',
            ),

            const SizedBox(height: 24),

            _buildSectionTitle('Informational Cards'),
            const ComingSoonCard(
              featureName: 'Team Collaboration',
              expectedDate: 'Q1 2024',
            ),
            const SizedBox(height: 12),
            const UpdateAvailableCard(
              version: '2.1.0',
              releaseNotes:
                  '• Dark mode improvements\n• Performance optimizations\n• Bug fixes',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16, top: 8),
      child: Row(
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const Spacer(),
          const Text(
            'Tap to dismiss',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
