// FEATURE: BreadCrumbs

part of '../../app/router/app_router.dart';

/// ------------------------------------------------------
/// AppBreadcrumb Widget
/// ------------------------------------------------------
/// Displays an animated breadcrumb trail based on [routeHistoryProvider].
/// Tapping on any crumb navigates back to that route.
class AppBreadcrumb extends ConsumerWidget {

  const AppBreadcrumb({
    super.key,
    this.showIcons = true,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    this.textStyle,
  });
  final bool showIcons;
  final EdgeInsetsGeometry padding;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final routes = ref.watch(routeHistoryProvider);

    if (routes.isEmpty) return const SizedBox.shrink();

    final distinctRoutes = _distinctByName(routes);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
      padding: padding,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(distinctRoutes.length, (index) {
            final route = distinctRoutes[index];
            final isLast = index == distinctRoutes.length - 1;

            return Row(
              children: [
                GestureDetector(
                  onTap: !isLast
                      ? () => _navigateTo(context, distinctRoutes, route)
                      : null,
                  child: AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 250),
                    style:
                        textStyle ??
                        TextStyle(
                          color: isLast
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(
                                  context,
                                ).colorScheme.onSurface.withOpacity(0.7),
                          fontWeight: isLast
                              ? FontWeight.w600
                              : FontWeight.w500,
                        ),
                    child: Row(
                      children: [
                        if (showIcons && index == 0)
                          const Icon(Icons.home_rounded, size: 16),
                        if (showIcons && index > 0)
                          const Icon(Icons.chevron_right_rounded, size: 16),
                        const SizedBox(width: 4),
                        Text(_cleanRouteName(route.name)),
                      ],
                    ),
                  ),
                ),
                if (!isLast) const SizedBox(width: 8),
              ],
            );
          }),
        ),
      ),
    );
  }

  // Navigates (pops) back to the tapped route
  void _navigateTo(
    BuildContext context,
    List<RouteLogEntry> list,
    RouteLogEntry route,
  ) {
    final router = context.router;

    // Pop until matching route is found
    while (router.canPop() && router.topRoute.name != route.name) {
      router.pop();
    }
  }

  // Remove duplicates & keep order
  List<RouteLogEntry> _distinctByName(List<RouteLogEntry> list) {
    final seen = <String>{};
    final result = <RouteLogEntry>[];
    for (final r in list) {
      if (!seen.contains(r.name)) {
        seen.add(r.name);
        result.add(r);
      }
    }
    return result;
  }

  // Cleanup route name for UI display
  String _cleanRouteName(String name) {
    return name.replaceAll('ScreenRoute', '').replaceAll('PageRoute', '');
  }
}
