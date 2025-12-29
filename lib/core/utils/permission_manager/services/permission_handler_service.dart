// services/permission_handler_service.dart
part of '../permission_manager.dart';
abstract class IPermissionHandler {
  Future<PermissionStatus> request(Permission permission);
  Future<PermissionStatus> status(Permission permission);
  Future<Map<Permission, PermissionStatus>> requestMultiple(
    List<Permission> permissions,
  );
}

class PermissionHandlerImpl implements IPermissionHandler {
  @override
  Future<PermissionStatus> request(Permission permission) {
    return permission.request();
  }

  @override
  Future<PermissionStatus> status(Permission permission) {
    return permission.status;
  }

  @override
  Future<Map<Permission, PermissionStatus>> requestMultiple(
    List<Permission> permissions,
  ) {
    return permissions.request();
  }
}
