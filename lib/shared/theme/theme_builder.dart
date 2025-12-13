part of 'app_theme.dart';

class AppThemeBuilder {
  AppThemeBuilder({
    this.seedColor = Colors.indigo,
    this.brightness = Brightness.light,
    this.fontFamily,
    this.fontFamilyFallback,
  });

  final Color seedColor;
  final Brightness brightness;
  final String? fontFamily;
  final List<String>? fontFamilyFallback;

  ThemeData build() {
    final isDark = brightness == Brightness.dark;
    final colorScheme = ColorScheme.fromSeed(
      seedColor: seedColor,
      brightness: brightness,
      primary: _enhancePrimary(seedColor),
    );

    var theme = ThemeData(
      // Core enhanced properties
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      fontFamily: fontFamily,
      fontFamilyFallback: fontFamilyFallback,
      splashFactory: InkRipple.splashFactory,
      highlightColor: colorScheme.primary.withAlpha(20),
      splashColor: colorScheme.primary.withAlpha(30),

      // Enhanced surface colors with glassmorphism effect
      scaffoldBackgroundColor: _buildScaffoldBackground(isDark, colorScheme),
      canvasColor: isDark ? Colors.grey[900]! : Colors.grey[50]!,
      cardColor: _buildCardColor(isDark, colorScheme),
    );

    // Enhanced text theme with better hierarchy
    final textTheme = _buildPremiumTextTheme(theme);
    theme = theme.copyWith(textTheme: textTheme);

    // Apply all enhanced component themes
    theme = theme.copyWith(
      // Navigation & App Bar
      appBarTheme: _buildPremiumAppBarTheme(colorScheme, isDark, textTheme),

      // Surfaces & Cards
      cardTheme: _buildGlassCardTheme(isDark, colorScheme),
      elevatedButtonTheme: _buildPremiumElevatedButtonTheme(
        colorScheme,
        textTheme,
      ),
      filledButtonTheme: _buildPremiumFilledButtonTheme(colorScheme, textTheme),
      outlinedButtonTheme: _buildPremiumOutlinedButtonTheme(
        colorScheme,
        textTheme,
      ),
      textButtonTheme: _buildPremiumTextButtonTheme(colorScheme, textTheme),

      // Input & Forms
      inputDecorationTheme: _buildPremiumInputTheme(
        colorScheme,
        isDark,
        textTheme,
      ),

      // Interactive Components
      iconButtonTheme: _buildPremiumIconButtonTheme(colorScheme),
      floatingActionButtonTheme: _buildPremiumFABTheme(colorScheme),

      // Selection Controls
      checkboxTheme: _buildPremiumCheckboxTheme(colorScheme),
      radioTheme: _buildPremiumRadioTheme(colorScheme),
      switchTheme: _buildPremiumSwitchTheme(colorScheme),

      // Navigation
      bottomNavigationBarTheme: _buildPremiumBottomNavTheme(
        colorScheme,
        isDark,
        textTheme,
      ),
      navigationBarTheme: _buildPremiumNavigationBarTheme(
        colorScheme,
        textTheme,
      ),
      navigationRailTheme: _buildPremiumNavigationRailTheme(
        colorScheme,
        isDark,
        textTheme,
      ),

      // Content & Layout
      tabBarTheme: _buildPremiumTabBarTheme(colorScheme, textTheme),
      listTileTheme: _buildPremiumListTileTheme(colorScheme, textTheme),
      expansionTileTheme: _buildPremiumExpansionTileTheme(
        colorScheme,
        textTheme,
      ),

      // Indicators & Progress
      progressIndicatorTheme: _buildPremiumProgressTheme(colorScheme),
      dividerTheme: _buildPremiumDividerTheme(colorScheme, isDark),

      // Dialogs & Sheets
      dialogTheme: _buildPremiumDialogTheme(colorScheme, isDark, textTheme),
      bottomSheetTheme: _buildPremiumBottomSheetTheme(colorScheme, isDark),

      // Menus & Overlays
      popupMenuTheme: _buildPremiumPopupMenuTheme(
        colorScheme,
        isDark,
        textTheme,
      ),
      tooltipTheme: _buildPremiumTooltipTheme(colorScheme, isDark, textTheme),

      // Data & Tables
      dataTableTheme: _buildPremiumDataTableTheme(
        colorScheme,
        isDark,
        textTheme,
      ),

      // Notifications
      snackBarTheme: _buildPremiumSnackBarTheme(colorScheme, textTheme),

      // Sliders & Chips
      sliderTheme: _buildPremiumSliderTheme(colorScheme),
      chipTheme: _buildPremiumChipTheme(colorScheme, isDark, textTheme),
    );

    return theme;
  }

  // Enhanced color utilities
  Color _enhancePrimary(Color seed) => Color.lerp(seed, Colors.white, 0.1)!;
  Color _buildScaffoldBackground(bool isDark, ColorScheme scheme) => isDark
      ? Color.lerp(Colors.black, scheme.background, 0.1)!
      : scheme.surface;
  Color _buildCardColor(bool isDark, ColorScheme scheme) => isDark
      ? Color.lerp(scheme.surface, Colors.grey[900], 0.3)!
      : scheme.surface;
  // Premium Text Theme - Complete enhanced typography system
  TextTheme _buildPremiumTextTheme(ThemeData theme) {
    final base = theme.textTheme;
    final isDark = theme.brightness == Brightness.dark;

    return TextTheme(
      // Display styles - Hero content & banners
      displayLarge: base.displayLarge?.copyWith(
        fontSize: 57,
        fontWeight: FontWeight.w300,
        letterSpacing: -0.5,
        height: 1.15,
        shadows: isDark
            ? null
            : [
                const Shadow(
                  blurRadius: 12,
                  color: Colors.black26,
                  offset: Offset(0, 2),
                ),
              ],
      ),
      displayMedium: base.displayMedium?.copyWith(
        fontSize: 45,
        fontWeight: FontWeight.w300,
        letterSpacing: -0.25,
        height: 1.2,
        shadows: isDark
            ? null
            : [
                const Shadow(
                  blurRadius: 8,
                  color: Colors.black26,
                  offset: Offset(0, 1),
                ),
              ],
      ),
      displaySmall: base.displaySmall?.copyWith(
        fontSize: 36,
        fontWeight: FontWeight.w400,
        letterSpacing: 0,
        height: 1.22,
      ),

      // Headline styles - Page titles & sections
      headlineLarge: base.headlineLarge?.copyWith(
        fontSize: 32,
        fontWeight: FontWeight.w400,
        letterSpacing: -0.1,
        height: 1.25,
      ),
      headlineMedium: base.headlineMedium?.copyWith(
        fontSize: 28,
        fontWeight: FontWeight.w400,
        letterSpacing: 0,
        height: 1.29,
      ),
      headlineSmall: base.headlineSmall?.copyWith(
        fontSize: 24,
        fontWeight: FontWeight.w500,
        letterSpacing: 0,
        height: 1.33,
      ),

      // Title styles - Cards, dialogs, section headers
      titleLarge: base.titleLarge?.copyWith(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.1,
        height: 1.3,
      ),
      titleMedium: base.titleMedium?.copyWith(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.15,
        height: 1.4,
      ),
      titleSmall: base.titleSmall?.copyWith(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.1,
        height: 1.45,
      ),

      // Body styles - Main content paragraphs
      bodyLarge: base.bodyLarge?.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.2,
        height: 1.5,
      ),
      bodyMedium: base.bodyMedium?.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.25,
        height: 1.43,
      ),
      bodySmall: base.bodySmall?.copyWith(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.4,
        height: 1.33,
      ),

      // Label styles - Buttons, tabs, chips
      labelLarge: base.labelLarge?.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.5,
        height: 1.45,
      ),
      labelMedium: base.labelMedium?.copyWith(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
        height: 1.33,
      ),
      labelSmall: base.labelSmall?.copyWith(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
        height: 1.45,
      ),
    );
  }

  // Premium App Bar with glassmorphism
  AppBarTheme _buildPremiumAppBarTheme(
    ColorScheme scheme,
    bool isDark,
    TextTheme textTheme,
  ) {
    return AppBarTheme(
      backgroundColor: isDark
          ? Colors.grey[900]!.withOpacity(0.95)
          : Colors.white.withOpacity(0.95),
      foregroundColor: scheme.onSurface,
      elevation: 0,
      shadowColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      centerTitle: true,
      scrolledUnderElevation: 0,
      titleTextStyle: textTheme.titleLarge?.copyWith(
        fontWeight: FontWeight.w700,
        color: scheme.onSurface,
        shadows: isDark
            ? null
            : [const Shadow(blurRadius: 2, color: Colors.black12)],
      ),
      iconTheme: IconThemeData(color: scheme.onSurfaceVariant, size: 24),
    );
  }

  // Glassmorphism Card Theme
  CardThemeData _buildGlassCardTheme(bool isDark, ColorScheme scheme) {
    return CardThemeData(
      color: isDark
          ? Colors.grey[900]!.withOpacity(0.85)
          : Colors.white.withOpacity(0.9),
      elevation: 4,
      shadowColor: isDark ? Colors.black54 : Colors.black26,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: scheme.primary.withOpacity(0.1)),
      ),
      margin: const EdgeInsets.all(0),
    );
  }

  // Premium Elevated Button with gradient-like effect
  ElevatedButtonThemeData _buildPremiumElevatedButtonTheme(
    ColorScheme scheme,
    TextTheme textTheme,
  ) {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: scheme.primary,
        foregroundColor: scheme.onPrimary,
        elevation: 2,
        shadowColor: scheme.primary.withOpacity(0.3),
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        textStyle: textTheme.labelLarge?.copyWith(
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
        ),
        visualDensity: VisualDensity.compact,
      ),
    );
  }

  // Premium Input with floating label animation
  InputDecorationTheme _buildPremiumInputTheme(
    ColorScheme scheme,
    bool isDark,
    TextTheme textTheme,
  ) {
    return InputDecorationTheme(
      filled: true,
      fillColor: isDark ? Colors.grey[900]!.withOpacity(0.6) : Colors.grey[50]!,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: scheme.outline.withOpacity(0.5)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: scheme.outline.withOpacity(0.3)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: scheme.primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: scheme.error, width: 1.5),
      ),
      labelStyle: textTheme.bodyLarge?.copyWith(
        fontWeight: FontWeight.w500,
        color: scheme.primary,
      ),
      hintStyle: textTheme.bodyMedium?.copyWith(color: scheme.onSurfaceVariant),
    );
  }

  // Premium FAB with extended elevation
  FloatingActionButtonThemeData _buildPremiumFABTheme(ColorScheme scheme) {
    return FloatingActionButtonThemeData(
      backgroundColor: scheme.primary,
      foregroundColor: scheme.onPrimary,
      elevation: 8,
      highlightElevation: 12,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      sizeConstraints: const BoxConstraints(minWidth: 56, minHeight: 56),
    );
  }

  // Premium Bottom Navigation with modern indicators
  BottomNavigationBarThemeData _buildPremiumBottomNavTheme(
    ColorScheme scheme,
    bool isDark,
    TextTheme textTheme,
  ) {
    return BottomNavigationBarThemeData(
      backgroundColor: isDark
          ? Colors.grey[900]!.withOpacity(0.95)
          : Colors.white,
      selectedItemColor: scheme.primary,
      unselectedItemColor: scheme.onSurfaceVariant,
      // indicatorColor: scheme.primary.withOpacity(0.2),
      elevation: 12,
      type: BottomNavigationBarType.fixed,
      landscapeLayout: BottomNavigationBarLandscapeLayout.centered,
      selectedLabelStyle: textTheme.labelMedium?.copyWith(
        fontWeight: FontWeight.w600,
        fontSize: 11,
      ),
      unselectedLabelStyle: textTheme.labelSmall?.copyWith(
        fontWeight: FontWeight.w500,
        fontSize: 10,
      ),
    );
  }

  // Premium Switch with smooth animations
  SwitchThemeData _buildPremiumSwitchTheme(ColorScheme scheme) {
    return SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return scheme.primary;
        }
        if (states.contains(WidgetState.disabled)) {
          return scheme.onSurface.withOpacity(0.3);
        }
        return scheme.onSurfaceVariant;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return scheme.primary.withOpacity(0.5);
        }
        if (states.contains(WidgetState.disabled)) {
          return scheme.onSurface.withOpacity(0.12);
        }
        return scheme.onSurface.withOpacity(0.2);
      }),
      trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
      // thumbShape: const RoundedRectangleBorder(
      //   borderRadius: BorderRadius.circular(8),
      // ),
      // trackHeight: 20,
    );
  }

  // Premium Dialog with backdrop blur effect simulation
  DialogThemeData _buildPremiumDialogTheme(
    ColorScheme scheme,
    bool isDark,
    TextTheme textTheme,
  ) {
    return DialogThemeData(
      backgroundColor: isDark
          ? Colors.grey[900]!.withOpacity(0.95)
          : Colors.white,
      surfaceTintColor: Colors.transparent,
      elevation: 24,
      shadowColor: Colors.black54,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      alignment: Alignment.center,
      titleTextStyle: textTheme.headlineSmall?.copyWith(
        fontWeight: FontWeight.w700,
        color: scheme.onSurface,
      ),
      contentTextStyle: textTheme.bodyLarge?.copyWith(
        color: scheme.onSurfaceVariant,
      ),
    );
  }

  // Premium Chip with subtle gradients
  ChipThemeData _buildPremiumChipTheme(
    ColorScheme scheme,
    bool isDark,
    TextTheme textTheme,
  ) {
    return ChipThemeData(
      backgroundColor: scheme.surfaceVariant.withOpacity(0.6),
      surfaceTintColor: Colors.transparent,
      selectedColor: scheme.primaryContainer,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      labelStyle: textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w600),
      elevation: 2,
      shadowColor: Colors.black26,
    );
  }

  // Enhanced Icon Button with ripple effects
  IconButtonThemeData _buildPremiumIconButtonTheme(ColorScheme scheme) {
    return IconButtonThemeData(
      style: IconButton.styleFrom(
        foregroundColor: scheme.onSurfaceVariant,
        backgroundColor: scheme.surfaceVariant.withOpacity(0.1),
        hoverColor: scheme.primary.withOpacity(0.08),
        focusColor: scheme.primary.withOpacity(0.12),
        highlightColor: scheme.primary.withOpacity(0.16),
        padding: const EdgeInsets.all(8),
        iconSize: 24,
      ),
    );
  }

  // Add all other theme builders with similar premium enhancements...
  CheckboxThemeData _buildPremiumCheckboxTheme(ColorScheme scheme) {
    return CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return scheme.primary;
        return null;
      }),
      checkColor: WidgetStateProperty.all(scheme.onPrimary),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      side: BorderSide(color: scheme.outline.withOpacity(0.5)),
    );
  }

  RadioThemeData _buildPremiumRadioTheme(ColorScheme scheme) {
    return RadioThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return scheme.primary;
        return null;
      }),
      splashRadius: 24,
    );
  }

  NavigationBarThemeData _buildPremiumNavigationBarTheme(
    ColorScheme scheme,
    TextTheme textTheme,
  ) {
    return NavigationBarThemeData(
      backgroundColor: scheme.surface,
      indicatorColor: scheme.primary.withOpacity(0.2),
      surfaceTintColor: Colors.transparent,
      elevation: 8,
      height: 80,
      labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
    );
  }

  // Continue with remaining premium themes following the same pattern...
  SliderThemeData _buildPremiumSliderTheme(ColorScheme scheme) {
    return SliderThemeData(
      trackHeight: 4,
      activeTrackColor: scheme.primary,
      inactiveTrackColor: scheme.primary.withOpacity(0.3),
      thumbColor: scheme.primary,
      overlayColor: scheme.primary.withOpacity(0.2),
      thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 12),
      valueIndicatorShape: const PaddleSliderValueIndicatorShape(),
      valueIndicatorColor: scheme.primaryContainer,
    );
  }

  DividerThemeData _buildPremiumDividerTheme(ColorScheme scheme, bool isDark) {
    return DividerThemeData(
      color: scheme.outline.withOpacity(0.3),
      thickness: 1.5,
      space: 16,
      indent: 16,
    );
  }

  ListTileThemeData _buildPremiumListTileTheme(
    ColorScheme scheme,
    TextTheme textTheme,
  ) {
    return ListTileThemeData(
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      tileColor: scheme.surfaceVariant.withOpacity(0.1),
      iconColor: scheme.primary,
      textColor: scheme.onSurface,
    );
  }

  ProgressIndicatorThemeData _buildPremiumProgressTheme(ColorScheme scheme) {
    return ProgressIndicatorThemeData(
      color: scheme.primary,
      linearTrackColor: scheme.primary.withOpacity(0.3),
      circularTrackColor: scheme.primary.withOpacity(0.2),
    );
  }

  SnackBarThemeData _buildPremiumSnackBarTheme(
    ColorScheme scheme,
    TextTheme textTheme,
  ) {
    return SnackBarThemeData(
      backgroundColor: scheme.inverseSurface,
      contentTextStyle: textTheme.bodyMedium?.copyWith(
        color: scheme.onInverseSurface,
        fontWeight: FontWeight.w600,
      ),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 8,
    );
  }

  BottomSheetThemeData _buildPremiumBottomSheetTheme(
    ColorScheme scheme,
    bool isDark,
  ) {
    return BottomSheetThemeData(
      backgroundColor: isDark
          ? Colors.grey[900]!.withOpacity(0.95)
          : Colors.white,
      surfaceTintColor: Colors.transparent,
      elevation: 16,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      clipBehavior: Clip.antiAlias,
    );
  }

  PopupMenuThemeData _buildPremiumPopupMenuTheme(
    ColorScheme scheme,
    bool isDark,
    TextTheme textTheme,
  ) {
    return PopupMenuThemeData(
      color: isDark ? Colors.grey[900]! : Colors.white,
      surfaceTintColor: Colors.transparent,
      elevation: 12,
      shadowColor: Colors.black45,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      textStyle: textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500),
    );
  }

  TooltipThemeData _buildPremiumTooltipTheme(
    ColorScheme scheme,
    bool isDark,
    TextTheme textTheme,
  ) {
    return TooltipThemeData(
      decoration: BoxDecoration(
        color: scheme.errorContainer,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          const BoxShadow(
            color: Colors.black54,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      textStyle: textTheme.labelMedium?.copyWith(
        color: scheme.onErrorContainer,
        fontWeight: FontWeight.w600,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      margin: const EdgeInsets.all(8),
      height: 32,
      preferBelow: true,
    );
  }

  DataTableThemeData _buildPremiumDataTableTheme(
    ColorScheme scheme,
    bool isDark,
    TextTheme textTheme,
  ) {
    return DataTableThemeData(
      dataRowColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.hovered)) {
          return scheme.primary.withOpacity(0.04);
        }
        if (states.contains(WidgetState.selected)) {
          return scheme.primaryContainer;
        }
        return Colors.transparent;
      }),
      headingRowColor: WidgetStateProperty.all(
        scheme.surfaceVariant.withOpacity(0.3),
      ),
      headingTextStyle: textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.w700,
      ),
      dataTextStyle: textTheme.bodyMedium,
      dividerThickness: 1.5,
    );
  }

  ExpansionTileThemeData _buildPremiumExpansionTileTheme(
    ColorScheme scheme,
    TextTheme textTheme,
  ) {
    return ExpansionTileThemeData(
      backgroundColor: scheme.surfaceVariant.withOpacity(0.2),
      collapsedBackgroundColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      childrenPadding: const EdgeInsets.all(12),
      expandedAlignment: Alignment.centerLeft,
      tilePadding: const EdgeInsets.symmetric(horizontal: 12),
      iconColor: scheme.primary,
      collapsedIconColor: scheme.primary.withOpacity(0.7),
    );
  }

  NavigationRailThemeData _buildPremiumNavigationRailTheme(
    ColorScheme scheme,
    bool isDark,
    TextTheme textTheme,
  ) {
    return NavigationRailThemeData(
      backgroundColor: isDark ? Colors.grey[900]! : Colors.white,
      indicatorColor: scheme.primary.withOpacity(0.2),
      selectedIconTheme: IconThemeData(color: scheme.primary, size: 24),
      unselectedIconTheme: IconThemeData(color: scheme.onSurfaceVariant),
      selectedLabelTextStyle: textTheme.labelLarge?.copyWith(
        fontWeight: FontWeight.w700,
        color: scheme.primary,
      ),
      unselectedLabelTextStyle: textTheme.labelMedium?.copyWith(
        color: scheme.onSurfaceVariant,
      ),
    );
  }

  TabBarThemeData _buildPremiumTabBarTheme(
    ColorScheme scheme,
    TextTheme textTheme,
  ) {
    return TabBarThemeData(
      indicator: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: scheme.primary.withOpacity(0.2),
      ),
      labelColor: scheme.primary,
      unselectedLabelColor: scheme.onSurfaceVariant,
      indicatorSize: TabBarIndicatorSize.tab,
      labelStyle: textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w700),
      dividerColor: scheme.outline.withOpacity(0.3),
    );
  }

  // Filled Button Theme - Premium style with subtle shadow and rounded corners
  FilledButtonThemeData _buildPremiumFilledButtonTheme(
    ColorScheme scheme,
    TextTheme textTheme,
  ) {
    final bool isDark = scheme.brightness == Brightness.dark;
    return FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: scheme.primary,
        foregroundColor: scheme.onPrimary,
        shadowColor: scheme.primary.withOpacity(0.3),
        elevation: 4,
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
        textStyle: textTheme.bodyLarge?.copyWith(
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
          color: isDark ? scheme.onSurface : null,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        visualDensity: VisualDensity.compact,
      ),
    );
  }

  // Outlined Button Theme - Premium style with dynamic border and smooth color transitions
  OutlinedButtonThemeData _buildPremiumOutlinedButtonTheme(
    ColorScheme scheme,
    TextTheme textTheme,
  ) {
    return OutlinedButtonThemeData(
      style:
          OutlinedButton.styleFrom(
            foregroundColor: scheme.primary,
            side: BorderSide(color: scheme.primary, width: 2),
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
            textStyle: textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            visualDensity: VisualDensity.compact,
          ).copyWith(
            overlayColor: WidgetStateProperty.resolveWith<Color?>((
              Set<WidgetState> states,
            ) {
              if (states.contains(WidgetState.hovered) ||
                  states.contains(WidgetState.focused) ||
                  states.contains(WidgetState.pressed)) {
                return scheme.primary.withOpacity(0.1);
              }
              return null;
            }),
          ),
    );
  }

  // Text Button Theme - Premium style with bold text emphasis and subtle feedback colors
  TextButtonThemeData _buildPremiumTextButtonTheme(
    ColorScheme scheme,
    TextTheme textTheme,
  ) {
    return TextButtonThemeData(
      style:
          TextButton.styleFrom(
            foregroundColor: scheme.primary,
            padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
            textStyle: textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
            ),
            visualDensity: VisualDensity.compact,
          ).copyWith(
            overlayColor: WidgetStateProperty.resolveWith<Color?>((
              Set<WidgetState> states,
            ) {
              if (states.contains(WidgetState.hovered) ||
                  states.contains(WidgetState.focused) ||
                  states.contains(WidgetState.pressed)) {
                return scheme.primary.withOpacity(0.12);
              }
              return null;
            }),
          ),
    );
  }
}
