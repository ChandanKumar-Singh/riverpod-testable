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
    );

    var theme = ThemeData(
      // Core properties
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      fontFamily: fontFamily,
      fontFamilyFallback: fontFamilyFallback,

      // Color overrides
      scaffoldBackgroundColor: isDark
          ? const Color.fromARGB(255, 11, 11, 11)
          : Colors.grey[50],
      canvasColor: isDark ? Colors.grey[850] : Colors.grey[100],
      cardColor: isDark ? Colors.grey[800] : Colors.white,
    );

    // Build text theme first
    final textTheme = _buildTextTheme(theme);
    theme = theme.copyWith(textTheme: textTheme);

    theme = theme.copyWith(
      // Component themes
      appBarTheme: _buildAppBarTheme(colorScheme, isDark, textTheme),
      cardTheme: _buildCardTheme(isDark),
      inputDecorationTheme: _buildInputDecorationTheme(
        colorScheme,
        isDark,
        textTheme,
      ),
      elevatedButtonTheme: _buildElevatedButtonTheme(colorScheme, textTheme),
      filledButtonTheme: _buildFilledButtonTheme(colorScheme, textTheme),
      outlinedButtonTheme: _buildOutlinedButtonTheme(colorScheme, textTheme),
      textButtonTheme: _buildTextButtonTheme(colorScheme, textTheme),
      iconButtonTheme: _buildIconButtonTheme(colorScheme),
      checkboxTheme: _buildCheckboxTheme(colorScheme),
      radioTheme: _buildRadioTheme(colorScheme),
      switchTheme: _buildSwitchTheme(colorScheme),
      sliderTheme: _buildSliderTheme(colorScheme),
      chipTheme: _buildChipTheme(colorScheme, isDark, textTheme),
      bottomNavigationBarTheme: _buildBottomNavigationBarTheme(
        colorScheme,
        isDark,
      ),
      navigationBarTheme: _buildNavigationBarTheme(colorScheme, textTheme),
      navigationRailTheme: _buildNavigationRailTheme(
        colorScheme,
        isDark,
        textTheme,
      ),
      tabBarTheme: _buildTabBarTheme(colorScheme, textTheme),
      dividerTheme: _buildDividerTheme(colorScheme, isDark),
      listTileTheme: _buildListTileTheme(colorScheme, textTheme),
      progressIndicatorTheme: _buildProgressIndicatorTheme(colorScheme),
      snackBarTheme: _buildSnackBarTheme(colorScheme, textTheme),
      dialogTheme: _buildDialogTheme(colorScheme, isDark, textTheme),
      bottomSheetTheme: _buildBottomSheetTheme(colorScheme, isDark),
      floatingActionButtonTheme: _buildFloatingActionButtonTheme(colorScheme),
      popupMenuTheme: _buildPopupMenuTheme(colorScheme, isDark, textTheme),
      tooltipTheme: _buildTooltipTheme(colorScheme, isDark, textTheme),
      dataTableTheme: _buildDataTableTheme(colorScheme, isDark, textTheme),
      expansionTileTheme: _buildExpansionTileTheme(colorScheme, textTheme),
    );
    return theme;
  }

  // Text Theme
  TextTheme _buildTextTheme(ThemeData theme) {
    final baseTextTheme = theme.textTheme;

    return TextTheme(
      // Display styles - Large headlines
      displayLarge: baseTextTheme.displayLarge?.copyWith(
        fontSize: 57,
        fontWeight: FontWeight.w400,
        letterSpacing: -0.25,
        height: 1.12,
      ),
      displayMedium: baseTextTheme.displayMedium?.copyWith(
        fontSize: 45,
        fontWeight: FontWeight.w400,
        letterSpacing: 0,
        height: 1.16,
      ),
      displaySmall: baseTextTheme.displaySmall?.copyWith(
        fontSize: 36,
        fontWeight: FontWeight.w400,
        letterSpacing: 0,
        height: 1.22,
      ),

      // Headline styles - Page titles
      headlineLarge: baseTextTheme.headlineLarge?.copyWith(
        fontSize: 32,
        fontWeight: FontWeight.w400,
        letterSpacing: 0,
        height: 1.25,
      ),
      headlineMedium: baseTextTheme.headlineMedium?.copyWith(
        fontSize: 28,
        fontWeight: FontWeight.w400,
        letterSpacing: 0,
        height: 1.29,
      ),
      headlineSmall: baseTextTheme.headlineSmall?.copyWith(
        fontSize: 24,
        fontWeight: FontWeight.w400,
        letterSpacing: 0,
        height: 1.33,
      ),

      // Title styles - Section headings
      titleLarge: baseTextTheme.titleLarge?.copyWith(
        fontSize: 22,
        fontWeight: FontWeight.w500,
        letterSpacing: 0,
        height: 1.27,
      ),
      titleMedium: baseTextTheme.titleMedium?.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.15,
        height: 1.5,
      ),
      titleSmall: baseTextTheme.titleSmall?.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.1,
        height: 1.43,
      ),

      // Body styles - Main content
      bodyLarge: baseTextTheme.bodyLarge?.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.5,
        height: 1.5,
      ),
      bodyMedium: baseTextTheme.bodyMedium?.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.25,
        height: 1.43,
      ),
      bodySmall: baseTextTheme.bodySmall?.copyWith(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.4,
        height: 1.33,
      ),

      // Label styles - UI controls
      labelLarge: baseTextTheme.labelLarge?.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.1,
        height: 1.43,
      ),
      labelMedium: baseTextTheme.labelMedium?.copyWith(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.5,
        height: 1.33,
      ),
      labelSmall: baseTextTheme.labelSmall?.copyWith(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.5,
        height: 1.45,
      ),
    );
  }

  // App Bar Theme
  AppBarTheme _buildAppBarTheme(
    ColorScheme colorScheme,
    bool isDark,
    TextTheme textTheme,
  ) {
    return AppBarTheme(
      backgroundColor: isDark ? Colors.grey[900] : Colors.white,
      foregroundColor: isDark ? Colors.white : Colors.black87,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      centerTitle: true,
      titleTextStyle: textTheme.titleLarge?.copyWith(
        fontWeight: FontWeight.w600,
        color: isDark ? Colors.white : Colors.black87,
      ),
      toolbarTextStyle: textTheme.bodyMedium?.copyWith(
        color: isDark ? Colors.white : Colors.black87,
      ),
      iconTheme: IconThemeData(color: isDark ? Colors.white : Colors.grey[700]),
    );
  }

  // Card Theme
  CardThemeData _buildCardTheme(bool isDark) {
    return CardThemeData(
      color: isDark ? Colors.grey[900] : Colors.white,
      elevation: 1,
      shadowColor: isDark ? Colors.black : Colors.grey[400],
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: EdgeInsets.zero,
    );
  }

  // Input Decoration Theme
  InputDecorationTheme _buildInputDecorationTheme(
    ColorScheme colorScheme,
    bool isDark,
    TextTheme textTheme,
  ) {
    return InputDecorationTheme(
      filled: true,
      fillColor: isDark ? Colors.grey[800] : Colors.grey[100],
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      prefixIconColor: colorScheme.onSurfaceVariant,
      suffixIconColor: colorScheme.onSurfaceVariant,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: colorScheme.primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: colorScheme.error, width: 1),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: colorScheme.error, width: 2),
      ),
      labelStyle: textTheme.bodyMedium?.copyWith(
        color: isDark ? Colors.grey[400] : Colors.grey[600],
      ),
      hintStyle: textTheme.bodyMedium?.copyWith(
        color: isDark ? Colors.grey[500] : Colors.grey[500],
      ),
      errorStyle: textTheme.bodySmall?.copyWith(color: colorScheme.error),
      helperStyle: textTheme.bodySmall?.copyWith(
        color: isDark ? Colors.grey[500] : Colors.grey[600],
      ),
    );
  }

  // Elevated Button Theme
  ElevatedButtonThemeData _buildElevatedButtonTheme(
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        textStyle: textTheme.labelLarge?.copyWith(
          fontWeight: FontWeight.w600,
          color: colorScheme.onPrimary,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  // Filled Button Theme
  FilledButtonThemeData _buildFilledButtonTheme(
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    return FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        textStyle: textTheme.labelLarge?.copyWith(
          fontWeight: FontWeight.w600,
          color: colorScheme.onPrimary,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  // Outlined Button Theme
  OutlinedButtonThemeData _buildOutlinedButtonTheme(
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    return OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: colorScheme.primary,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        textStyle: textTheme.labelLarge?.copyWith(
          fontWeight: FontWeight.w600,
          color: colorScheme.primary,
        ),
        side: BorderSide(color: colorScheme.primary),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  // Text Button Theme
  TextButtonThemeData _buildTextButtonTheme(
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    return TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: colorScheme.primary,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        textStyle: textTheme.labelLarge?.copyWith(
          fontWeight: FontWeight.w600,
          color: colorScheme.primary,
        ),
      ),
    );
  }

  // Icon Button Theme
  IconButtonThemeData _buildIconButtonTheme(ColorScheme colorScheme) {
    return IconButtonThemeData(
      style: IconButton.styleFrom(
        foregroundColor: colorScheme.primary,
        hoverColor: colorScheme.primary.withAlpha((255 * 0.08).toInt()),
        focusColor: colorScheme.primary.withAlpha((255 * 0.12).toInt()),
        highlightColor: colorScheme.primary.withAlpha((255 * 0.12).toInt()),
      ),
    );
  }

  // Checkbox Theme
  CheckboxThemeData _buildCheckboxTheme(ColorScheme colorScheme) {
    return CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return colorScheme.primary;
        }
        return null;
      }),
      checkColor: WidgetStateProperty.all(colorScheme.onPrimary),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
    );
  }

  // Radio Theme
  RadioThemeData _buildRadioTheme(ColorScheme colorScheme) {
    return RadioThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return colorScheme.primary;
        }
        return null;
      }),
    );
  }

  // Switch Theme
  SwitchThemeData _buildSwitchTheme(ColorScheme colorScheme) {
    return SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return colorScheme.primary;
        }
        return null;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return colorScheme.primary.withAlpha((255 * 0.5).toInt());
        }
        return null;
      }),
    );
  }

  // Slider Theme
  SliderThemeData _buildSliderTheme(ColorScheme colorScheme) {
    return SliderThemeData(
      activeTrackColor: colorScheme.primary,
      inactiveTrackColor: colorScheme.primary.withAlpha((255 * 0.3).toInt()),
      thumbColor: colorScheme.primary,
      overlayColor: colorScheme.primary.withAlpha((255 * 0.2).toInt()),
      valueIndicatorColor: colorScheme.primary,
      valueIndicatorTextStyle: TextStyle(color: colorScheme.onPrimary),
    );
  }

  // Chip Theme
  ChipThemeData _buildChipTheme(
    ColorScheme colorScheme,
    bool isDark,
    TextTheme textTheme,
  ) {
    return ChipThemeData(
      backgroundColor: isDark ? Colors.grey[800] : Colors.grey[200],
      selectedColor: colorScheme.primaryContainer,
      checkmarkColor: colorScheme.onPrimaryContainer,
      labelStyle: textTheme.labelLarge?.copyWith(
        color: isDark ? Colors.white : Colors.black87,
      ),
      secondaryLabelStyle: textTheme.labelLarge?.copyWith(
        color: colorScheme.onPrimaryContainer,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    );
  }

  // Bottom Navigation Bar Theme
  BottomNavigationBarThemeData _buildBottomNavigationBarTheme(
    ColorScheme colorScheme,
    bool isDark,
  ) {
    return BottomNavigationBarThemeData(
      backgroundColor: isDark ? Colors.grey[900] : Colors.white,
      selectedItemColor: colorScheme.primary,
      unselectedItemColor: isDark ? Colors.grey[500] : Colors.grey[600],
      elevation: 8,
      type: BottomNavigationBarType.fixed,
      selectedLabelStyle: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),
      unselectedLabelStyle: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w400,
      ),
    );
  }

  // Navigation Bar Theme (Material 3)
  NavigationBarThemeData _buildNavigationBarTheme(
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    return NavigationBarThemeData(
      backgroundColor: colorScheme.surface,
      indicatorColor: colorScheme.primaryContainer,
      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface,
          );
        }
        return textTheme.labelLarge?.copyWith(
          fontWeight: FontWeight.w500,
          color: colorScheme.onSurfaceVariant,
        );
      }),
    );
  }

  // Navigation Rail Theme
  NavigationRailThemeData _buildNavigationRailTheme(
    ColorScheme colorScheme,
    bool isDark,
    TextTheme textTheme,
  ) {
    return NavigationRailThemeData(
      backgroundColor: isDark ? Colors.grey[900] : Colors.white,
      selectedIconTheme: IconThemeData(color: colorScheme.primary),
      unselectedIconTheme: IconThemeData(
        color: isDark ? Colors.grey[500] : Colors.grey[600],
      ),
      selectedLabelTextStyle: textTheme.labelLarge?.copyWith(
        color: colorScheme.primary,
        fontWeight: FontWeight.w600,
      ),
      unselectedLabelTextStyle: textTheme.labelLarge?.copyWith(
        color: isDark ? Colors.grey[500] : Colors.grey[600],
        fontWeight: FontWeight.w500,
      ),
    );
  }

  // Tab Bar Theme
  TabBarThemeData _buildTabBarTheme(
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    return TabBarThemeData(
      indicator: UnderlineTabIndicator(
        borderSide: BorderSide(color: colorScheme.primary, width: 2),
      ),
      labelColor: colorScheme.primary,
      unselectedLabelColor: colorScheme.onSurface.withAlpha(
        (255 * 0.6).toInt(),
      ),
      labelStyle: textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w600),
      unselectedLabelStyle: textTheme.labelLarge?.copyWith(
        fontWeight: FontWeight.normal,
      ),
    );
  }

  // Divider Theme
  DividerThemeData _buildDividerTheme(ColorScheme colorScheme, bool isDark) {
    return DividerThemeData(
      color: colorScheme.outline.withAlpha(80),
      thickness: 1,
      space: 1,
    );
  }

  // List Tile Theme
  ListTileThemeData _buildListTileTheme(
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    return ListTileThemeData(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      titleTextStyle: textTheme.bodyLarge,
      subtitleTextStyle: textTheme.bodyMedium,
      leadingAndTrailingTextStyle: textTheme.bodyMedium,
    );
  }

  // Progress Indicator Theme
  ProgressIndicatorThemeData _buildProgressIndicatorTheme(
    ColorScheme colorScheme,
  ) {
    return ProgressIndicatorThemeData(
      color: colorScheme.primary,
      linearTrackColor: colorScheme.primary.withAlpha((255 * 0.3).toInt()),
      circularTrackColor: colorScheme.primary.withAlpha((255 * 0.3).toInt()),
    );
  }

  // Snack Bar Theme
  SnackBarThemeData _buildSnackBarTheme(
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    return SnackBarThemeData(
      backgroundColor: colorScheme.inverseSurface,
      contentTextStyle: textTheme.bodyMedium?.copyWith(
        color: colorScheme.onInverseSurface,
      ),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    );
  }

  // Dialog Theme
  DialogThemeData _buildDialogTheme(
    ColorScheme colorScheme,
    bool isDark,
    TextTheme textTheme,
  ) {
    return DialogThemeData(
      backgroundColor: isDark ? Colors.grey[800] : Colors.white,
      surfaceTintColor: Colors.transparent,
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      titleTextStyle: textTheme.titleLarge?.copyWith(
        color: isDark ? Colors.white : Colors.black87,
      ),
      contentTextStyle: textTheme.bodyMedium?.copyWith(
        color: isDark ? Colors.grey[300] : Colors.grey[700],
      ),
    );
  }

  // Bottom Sheet Theme
  BottomSheetThemeData _buildBottomSheetTheme(
    ColorScheme colorScheme,
    bool isDark,
  ) {
    return BottomSheetThemeData(
      backgroundColor: isDark ? Colors.grey[800] : Colors.white,
      surfaceTintColor: Colors.transparent,
      elevation: 8,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
    );
  }

  // Floating Action Button Theme
  FloatingActionButtonThemeData _buildFloatingActionButtonTheme(
    ColorScheme colorScheme,
  ) {
    return FloatingActionButtonThemeData(
      backgroundColor: colorScheme.primary,
      foregroundColor: colorScheme.onPrimary,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    );
  }

  // Popup Menu Theme
  PopupMenuThemeData _buildPopupMenuTheme(
    ColorScheme colorScheme,
    bool isDark,
    TextTheme textTheme,
  ) {
    return PopupMenuThemeData(
      color: isDark ? Colors.grey[800] : Colors.white,
      surfaceTintColor: Colors.transparent,
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      textStyle: textTheme.bodyMedium?.copyWith(
        color: isDark ? Colors.white : Colors.black87,
      ),
    );
  }

  // Tooltip Theme
  TooltipThemeData _buildTooltipTheme(
    ColorScheme colorScheme,
    bool isDark,
    TextTheme textTheme,
  ) {
    return TooltipThemeData(
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[700] : Colors.grey[800],
        borderRadius: BorderRadius.circular(6),
      ),
      textStyle: textTheme.labelSmall?.copyWith(color: Colors.white),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    );
  }

  // Data Table Theme
  DataTableThemeData _buildDataTableTheme(
    ColorScheme colorScheme,
    bool isDark,
    TextTheme textTheme,
  ) {
    return DataTableThemeData(
      dataRowColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return colorScheme.primaryContainer;
        }
        return Colors.transparent;
      }),
      headingRowColor: WidgetStateProperty.all(
        isDark ? Colors.grey[800] : Colors.grey[100],
      ),
      dividerThickness: 1,
      horizontalMargin: 16,
      columnSpacing: 16,
      dataTextStyle: textTheme.bodyMedium?.copyWith(
        color: isDark ? Colors.white : Colors.black87,
      ),
      headingTextStyle: textTheme.titleMedium?.copyWith(
        color: isDark ? Colors.white : Colors.black87,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  // Expansion Tile Theme
  ExpansionTileThemeData _buildExpansionTileTheme(
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    return ExpansionTileThemeData(
      childrenPadding: const EdgeInsets.symmetric(horizontal: 16),
      tilePadding: const EdgeInsets.symmetric(horizontal: 16),
      textColor: colorScheme.onSurface,
      iconColor: colorScheme.onSurface,
      collapsedTextColor: colorScheme.onSurface.withAlpha(150),
      collapsedIconColor: colorScheme.onSurface.withAlpha(150),
    );
  }
}
