// adapters/riverpod/permission_request_notifier.dart
part of '../../permission_manager.dart';

class PermissionRequestState {
  const PermissionRequestState({this.isLoading = false, this.result});

  final bool isLoading;
  final PermissionResult? result;
}

class PermissionRequestNotifier extends StateNotifier<PermissionRequestState> {
  PermissionRequestNotifier(this._ref) : super(const PermissionRequestState());

  final Ref _ref;

  Future<void> request(PermissionRequestConfig config) async {
    state = const PermissionRequestState(isLoading: true);

    final result = await _ref
        .read(permissionManagerProvider)
        .requestSingle(config: config);

    state = PermissionRequestState(isLoading: false, result: result);
  }
}

final permissionRequestProvider =
    StateNotifierProvider<PermissionRequestNotifier, PermissionRequestState>(
      (ref) => PermissionRequestNotifier(ref),
    );
