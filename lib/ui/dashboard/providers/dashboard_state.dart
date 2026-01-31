import 'package:flutter/foundation.dart';

@immutable
class DashboardState {
  final bool isFocusMode;
  final String? selectedKpiId; // For filtering main visualizer

  const DashboardState({this.isFocusMode = false, this.selectedKpiId});

  DashboardState copyWith({bool? isFocusMode, String? selectedKpiId}) {
    return DashboardState(
      isFocusMode: isFocusMode ?? this.isFocusMode,
      selectedKpiId: selectedKpiId ?? this.selectedKpiId,
    );
  }
}
