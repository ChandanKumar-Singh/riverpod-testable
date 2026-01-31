enum EventSeverity { info, warning, error, critical }

class SystemEvent {
  final String id;
  final EventSeverity severity;
  final String message;
  final String source;
  final DateTime timestamp;

  const SystemEvent({
    required this.id,
    required this.severity,
    required this.message,
    required this.source,
    required this.timestamp,
  });
}
