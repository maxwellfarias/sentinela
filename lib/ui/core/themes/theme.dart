import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sentinela/ui/core/extensions/color_extension.dart';
import 'package:sentinela/ui/core/extensions/new_color_extension.dart';
import 'package:sentinela/ui/core/themes/custom_text_style.dart';
import 'package:sentinela/ui/core/themes/new_colors.dart';
import 'colors.dart';

abstract final class AppTheme {


static _border([Color color = AppColors.grey300]) => OutlineInputBorder(
        borderSide: BorderSide(
          color: color,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(6),
      );

static final _customTextTheme = CustomTextTheme();      

static final _textTheme = TextTheme(
 headlineSmall: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.w600, fontSize: 26, height: 1),
 titleLarge: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold, fontSize: 20, height: 1),
 titleMedium: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.w600, fontSize: 16, height: 1),
 titleSmall: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.w500, fontSize: 14, height: 1),
 bodyLarge: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.w400, fontSize: 16, height: 1),
 bodyMedium: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.w400, fontSize: 14, height: 1),
 bodySmall: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.w400, fontSize: 12, height: 1),
 labelSmall: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.w500, fontSize: 11, height: 1));
 

  

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
      selectedColor:AppColors.primaryLight, 
      side: WidgetStateBorderSide.resolveWith((state){
        if (state.contains(WidgetState.selected)) {
          return BorderSide(color: AppColors.primary.withValues(alpha: 0.2), width: 2);
        } else if (state.contains(WidgetState.disabled)) {
          return BorderSide(color: AppColors.grey300, width: 1);
        }
        return BorderSide(color: AppColors.grey300, width: 1);
      })
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
        side: BorderSide(
          color: AppColors.grey200,
          width: 1,
        ),
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
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6),
        ),
      ),
    ),

    dividerTheme: DividerThemeData(space: 0, indent: 0, endIndent: 0, color: AppColors.grey200),

    dataTableTheme: DataTableThemeData(
      dataRowColor: WidgetStateProperty.resolveWith<Color>(
        (Set<WidgetState> states) {
          return AppColors.white; // Cor padrão
        },
      ),
    ),
       
    extensions: [NewAppColorTheme()]
  );

//MARK: ThemeData Dark
  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    fontFamily: 'Inter',
    colorScheme: ColorScheme.fromSeed(
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
    textTheme: _textTheme.merge(ThemeData(brightness: Brightness.dark).textTheme,),

    chipTheme: ChipThemeData(
      checkmarkColor: AppColors.primaryActiveDark,
      selectedColor:AppColors.primaryLightDark, 
      side: WidgetStateBorderSide.resolveWith((state){
        if (state.contains(WidgetState.selected)) {
          return BorderSide(color: AppColors.primaryDark.withValues(alpha: 0.2), width: 2);
        } else if (state.contains(WidgetState.disabled)) {
          return BorderSide(color: AppColors.grey300Dark, width: 1);
        }
        return BorderSide(color: AppColors.grey300Dark, width: 1);
      })
    ),

    inputDecorationTheme: InputDecorationTheme(
      contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      border: _border(),
      focusedBorder: _border(AppColors.primaryDark),
      enabledBorder: _border(AppColors.grey300Dark),
      errorBorder: _border(AppColors.dangerDark),
      errorStyle: TextStyle(color: AppColors.dangerDark),
      hintStyle: _customTextTheme.textBase.copyWith(
        color: AppColors.grey400,
      ),
    ),
    
    cardTheme: CardThemeData(
      color: AppColors.grey800Dark,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: AppColors.grey800Dark,
          width: 1,
        ),
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
        space: 0, indent: 0, endIndent: 0, color: AppColors.grey800Dark),

      dataTableTheme: DataTableThemeData(
        
      dataRowColor: WidgetStateProperty.resolveWith<Color>(
        (Set<WidgetState> states) {
          // if (states.contains(WidgetState.hovered) || states.contains(WidgetState.focused) || states.contains(WidgetState.selected)) {
          //   return AppColors.grey500;
          // }h
          
          return AppColors.grey950Dark; // Cor padrão
        },
      ),
    ),

    extensions: [
      NewAppColorTheme(
        background: NewAppColors.backgroundDark,
        foreground: NewAppColors.foregroundDark,
        primary: NewAppColors.primaryDark,
        primaryForeground: NewAppColors.primaryForegroundDark,
        primaryLight: NewAppColors.primaryLightDark,
        primaryShade: NewAppColors.primaryShadeDark,
        success: NewAppColors.successDark,
        successForeground: NewAppColors.successForegroundDark,
        successLight: NewAppColors.successLightDark,
        warning: NewAppColors.warningDark,
        warningForeground: NewAppColors.warningForegroundDark,
        destructive: NewAppColors.destructiveDark,
        destructiveForeground: NewAppColors.destructiveForegroundDark,
        card: NewAppColors.cardDark,
        cardForeground: NewAppColors.cardForegroundDark,
        popover: NewAppColors.popoverDark,
        popoverForeground: NewAppColors.popoverForegroundDark,
        secondary: NewAppColors.secondaryDark,
        secondaryForeground: NewAppColors.secondaryForegroundDark,
        muted: NewAppColors.mutedDark,
        mutedForeground: NewAppColors.mutedForegroundDark,
        accent: NewAppColors.accentDark,
        accentForeground: NewAppColors.accentForegroundDark,
        border: NewAppColors.borderDark,
        input: NewAppColors.inputDark,
        ring: NewAppColors.ringDark,
        sidebarBackground: NewAppColors.sidebarBackgroundDark,
        sidebarForeground: NewAppColors.sidebarForegroundDark,
        sidebarPrimary: NewAppColors.sidebarPrimaryDark,
        sidebarPrimaryForeground: NewAppColors.sidebarPrimaryForegroundDark,
        sidebarAccent: NewAppColors.sidebarAccentDark,
        sidebarAccentForeground: NewAppColors.sidebarAccentForegroundDark,
        sidebarBorder: NewAppColors.sidebarBorderDark,
        sidebarRing: NewAppColors.sidebarRingDark,
        shadowElegant: NewAppColors.shadowElegantDark,
        shadowCard: NewAppColors.shadowCardDark,
      ),
      AppColorTheme(
        primaryActive: AppColors.brand600,
        grey300: AppColors.grey300Dark,
        grey500: AppColors.grey500Dark,
        grey400: AppColors.grey400Dark,
        grey600: AppColors.grey600Dark,
        grey700: AppColors.grey700Dark,
        grey800: AppColors.grey800Dark,
        grey900: AppColors.grey900Dark,
        danger: AppColors.dangerDark,
        lightActive: AppColors.lightActiveDark,
        dangerClarity20: AppColors.dangerClarity20Dark,
        dangerLight: AppColors.dangerLightDark,
        sidebarBackgroundColor: NewAppColors.sidebarBackgroundDark,
        primaryLight: AppColors.primaryLightDark,
        textTertiary: AppColors.grey400,
        textPrimary: AppColors.grey50,
        textPlaceholder: AppColors.grey400,
        textSecondary: AppColors.grey300Dark,
        textQuaternary: AppColors.grey400Dark,
        textDisabled: AppColors.grey500Dark,
        textBrandPrimary: AppColors.grey50Dark,
        textBrandSecondary: AppColors.grey300Dark,
        textBrandTertiary: AppColors.grey400Dark,
        textErrorPrimary: AppColors.error400,
        textWarningPrimary: AppColors.warning400,
        textSuccessPrimary: AppColors.success400,
        borderPrimary: AppColors.grey700Dark,
        borderSecondary: AppColors.grey800Dark,
        borderTertiary: AppColors.grey800Dark,
        borderDisabled: AppColors.grey700Dark,
        borderBrand: AppColors.brand400,
        borderError: AppColors.error400,
        fgPrimary: AppColors.white,
        fgSecondary: AppColors.grey300Dark,
        fgTertiary: AppColors.grey400Dark,
        fgQuaternary: AppColors.grey600Dark,
        fgWhite: AppColors.white,
        fgDisabled: AppColors.grey500Dark,
        fgBrandPrimary: AppColors.brand500,
        fgBrandSecondary: AppColors.brand500,
        fgErrorPrimary: AppColors.error500,
        fgErrorSecondary: AppColors.error400,
        fgWarningPrimary: AppColors.warning500,
        fgWarningSecondary: AppColors.warning400,
        fgSuccessPrimary: AppColors.success500,
        fgSuccessSecondary: AppColors.success400,
        bgPrimary: AppColors.grey950Dark,
        bgPrimarySolid: AppColors.grey900Dark,
        bgSecondary: AppColors.grey900Dark,
        bgSecondarySolid: AppColors.grey600Dark,
        bgTertiary: AppColors.grey800Dark,
        bgQuaternary: AppColors.grey700Dark,
        bgActive: AppColors.grey800Dark,
        bgDisabled: AppColors.grey800Dark,
        bgOverlay: AppColors.grey800Dark,
        bgBrandPrimary: AppColors.brand500,
        bgBrandSecondary: AppColors.brand600,
        bgBrandSolid: AppColors.brand600,
        bgBrandSection: AppColors.grey800Dark,
        bgErrorPrimary: AppColors.error950,
        bgErrorSecondary: AppColors.error600,
        bgErrorSolid: AppColors.error600,
        bgWarningPrimary: AppColors.warning950,
        bgWarningSecondary: AppColors.warning600,
        bgWarningSolid: AppColors.warning600,
        bgSuccessPrimary: AppColors.success950,
        bgSuccessSecondary: AppColors.success600,
        bgSuccessSolid: AppColors.success600,
        textPrimaryOnBrand: AppColors.grey50Dark,
        textSecondaryHover: AppColors.grey200Dark,
        textSecondaryOnBrand: AppColors.grey300Dark,
        textTertiaryHover: AppColors.grey300Dark,
        textTertiaryOnBrand: AppColors.grey400Dark,
        textQuaternaryOnBrand: AppColors.grey400Dark,
        textPlaceholderSubtle: AppColors.grey700Dark,
        textBrandSecondaryHover: AppColors.grey300Dark,
        textBrandTertiaryAlt: AppColors.grey50Dark,
        borderDisabledSubtle: AppColors.grey800Dark,
        borderBrandAlt: AppColors.grey700Dark,
        borderErrorSubtle: AppColors.error500,
        fgSecondaryHover: AppColors.grey200Dark,
        fgTertiaryHover: AppColors.grey300Dark,
        fgQuaternaryHover: AppColors.grey500Dark,
        fgDisabledSubtle: AppColors.grey600Dark,
        fgBrandPrimaryAlt: AppColors.grey300Dark,
        fgBrandSecondaryAlt: AppColors.grey600Dark,
        bgPrimaryAlt: AppColors.grey900Dark,
        bgPrimaryHover: AppColors.grey800Dark,
        bgSecondaryAlt: AppColors.grey950Dark,
        bgSecondaryHover: AppColors.grey800Dark,
        bgSecondarySubtle: AppColors.grey900Dark,
        bgDisabledSubtle: AppColors.grey900Dark,
        bgBrandPrimaryAlt: AppColors.grey800Dark,
        bgBrandSolidHover: AppColors.brand500,
        bgBrandSectionSubtle: AppColors.grey950Dark,
        bgErrorSolidHover: AppColors.error500,
        utilitySuccess50: AppColors.success950,
        utilitySuccess700: AppColors.success300,
        utilityError50: AppColors.error950,
        utilityError700: AppColors.error300,
        utilitySuccess200: AppColors.success200,
        utilityError200: AppColors.error800,
      )
    ],
  );
}

