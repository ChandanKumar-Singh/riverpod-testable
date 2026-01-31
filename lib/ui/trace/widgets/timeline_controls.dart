import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:testable/core/theme/app_colors.dart';
import 'package:testable/ui/trace/providers/trace_providers.dart';

class TimelineControls extends ConsumerWidget {
  const TimelineControls({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playback = ref.watch(tracePlaybackProvider);
    final notifier = ref.read(tracePlaybackProvider.notifier);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.appColors.bgSecondary,
        border: Border(top: BorderSide(color: context.appColors.bgTertiary)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Slider
          Row(
            children: [
              Text(
                _formatDuration(playback.currentTimestamp),
                style: TextStyle(
                  color: context.appColors.accentSecondary,
                  fontFamily: 'RobotoMono',
                  fontSize: 12,
                ),
              ),
              Expanded(
                child: SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    activeTrackColor: context.appColors.accentSecondary,
                    inactiveTrackColor: context.appColors.bgTertiary,
                    thumbColor: context.appColors.accentSecondary,
                    thumbShape: const RoundSliderThumbShape(
                      enabledThumbRadius: 6,
                    ),
                    trackHeight: 2,
                  ),
                  child: Slider(
                    value: playback.currentTimestamp.inMilliseconds.toDouble(),
                    min: 0,
                    max: playback.totalDuration.inMilliseconds.toDouble(),
                    onChanged: (val) {
                      notifier.seek(Duration(milliseconds: val.toInt()));
                    },
                  ),
                ),
              ),
              Text(
                _formatDuration(playback.totalDuration),
                style: TextStyle(
                  color: context.appColors.textTertiary,
                  fontFamily: 'RobotoMono',
                  fontSize: 12,
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          // Controls
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.speed, size: 20),
                color: playback.speed == 0.5
                    ? context.appColors.accentPrimary
                    : context.appColors.textTertiary,
                onPressed: () => notifier.setSpeed(0.5),
                tooltip: "0.5x",
              ),
              const SizedBox(width: 24),
              IconButton(
                icon: Icon(
                  playback.isPlaying
                      ? Icons.pause_circle_filled
                      : Icons.play_circle_filled,
                ),
                iconSize: 48,
                color: context.appColors.accentPrimary,
                onPressed: () {
                  if (playback.isPlaying) {
                    notifier.pause();
                  } else {
                    notifier.play();
                  }
                },
              ),
              const SizedBox(width: 24),
              IconButton(
                icon: const Icon(Icons.speed, size: 20),
                color: playback.speed == 2.0
                    ? context.appColors.accentPrimary
                    : context.appColors.textTertiary,
                onPressed: () => notifier.setSpeed(2.0),
                tooltip: "2x",
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatDuration(Duration d) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    return "${twoDigits(d.inMinutes)}:${twoDigits(d.inSeconds.remainder(60))}.${(d.inMilliseconds % 1000) ~/ 100}";
  }
}
