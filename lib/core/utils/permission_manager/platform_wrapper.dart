// platform_wrapper.dart
part of 'permission_manager.dart'; 

abstract class PlatformWrapper {
  bool get isAndroid;
  bool get isIOS;
}

class PlatformWrapperImpl implements PlatformWrapper {
  @override
  bool get isAndroid => Platform.isAndroid;

  @override
  bool get isIOS => Platform.isIOS;
}
