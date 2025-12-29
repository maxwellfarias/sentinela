import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sentinela/ui/core/extensions/custom_color_theme_extension.dart';
import 'package:sentinela/ui/core/themes/custom_text_style.dart';
import 'package:sentinela/ui/core/themes/flowbite_colors.dart';
import 'colors.dart';

abstract final class AppTheme {
  static _border([Color color = AppColors.grey300]) => OutlineInputBorder(
    borderSide: BorderSide(color: color, width: 1),
    borderRadius: BorderRadius.circular(6),
  );

  static final _customTextTheme = CustomTextTheme();

  static final _textTheme = TextTheme(
    headlineSmall: TextStyle(
      fontFamily: 'Inter',
      fontWeight: FontWeight.w600,
      fontSize: 26,
      height: 1,
    ),
    titleLarge: TextStyle(
      fontFamily: 'Inter',
      fontWeight: FontWeight.bold,
      fontSize: 20,
      height: 1,
    ),
    titleMedium: TextStyle(
      fontFamily: 'Inter',
      fontWeight: FontWeight.w600,
      fontSize: 16,
      height: 1,
    ),
    titleSmall: TextStyle(
      fontFamily: 'Inter',
      fontWeight: FontWeight.w500,
      fontSize: 14,
      height: 1,
    ),
    bodyLarge: TextStyle(
      fontFamily: 'Inter',
      fontWeight: FontWeight.w400,
      fontSize: 16,
      height: 1,
    ),
    bodyMedium: TextStyle(
      fontFamily: 'Inter',
      fontWeight: FontWeight.w400,
      fontSize: 14,
      height: 1,
    ),
    bodySmall: TextStyle(
      fontFamily: 'Inter',
      fontWeight: FontWeight.w400,
      fontSize: 12,
      height: 1,
    ),
    labelSmall: TextStyle(
      fontFamily: 'Inter',
      fontWeight: FontWeight.w500,
      fontSize: 11,
      height: 1,
    ),
  );

  //MARK: ThemeData Light
  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Inter',
    brightness: Brightness.light,
    colorScheme: ColorScheme.fromSeed(seedColor: AppColors.brand500).copyWith(
      primary: AppColors.brand600,
      onPrimary: Colors.white,
      primaryContainer: AppColors.primaryLight,
      surface: AppColors.lightgrey,
      onSurface: AppColors.grey900,
      secondaryContainer: Colors.white,
      onTertiaryContainer: Colors.white,
      tertiaryContainer: AppColors.primary,
      surfaceContainer: Colors.white,
      surfaceContainerHigh: Colors.white,
      surfaceContainerHighest: AppColors.lightActive,
      outline: AppColors.grey300,
      error: AppColors.danger,
    ),
    textTheme: _textTheme,

    chipTheme: ChipThemeData(
      checkmarkColor: AppColors.primaryActive,
      selectedColor: AppColors.primaryLight,
      side: WidgetStateBorderSide.resolveWith((state) {
        if (state.contains(WidgetState.selected)) {
          return BorderSide(
            color: AppColors.primary.withValues(alpha: 0.2),
            width: 2,
          );
        } else if (state.contains(WidgetState.disabled)) {
          return BorderSide(color: AppColors.grey300, width: 1);
        }
        return BorderSide(color: AppColors.grey300, width: 1);
      }),
    ),

    inputDecorationTheme: InputDecorationTheme(
      contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      fillColor: AppColors.lightActive,
      filled: true,
      border: _border(),
      focusedBorder: _border(AppColors.primary),
      enabledBorder: _border(AppColors.grey300),
      errorBorder: _border(AppColors.danger),
      errorStyle: _textTheme.bodySmall,
      hintStyle: _customTextTheme.textBase.copyWith(color: AppColors.grey500),
    ),
    cardTheme: CardThemeData(
      color: Colors.white,
      shadowColor: Colors.grey.withValues(alpha: 0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: AppColors.grey200, width: 1),
      ),
      elevation: 3,
    ),

    expansionTileTheme: ExpansionTileThemeData(
      iconColor: AppColors.primary,
      textColor: AppColors.primary,
      shape: RoundedRectangleBorder(),
      collapsedTextColor: AppColors.grey800,
      collapsedIconColor: AppColors.grey800,
      tilePadding: EdgeInsets.zero,
      expandedAlignment: Alignment.centerLeft,
    ),

    filledButtonTheme: FilledButtonThemeData(
      style: ButtonStyle(
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        ),
      ),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      ),
    ),

    dividerTheme: DividerThemeData(
      space: 0,
      indent: 0,
      endIndent: 0,
      color: AppColors.grey200,
    ),

    dataTableTheme: DataTableThemeData(
      dataRowColor: WidgetStateProperty.resolveWith<Color>((
        Set<WidgetState> states,
      ) {
        return AppColors.white; // Cor padrão
      }),
    ),

    extensions: [CustomColorTheme()],
  );

  //MARK: ThemeData Dark
  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    fontFamily: 'Inter',
    colorScheme:
        ColorScheme.fromSeed(
          seedColor: CupertinoColors.systemBlue.darkColor,
          brightness: Brightness.dark,
        ).copyWith(
          primary: CupertinoColors.systemBlue.darkColor,
          surface: AppColors.coal500,
          onSurface: AppColors.grey50,
          secondaryContainer: AppColors.grey950Dark,
          surfaceContainer: AppColors.grey900Dark,
          surfaceContainerHigh: AppColors.lightActiveDark,
          outline: AppColors.grey800Dark,
          surfaceContainerHighest: AppColors.lightActiveDark,
        ),
    textTheme: _textTheme.merge(
      ThemeData(brightness: Brightness.dark).textTheme,
    ),

    chipTheme: ChipThemeData(
      checkmarkColor: AppColors.primaryActiveDark,
      selectedColor: AppColors.primaryLightDark,
      side: WidgetStateBorderSide.resolveWith((state) {
        if (state.contains(WidgetState.selected)) {
          return BorderSide(
            color: AppColors.primaryDark.withValues(alpha: 0.2),
            width: 2,
          );
        } else if (state.contains(WidgetState.disabled)) {
          return BorderSide(color: AppColors.grey300Dark, width: 1);
        }
        return BorderSide(color: AppColors.grey300Dark, width: 1);
      }),
    ),

    inputDecorationTheme: InputDecorationTheme(
      contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      border: _border(),
      focusedBorder: _border(AppColors.primaryDark),
      enabledBorder: _border(AppColors.grey300Dark),
      errorBorder: _border(AppColors.dangerDark),
      errorStyle: TextStyle(color: AppColors.dangerDark),
      hintStyle: _customTextTheme.textBase.copyWith(color: AppColors.grey400),
    ),

    cardTheme: CardThemeData(
      color: AppColors.grey800Dark,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: AppColors.grey800Dark, width: 1),
      ),
    ),

    filledButtonTheme: FilledButtonThemeData(
      style: ButtonStyle(
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        ),
      ),
    ),

    dividerTheme: DividerThemeData(
      space: 0,
      indent: 0,
      endIndent: 0,
      color: AppColors.grey800Dark,
    ),

    dataTableTheme: DataTableThemeData(
      dataRowColor: WidgetStateProperty.resolveWith<Color>((
        Set<WidgetState> states,
      ) {
        // if (states.contains(WidgetState.hovered) || states.contains(WidgetState.focused) || states.contains(WidgetState.selected)) {
        //   return AppColors.grey500;
        // }h

        return AppColors.grey950Dark; // Cor padrão
      }),
    ),

    extensions: [
     CustomColorTheme(
        // Foreground Colors - Dark Mode
        fgBody: FlowbiteColors.fgBodyDark,
        fgBodySubtle: FlowbiteColors.fgBodySubtleDark,
        fgHeading: FlowbiteColors.fgHeadingDark,
        fgBrandSubtle: FlowbiteColors.fgBrandSubtleDark,
        fgBrand: FlowbiteColors.fgBrandDark,
        fgBrandStrong: FlowbiteColors.fgBrandStrongDark,
        fgSuccess: FlowbiteColors.fgSuccessDark,
        fgSuccessStrong: FlowbiteColors.fgSuccessStrongDark,
        fgDanger: FlowbiteColors.fgDangerDark,
        fgDangerStrong: FlowbiteColors.fgDangerStrongDark,
        fgWarningSubtle: FlowbiteColors.fgWarningSubtleDark,
        fgWarning: FlowbiteColors.fgWarningDark,
        fgYellow: FlowbiteColors.fgYellowDark,
        fgDisabled: FlowbiteColors.fgDisabledDark,
        fgPurple: FlowbiteColors.fgPurpleDark,
        fgCyan: FlowbiteColors.fgCyanDark,
        fgIndigo: FlowbiteColors.fgIndigoDark,
        fgPink: FlowbiteColors.fgPinkDark,
        fgLime: FlowbiteColors.fgLimeDark,

        // Neutral Background Colors - Dark Mode
        bgNeutralPrimarySoft: FlowbiteColors.bgNeutralPrimarySoftDark,
        bgNeutralPrimary: FlowbiteColors.bgNeutralPrimaryDark,
        bgNeutralPrimaryMedium: FlowbiteColors.bgNeutralPrimaryMediumDark,
        bgNeutralPrimaryStrong: FlowbiteColors.bgNeutralPrimaryStrongDark,
        bgNeutralSecondarySoft: FlowbiteColors.bgNeutralSecondarySoftDark,
        bgNeutralSecondary: FlowbiteColors.bgNeutralSecondaryDark,
        bgNeutralSecondaryMedium: FlowbiteColors.bgNeutralSecondaryMediumDark,
        bgNeutralSecondaryStrong: FlowbiteColors.bgNeutralSecondaryStrongDark,
        bgNeutralSecondaryStrongest:
            FlowbiteColors.bgNeutralSecondaryStrongestDark,
        bgNeutralTertiarySoft: FlowbiteColors.bgNeutralTertiarySoftDark,
        bgNeutralTertiary: FlowbiteColors.bgNeutralTertiaryDark,
        bgNeutralTertiaryMedium: FlowbiteColors.bgNeutralTertiaryMediumDark,
        bgNeutralQuaternary: FlowbiteColors.bgNeutralQuaternaryDark,
        bgNeutralQuaternaryMedium: FlowbiteColors.bgNeutralQuaternaryMediumDark,
        bgGray: FlowbiteColors.bgGrayDark,

        // Brand Background Colors - Dark Mode
        bgBrandSofter: FlowbiteColors.bgBrandSofterDark,
        bgBrandSoft: FlowbiteColors.bgBrandSoftDark,
        bgBrand: FlowbiteColors.bgBrandDark,
        bgBrandMedium: FlowbiteColors.bgBrandMediumDark,
        bgBrandStrong: FlowbiteColors.bgBrandStrongDark,

        // Status Background Colors - Dark Mode
        bgSuccessSoft: FlowbiteColors.bgSuccessSoftDark,
        bgSuccess: FlowbiteColors.bgSuccessDark,
        bgSuccessMedium: FlowbiteColors.bgSuccessMediumDark,
        bgSuccessStrong: FlowbiteColors.bgSuccessStrongDark,

        bgDangerSoft: FlowbiteColors.bgDangerSoftDark,
        bgDanger: FlowbiteColors.bgDangerDark,
        bgDangerMedium: FlowbiteColors.bgDangerMediumDark,
        bgDangerStrong: FlowbiteColors.bgDangerStrongDark,

        bgWarningSoft: FlowbiteColors.bgWarningSoftDark,
        bgWarning: FlowbiteColors.bgWarningDark,
        bgWarningMedium: FlowbiteColors.bgWarningMediumDark,
        bgWarningStrong: FlowbiteColors.bgWarningStrongDark,

        bgDarkSoft: FlowbiteColors.bgDarkSoftDark,
        bgDark: FlowbiteColors.bgDarkDark,
        bgDarkStrong: FlowbiteColors.bgDarkStrongDark,

        bgDisabled: FlowbiteColors.bgDisabledDark,

        // Additional Background Colors - Dark Mode
        bgPurple: FlowbiteColors.bgPurpleDark,
        bgSky: FlowbiteColors.bgSkyDark,
        bgTeal: FlowbiteColors.bgTealDark,
        bgPink: FlowbiteColors.bgPinkDark,
        bgCyan: FlowbiteColors.bgCyanDark,
        bgFuchsia: FlowbiteColors.bgFuchsiaDark,
        bgIndigo: FlowbiteColors.bgIndigoDark,
        bgOrange: FlowbiteColors.bgOrangeDark,

        // Border Colors - Dark Mode
        borderBuffer: FlowbiteColors.borderBufferDark,
        borderBufferMedium: FlowbiteColors.borderBufferMediumDark,
        borderBufferStrong: FlowbiteColors.borderBufferStrongDark,
        borderMuted: FlowbiteColors.borderMutedDark,
        borderLightSubtle: FlowbiteColors.borderLightSubtleDark,
        borderLight: FlowbiteColors.borderLightDark,
        borderLightMedium: FlowbiteColors.borderLightMediumDark,
        borderDefaultSubtle: FlowbiteColors.borderDefaultSubtleDark,
        borderDefault: FlowbiteColors.borderDefaultDark,
        borderDefaultMedium: FlowbiteColors.borderDefaultMediumDark,
        borderDefaultStrong: FlowbiteColors.borderDefaultStrongDark,
        borderSuccessSubtle: FlowbiteColors.borderSuccessSubtleDark,
        borderDangerSubtle: FlowbiteColors.borderDangerSubtleDark,
        borderWarningSubtle: FlowbiteColors.borderWarningSubtleDark,
        borderBrandSubtle: FlowbiteColors.borderBrandSubtleDark,
        borderBrandLight: FlowbiteColors.borderBrandLightDark,
        borderDarkSubtle: FlowbiteColors.borderDarkSubtleDark,
        borderDarkBackdrop: FlowbiteColors.borderDarkBackdropDark,
      ),
    ],
  );
}
