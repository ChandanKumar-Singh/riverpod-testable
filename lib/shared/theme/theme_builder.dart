part of './app_theme.dart';

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

    return ThemeData(
      // Core properties
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      fontFamily: fontFamily,
      fontFamilyFallback: fontFamilyFallback,

      // Color overrides
      scaffoldBackgroundColor: isDark ? Colors.grey[900] : Colors.grey[50],
      canvasColor: isDark ? Colors.grey[850] : Colors.grey[100],
      cardColor: isDark ? Colors.grey[800] : Colors.white,
      // dialogBackgroundColor: isDark ? Colors.grey[800] : Colors.white,

      // Component themes
      appBarTheme: _buildAppBarTheme(colorScheme, isDark),
      cardTheme: _buildCardTheme(isDark),
      inputDecorationTheme: _buildInputDecorationTheme(colorScheme, isDark),
      elevatedButtonTheme: _buildElevatedButtonTheme(colorScheme),
      filledButtonTheme: _buildFilledButtonTheme(colorScheme),
      outlinedButtonTheme: _buildOutlinedButtonTheme(colorScheme),
      textButtonTheme: _buildTextButtonTheme(colorScheme),
      iconButtonTheme: _buildIconButtonTheme(colorScheme),
      checkboxTheme: _buildCheckboxTheme(colorScheme),
      radioTheme: _buildRadioTheme(colorScheme),
      switchTheme: _buildSwitchTheme(colorScheme),
      sliderTheme: _buildSliderTheme(colorScheme),
      chipTheme: _buildChipTheme(colorScheme, isDark),
      bottomNavigationBarTheme: _buildBottomNavigationBarTheme(
        colorScheme,
        isDark,
      ),
      navigationBarTheme: _buildNavigationBarTheme(colorScheme),
      navigationRailTheme: _buildNavigationRailTheme(colorScheme, isDark),
      tabBarTheme: _buildTabBarTheme(colorScheme),
      dividerTheme: _buildDividerTheme(isDark),
      listTileTheme: _buildListTileTheme(colorScheme),
      progressIndicatorTheme: _buildProgressIndicatorTheme(colorScheme),
      snackBarTheme: _buildSnackBarTheme(colorScheme),
      dialogTheme: _buildDialogTheme(colorScheme, isDark),
      bottomSheetTheme: _buildBottomSheetTheme(colorScheme, isDark),
      floatingActionButtonTheme: _buildFloatingActionButtonTheme(colorScheme),
      popupMenuTheme: _buildPopupMenuTheme(colorScheme, isDark),
      tooltipTheme: _buildTooltipTheme(colorScheme, isDark),
      dataTableTheme: _buildDataTableTheme(colorScheme, isDark),
      expansionTileTheme: _buildExpansionTileTheme(colorScheme),
    );
  }

  // App Bar Theme
  AppBarTheme _buildAppBarTheme(ColorScheme colorScheme, bool isDark) {
    return AppBarTheme(
      backgroundColor: isDark ? Colors.grey[900] : Colors.white,
      foregroundColor: isDark ? Colors.white : Colors.black87,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      centerTitle: true,
      titleTextStyle: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: isDark ? Colors.white : Colors.black87,
      ),
      iconTheme: IconThemeData(color: isDark ? Colors.white : Colors.grey[700]),
    );
  }

  // Card Theme
  CardThemeData _buildCardTheme(bool isDark) {
    return CardThemeData(
      color: isDark ? Colors.grey[800] : Colors.white,
      elevation: 2,
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
      labelStyle: TextStyle(
        color: isDark ? Colors.grey[400] : Colors.grey[600],
      ),
      hintStyle: TextStyle(color: isDark ? Colors.grey[500] : Colors.grey[500]),
      errorStyle: TextStyle(color: colorScheme.error),
    );
  }

  // Elevated Button Theme
  ElevatedButtonThemeData _buildElevatedButtonTheme(ColorScheme colorScheme) {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        textStyle: const TextStyle(fontWeight: FontWeight.w600),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  // Filled Button Theme
  FilledButtonThemeData _buildFilledButtonTheme(ColorScheme colorScheme) {
    return FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        textStyle: const TextStyle(fontWeight: FontWeight.w600),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  // Outlined Button Theme
  OutlinedButtonThemeData _buildOutlinedButtonTheme(ColorScheme colorScheme) {
    return OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: colorScheme.primary,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        textStyle: const TextStyle(fontWeight: FontWeight.w600),
        side: BorderSide(color: colorScheme.primary),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  // Text Button Theme
  TextButtonThemeData _buildTextButtonTheme(ColorScheme colorScheme) {
    return TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: colorScheme.primary,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        textStyle: const TextStyle(fontWeight: FontWeight.w600),
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
  ChipThemeData _buildChipTheme(ColorScheme colorScheme, bool isDark) {
    return ChipThemeData(
      backgroundColor: isDark ? Colors.grey[800] : Colors.grey[200],
      selectedColor: colorScheme.primaryContainer,
      checkmarkColor: colorScheme.onPrimaryContainer,
      labelStyle: TextStyle(color: isDark ? Colors.white : Colors.black87),
      secondaryLabelStyle: TextStyle(color: colorScheme.onPrimaryContainer),
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
    );
  }

  // Navigation Bar Theme (Material 3)
  NavigationBarThemeData _buildNavigationBarTheme(ColorScheme colorScheme) {
    return NavigationBarThemeData(
      backgroundColor: colorScheme.surface,
      indicatorColor: colorScheme.primaryContainer,
      labelTextStyle: WidgetStateProperty.all(
        TextStyle(fontWeight: FontWeight.w500),
      ),
    );
  }

  // Navigation Rail Theme
  NavigationRailThemeData _buildNavigationRailTheme(
    ColorScheme colorScheme,
    bool isDark,
  ) {
    return NavigationRailThemeData(
      backgroundColor: isDark ? Colors.grey[900] : Colors.white,
      selectedIconTheme: IconThemeData(color: colorScheme.primary),
      unselectedIconTheme: IconThemeData(
        color: isDark ? Colors.grey[500] : Colors.grey[600],
      ),
      selectedLabelTextStyle: TextStyle(color: colorScheme.primary),
      unselectedLabelTextStyle: TextStyle(
        color: isDark ? Colors.grey[500] : Colors.grey[600],
      ),
    );
  }

  // Tab Bar Theme
  TabBarThemeData _buildTabBarTheme(ColorScheme colorScheme) {
    return TabBarThemeData(
      indicator: UnderlineTabIndicator(
        borderSide: BorderSide(color: colorScheme.primary, width: 2),
      ),
      labelColor: colorScheme.primary,
      unselectedLabelColor: colorScheme.onSurface.withAlpha(
        (255 * 0.6).toInt(),
      ),
      labelStyle: const TextStyle(fontWeight: FontWeight.w600),
      unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal),
    );
  }

  // Divider Theme
  DividerThemeData _buildDividerTheme(bool isDark) {
    return DividerThemeData(
      color: isDark ? Colors.grey[700] : Colors.grey[300],
      thickness: 1,
      space: 1,
    );
  }

  // List Tile Theme
  ListTileThemeData _buildListTileTheme(ColorScheme colorScheme) {
    return ListTileThemeData(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
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
  SnackBarThemeData _buildSnackBarTheme(ColorScheme colorScheme) {
    return SnackBarThemeData(
      backgroundColor: colorScheme.inverseSurface,
      contentTextStyle: TextStyle(color: colorScheme.onInverseSurface),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    );
  }

  // Dialog Theme
  DialogThemeData _buildDialogTheme(ColorScheme colorScheme, bool isDark) {
    return DialogThemeData(
      backgroundColor: isDark ? Colors.grey[800] : Colors.white,
      surfaceTintColor: Colors.transparent,
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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
  ) {
    return PopupMenuThemeData(
      color: isDark ? Colors.grey[800] : Colors.white,
      surfaceTintColor: Colors.transparent,
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    );
  }

  // Tooltip Theme
  TooltipThemeData _buildTooltipTheme(ColorScheme colorScheme, bool isDark) {
    return TooltipThemeData(
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[700] : Colors.grey[800],
        borderRadius: BorderRadius.circular(6),
      ),
      textStyle: TextStyle(
        color: isDark ? Colors.white : Colors.white,
        fontSize: 12,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    );
  }

  // Data Table Theme
  DataTableThemeData _buildDataTableTheme(
    ColorScheme colorScheme,
    bool isDark,
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
    );
  }

  // Expansion Tile Theme
  ExpansionTileThemeData _buildExpansionTileTheme(ColorScheme colorScheme) {
    return const ExpansionTileThemeData(
      childrenPadding: EdgeInsets.symmetric(horizontal: 16),
      tilePadding: EdgeInsets.symmetric(horizontal: 16),
    );
  }
}
