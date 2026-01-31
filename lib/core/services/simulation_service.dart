import 'dart:async';
import 'dart:math';

import 'package:testable/ui/dashboard/models/dashboard_kpi.dart';
import 'package:testable/ui/dashboard/models/system_event.dart';
import 'package:testable/ui/dashboard/models/system_health.dart';

class SimulationService {
  final _random = Random();

  // Stream Controllers
  final _kpiController = StreamController<DashboardKPI>.broadcast();
  final _eventController = StreamController<List<SystemEvent>>.broadcast();
  final _healthController = StreamController<SystemHealth>.broadcast();

  // Internal state for simulation continuity
  final List<SystemEvent> _eventLog = [];
  Timer? _timer;
  final DateTime _startTime = DateTime.now();

  SimulationService() {
    _startSimulation();
  }

  Stream<DashboardKPI> get kpiStream => _kpiController.stream;
  Stream<List<SystemEvent>> get eventStream => _eventController.stream;
  Stream<SystemHealth> get healthStream => _healthController.stream;

  void _startSimulation() {
    _timer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      _emitKPI();
      _emitHealth();

      // Emit events less frequently
      if (_random.nextDouble() > 0.8) {
        _emitNewEvent();
      }
    });
  }

  void _emitKPI() {
    // Simulate slight fluctuations around a baseline
    final kpi = DashboardKPI(
      activeAgents: 3 + _random.nextInt(3), // 3-5 agents
      tokensPerSecond: 150.0 + _random.nextDouble() * 50.0, // 150-200 tps
      successRate: 0.95 + (_random.nextDouble() * 0.04), // 95-99%
      avgLatencyMs: 40 + _random.nextInt(20), // 40-60ms
      timestamp: DateTime.now(),
    );
    _kpiController.add(kpi);
  }

  void _emitHealth() {
    // Sine wave simulation for smooth "breathing" effect
    final elapsed = DateTime.now().difference(_startTime).inMilliseconds;
    final sineValue = sin(elapsed / 2000); // 2 second period

    // Map sine (-1 to 1) to realistic usage (e.g., 0.3 to 0.7)
    final cpu = 0.5 + (sineValue * 0.2) + (_random.nextDouble() * 0.05);
    final mem = 0.4 + (sineValue * 0.1) + (_random.nextDouble() * 0.02);

    final health = SystemHealth(
      cpuUsage: cpu.clamp(0.0, 1.0),
      memoryUsage: mem.clamp(0.0, 1.0),
      networkStatus: NetworkStatus.stable,
      uptimeDuration: DateTime.now().difference(_startTime),
    );
    _healthController.add(health);
  }

  void _emitNewEvent() {
    // Weighted randomness: mainly info, rarely critical
    EventSeverity finalSeverity = EventSeverity.info;
    double r = _random.nextDouble();
    if (r > 0.95)
      finalSeverity = EventSeverity.critical;
    else if (r > 0.85)
      finalSeverity = EventSeverity.error;
    else if (r > 0.7)
      finalSeverity = EventSeverity.warning;

    final sources = [
      'Agent-Alpha',
      'Swarm-Controller',
      'Memory-Bank',
      'Network-Gate',
    ];
    final messages = [
      'Token limit approached',
      'Context window optimized',
      'Latency spike detected',
      'New knowledge ingested',
      'Handshaking with peer',
      'Garbage collection triggered',
    ];

    final event = SystemEvent(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      severity: finalSeverity,
      message: messages[_random.nextInt(messages.length)],
      source: sources[_random.nextInt(sources.length)],
      timestamp: DateTime.now(),
    );

    _eventLog.insert(0, event);
    if (_eventLog.length > 50) _eventLog.removeLast();

    _eventController.add(List.from(_eventLog));
  }

  void dispose() {
    _timer?.cancel();
    _kpiController.close();
    _eventController.close();
    _healthController.close();
  }
}
