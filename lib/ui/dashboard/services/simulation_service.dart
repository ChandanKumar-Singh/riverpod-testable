import 'dart:async';
import 'dart:math';

import 'package:testable/ui/dashboard/models/dashboard_kpi.dart';
import 'package:testable/ui/dashboard/models/system_event.dart';
import 'package:testable/ui/dashboard/models/system_health.dart';

class SimulationService {
  final Random _rng = Random();
  Timer? _timer;

  final _healthController = StreamController<SystemHealth>.broadcast();
  final _kpiController = StreamController<DashboardKPI>.broadcast();
  final _eventsController = StreamController<List<SystemEvent>>.broadcast();

  final List<SystemEvent> _eventLog = [];

  SimulationService() {
    _startSimulation();
  }

  Stream<SystemHealth> get healthStream => _healthController.stream;
  Stream<DashboardKPI> get kpiStream => _kpiController.stream;
  Stream<List<SystemEvent>> get eventStream => _eventsController.stream;

  void _startSimulation() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _tick(timer.tick);
    });
  }

  void _tick(int tick) {
    // 1. Health Update (every 2s)
    if (tick % 2 == 0) {
      final networkRoll = _rng.nextDouble();
      NetworkStatus status = NetworkStatus.stable;
      if (networkRoll > 0.98)
        status = NetworkStatus.offline;
      else if (networkRoll > 0.90)
        status = NetworkStatus.degraded;

      _healthController.add(
        SystemHealth(
          cpuUsage: 0.3 + (_rng.nextDouble() * 0.4),
          memoryUsage: 0.4 + (_rng.nextDouble() * 0.3),
          networkStatus: status,
          uptimeDuration: Duration(hours: 48, minutes: tick),
        ),
      );
    }

    // 2. KPI Update (every 1s)
    _kpiController.add(
      DashboardKPI(
        activeAgents: 12 + _rng.nextInt(5),
        tokensPerSecond: 1200 + (_rng.nextDouble() * 500),
        successRate: 0.94 + (_rng.nextDouble() * 0.05),
        avgLatencyMs: 150 + _rng.nextInt(100),
        timestamp: DateTime.now(),
      ),
    );

    // 3. Event Update (every 3s)
    if (tick % 3 == 0) {
      final severityRoll = _rng.nextDouble();
      EventSeverity severity = EventSeverity.info;
      if (severityRoll > 0.95)
        severity = EventSeverity.critical;
      else if (severityRoll > 0.9)
        severity = EventSeverity.error;
      else if (severityRoll > 0.7)
        severity = EventSeverity.warning;

      final event = SystemEvent(
        id: "evt_${DateTime.now().millisecondsSinceEpoch}",
        severity: severity,
        message: _getRandomMessage(),
        source: "System",
        timestamp: DateTime.now(),
      );

      _eventLog.insert(0, event);
      if (_eventLog.length > 50) _eventLog.removeLast(); // Keep last 50
      _eventsController.add(List.from(_eventLog));
    }
  }

  String _getRandomMessage() {
    final messages = [
      "Agent deployment cycle completed",
      "Garbage collection triggered",
      "New node joined cluster (us-east-1a)",
      "Latency spike detected in region-2",
      "Model 'Phi-3' reloading weights",
      "Backup completed successfully",
      "Rate limit approaching for API-Key-2",
      "Security scan: No threats found",
      "Database connection pool expanding",
      "Cache hit ratio dropped below 80%",
    ];
    return messages[_rng.nextInt(messages.length)];
  }

  void dispose() {
    _timer?.cancel();
    _healthController.close();
    _kpiController.close();
    _eventsController.close();
  }
}
