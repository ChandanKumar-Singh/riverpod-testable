import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:testable/ui/trace/models/agent_run.dart';
import 'package:testable/ui/trace/services/trace_simulation_service.dart';

// Service Provider
final traceSimulationServiceProvider = Provider(
  (ref) => TraceSimulationService(),
);

// Data Provider (Run Access)
final selectedAgentRunProvider = FutureProvider.family<AgentRun, String>((
  ref,
  runId,
) async {
  final service = ref.watch(traceSimulationServiceProvider);
  return service.loadRun(runId);
});

// Selection State
final selectedTraceNodeProvider = StateProvider<String?>((ref) => null);

// Playback State
class PlaybackState {
  final bool isPlaying;
  final Duration currentTimestamp;
  final double speed;
  final Duration totalDuration;

  const PlaybackState({
    required this.isPlaying,
    required this.currentTimestamp,
    required this.speed,
    required this.totalDuration,
  });

  PlaybackState copyWith({
    bool? isPlaying,
    Duration? currentTimestamp,
    double? speed,
    Duration? totalDuration,
  }) {
    return PlaybackState(
      isPlaying: isPlaying ?? this.isPlaying,
      currentTimestamp: currentTimestamp ?? this.currentTimestamp,
      speed: speed ?? this.speed,
      totalDuration: totalDuration ?? this.totalDuration,
    );
  }
}

class PlaybackNotifier extends StateNotifier<PlaybackState> {
  Timer? _timer;

  PlaybackNotifier()
    : super(
        const PlaybackState(
          isPlaying: false,
          currentTimestamp: Duration.zero,
          speed: 1.0,
          totalDuration: Duration(minutes: 10), // Placeholder until loaded
        ),
      );

  void setDuration(Duration d) {
    state = state.copyWith(totalDuration: d);
  }

  void play() {
    if (state.isPlaying) return;
    state = state.copyWith(isPlaying: true);
    _startTimer();
  }

  void pause() {
    _timer?.cancel();
    state = state.copyWith(isPlaying: false);
  }

  void seek(Duration pos) {
    state = state.copyWith(currentTimestamp: pos);
    if (state.currentTimestamp >= state.totalDuration) {
      pause();
    }
  }

  void setSpeed(double speed) {
    state = state.copyWith(speed: speed);
    if (state.isPlaying) {
      _timer?.cancel();
      _startTimer();
    }
  }

  void _startTimer() {
    const tick = Duration(milliseconds: 50);
    _timer = Timer.periodic(tick, (t) {
      final newTime = state.currentTimestamp + (tick * state.speed);
      if (newTime >= state.totalDuration) {
        state = state.copyWith(
          currentTimestamp: state.totalDuration,
          isPlaying: false,
        );
        t.cancel();
      } else {
        state = state.copyWith(currentTimestamp: newTime);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

final tracePlaybackProvider =
    StateNotifierProvider<PlaybackNotifier, PlaybackState>((ref) {
      return PlaybackNotifier();
    });
