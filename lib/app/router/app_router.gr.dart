// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'app_router.dart';

/// generated route for
/// [AboutScreen]
class AboutScreenRoute extends PageRouteInfo<void> {
  const AboutScreenRoute({List<PageRouteInfo>? children})
    : super(AboutScreenRoute.name, initialChildren: children);

  static const String name = 'AboutScreenRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const AboutScreen();
    },
  );
}

/// generated route for
/// [HomeScreen]
class HomeScreenRoute extends PageRouteInfo<void> {
  const HomeScreenRoute({List<PageRouteInfo>? children})
    : super(HomeScreenRoute.name, initialChildren: children);

  static const String name = 'HomeScreenRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const HomeScreen();
    },
  );
}

/// generated route for
/// [MyHomePage]
class MyHomePageRoute extends PageRouteInfo<MyHomePageRouteArgs> {
  MyHomePageRoute({
    Key? key,
    required String pageTitle,
    List<PageRouteInfo>? children,
  }) : super(
         MyHomePageRoute.name,
         args: MyHomePageRouteArgs(key: key, pageTitle: pageTitle),
         initialChildren: children,
       );

  static const String name = 'MyHomePageRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<MyHomePageRouteArgs>();
      return MyHomePage(key: args.key, pageTitle: args.pageTitle);
    },
  );
}

class MyHomePageRouteArgs {
  const MyHomePageRouteArgs({this.key, required this.pageTitle});

  final Key? key;

  final String pageTitle;

  @override
  String toString() {
    return 'MyHomePageRouteArgs{key: $key, pageTitle: $pageTitle}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! MyHomePageRouteArgs) return false;
    return key == other.key && pageTitle == other.pageTitle;
  }

  @override
  int get hashCode => key.hashCode ^ pageTitle.hashCode;
}

/// generated route for
/// [ProfileScreen]
class ProfileScreenRoute extends PageRouteInfo<void> {
  const ProfileScreenRoute({List<PageRouteInfo>? children})
    : super(ProfileScreenRoute.name, initialChildren: children);

  static const String name = 'ProfileScreenRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const ProfileScreen();
    },
  );
}

/// generated route for
/// [SettingsScreen]
class SettingsScreenRoute extends PageRouteInfo<void> {
  const SettingsScreenRoute({List<PageRouteInfo>? children})
    : super(SettingsScreenRoute.name, initialChildren: children);

  static const String name = 'SettingsScreenRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const SettingsScreen();
    },
  );
}
