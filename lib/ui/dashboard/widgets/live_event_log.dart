import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:intl/intl.dart';
import 'package:testable/core/theme/app_colors.dart';
import 'package:testable/ui/dashboard/models/system_event.dart';
import 'package:testable/ui/dashboard/providers/dashboard_providers.dart';

class LiveEventLog extends ConsumerWidget {
  const LiveEventLog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eventsAsync = ref.watch(eventLogStreamProvider);

    return Container(
      decoration: BoxDecoration(
        color: context.appColors.bgSecondary.withOpacity(0.5),
        border: Border.all(color: context.appColors.bgTertiary, width: 1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(
              "LIVE EVENT LOG",
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: context.appColors.textTertiary,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.0,
              ),
            ),
          ),
          const Divider(height: 1),

          // List
          Expanded(
            child: eventsAsync.when(
              data: (events) {
                if (events.isEmpty) {
                  return Center(
                    child: Text(
                      "No events captured",
                      style: TextStyle(color: context.appColors.textTertiary),
                    ),
                  );
                }
                return ListView.separated(
                  padding: const EdgeInsets.all(8),
                  itemCount: events.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final event = events[index];
                    return _EventItem(event: event);
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(
                child: Text(
                  "Error loading logs",
                  style: TextStyle(color: context.appColors.accentCritical),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EventItem extends StatelessWidget {
  final SystemEvent event;

  const _EventItem({required this.event});

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('HH:mm:ss');

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Timestamp
        Text(
          dateFormat.format(event.timestamp),
          style: TextStyle(
            color: context.appColors.textTertiary,
            fontFamily: 'RobotoMono', // Monospace for alignment
            fontSize: 12,
          ),
        ),
        const SizedBox(width: 12),

        // Indicator
        Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Icon(
            Icons.circle,
            size: 6,
            color: _getSeverityColor(context, event.severity),
          ),
        ),
        const SizedBox(width: 12),

        // Message
        Expanded(
          child: Text(
            event.message,
            style: TextStyle(
              color: context.appColors.textSecondary,
              fontSize: 13,
            ),
          ),
        ),
      ],
    );
  }

  Color _getSeverityColor(BuildContext context, EventSeverity severity) {
    switch (severity) {
      case EventSeverity.info:
        return context.appColors.accentSecondary;
      case EventSeverity.warning:
        return context.appColors.accentWarning;
      case EventSeverity.error:
        return context.appColors.accentCritical;
      case EventSeverity.critical:
        return const Color(0xFFFF0000); // Bright red
    }
  }
}
