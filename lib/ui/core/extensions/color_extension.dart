import 'package:flutter/material.dart';
import 'package:sentinela/ui/core/themes/colors.dart';

class AppColorTheme extends ThemeExtension<AppColorTheme> {
  final Color sidebarBackgroundColor;
  final Color successLight;
  final Color successClarity20;
  final Color primaryLight;
  final Color primaryActive;
  final Color grey200;
  final Color grey300;
  final Color grey400;
  final Color grey500;
  final Color grey600;
  final Color grey700;
  final Color grey800;
  final Color grey900;
  final Color successActive;
  final Color success;
  final Color danger;
  final Color dangerClarity20;
  final Color dangerLight;
  final Color primary;
  final Color systemBackground;
  final Color secondarySystemBackground;
  final Color border;
  final Color darkerBorder;
  final Color lightActive;
  final Color textPrimary;
  final Color textSecondary;
  final Color textTertiary;
  final Color textPlaceholder;
  final Color textQuaternary;
  final Color textDisabled;
  final Color textBrandPrimary;
  final Color textBrandSecondary;
  final Color textBrandTertiary;
  final Color textErrorPrimary;
  final Color textWarningPrimary;
  final Color textSuccessPrimary;
  final Color borderPrimary;
  final Color borderSecondary;
  final Color borderTertiary;
  final Color borderDisabled;
  final Color borderBrand;
  final Color borderError;
  final Color fgPrimary;
  final Color fgSecondary;
  final Color fgTertiary;
  final Color fgQuaternary;
  final Color fgWhite;
  final Color fgDisabled;
  final Color fgBrandPrimary;
  final Color fgBrandSecondary;
  final Color fgErrorPrimary;
  final Color fgErrorSecondary;
  final Color fgWarningPrimary;
  final Color fgWarningSecondary;
  final Color fgSuccessPrimary;
  final Color fgSuccessSecondary;
  final Color bgPrimary;
  final Color bgPrimarySolid;
  final Color bgSecondary;
  final Color bgSecondarySolid;
  final Color bgTertiary;
  final Color bgQuaternary;
  final Color bgActive;
  final Color bgDisabled;
  final Color bgOverlay;
  final Color bgBrandPrimary;
  final Color bgBrandSecondary;
  final Color bgBrandSolid;
  final Color bgBrandSection;
  final Color bgErrorPrimary;
  final Color bgErrorSecondary;
  final Color bgErrorSolid;
  final Color bgWarningPrimary;
  final Color bgWarningSecondary;
  final Color bgWarningSolid;
  final Color bgSuccessPrimary;
  final Color bgSuccessSecondary;
  final Color bgSuccessSolid;
  final Color textPrimaryOnBrand;
  final Color textSecondaryHover;
  final Color textSecondaryOnBrand;
  final Color textTertiaryHover;
  final Color textTertiaryOnBrand;
  final Color textQuaternaryOnBrand;
  final Color textPlaceholderSubtle;
  final Color textBrandSecondaryHover;
  final Color textBrandTertiaryAlt;
  final Color borderDisabledSubtle;
  final Color borderBrandAlt;
  final Color borderErrorSubtle;
  final Color fgSecondaryHover;
  final Color fgTertiaryHover;
  final Color fgQuaternaryHover;
  final Color fgDisabledSubtle;
  final Color fgBrandPrimaryAlt;
  final Color fgBrandSecondaryAlt;
  final Color bgPrimaryAlt;
  final Color bgPrimaryHover;
  final Color bgSecondaryAlt;
  final Color bgSecondaryHover;
  final Color bgSecondarySubtle;
  final Color bgDisabledSubtle;
  final Color bgBrandPrimaryAlt;
  final Color bgBrandSolidHover;
  final Color bgBrandSectionSubtle;
  final Color bgErrorSolidHover;
  final Color utilitySuccess50;
  final Color utilitySuccess700;
  final Color utilityError50;
  final Color utilityError700;
  final Color utilitySuccess200;
  final Color utilityError200;

  AppColorTheme({
    this.sidebarBackgroundColor = AppColors.successLight,
    this.successLight = AppColors.successLight,
    this.successClarity20 = AppColors.successClarity20,
    this.primaryLight = AppColors.primaryLight,
    this.primaryActive = AppColors.primaryActive,
    this.grey200 = AppColors.grey200,
    this.grey300 = AppColors.grey300,
    this.grey400 = AppColors.grey300,
    this.grey500 = AppColors.grey500,
    this.grey600 = AppColors.grey600,
    this.grey700 = AppColors.grey700,
    this.grey800 = AppColors.grey800,
    this.grey900 = AppColors.grey900,
    this.successActive = AppColors.successActive,
    this.success = AppColors.success,
    this.danger = AppColors.danger, 
    this.dangerClarity20 = AppColors.dangerClarity20, 
    this.dangerLight = AppColors.dangerLight, 
    this.primary = AppColors.primary,
    this.systemBackground = AppColors.secondaryClarity20,
    this.secondarySystemBackground = AppColors.white,
    this.border = AppColors.grey200,
    this.darkerBorder = AppColors.grey300,
    this.lightActive = AppColors.lightActive,
    this.textTertiary = AppColors.grey500,
    this.textPrimary = AppColors.grey900,
    this.textPlaceholder = AppColors.grey500,
    this.textSecondary = AppColors.grey700,
    this.textQuaternary = AppColors.grey500,
    this.textDisabled = AppColors.grey500,
    this.textBrandPrimary = AppColors.brand900,
    this.textBrandSecondary = AppColors.brand700,
    this.textBrandTertiary = AppColors.brand600,
    this.textErrorPrimary = AppColors.error600,
    this.textWarningPrimary = AppColors.warning600,
    this.textSuccessPrimary = AppColors.success600,
    this.borderPrimary = AppColors.grey300,
    this.borderSecondary = AppColors.grey200,
    this.borderTertiary = AppColors.grey100,
    this.borderDisabled = AppColors.grey300,
    this.borderBrand = AppColors.brand500,
    this.borderError = AppColors.error500,
    this.fgPrimary = AppColors.grey900,
    this.fgSecondary = AppColors.grey700,
    this.fgTertiary = AppColors.grey600,
    this.fgQuaternary = AppColors.grey400,
    this.fgWhite = AppColors.white,
    this.fgDisabled = AppColors.grey400,
    this.fgBrandPrimary = AppColors.brand600,
    this.fgBrandSecondary = AppColors.brand500,
    this.fgErrorPrimary = AppColors.error600,
    this.fgErrorSecondary = AppColors.error500,
    this.fgWarningPrimary = AppColors.warning600,
    this.fgWarningSecondary = AppColors.warning500,
    this.fgSuccessPrimary = AppColors.success600,
    this.fgSuccessSecondary = AppColors.success500,
    this.bgPrimary = AppColors.white,
    this.bgPrimarySolid = AppColors.grey950,
    this.bgSecondary = AppColors.grey50,
    this.bgSecondarySolid = AppColors.grey600,
    this.bgTertiary = AppColors.grey100,
    this.bgQuaternary = AppColors.grey200,
    this.bgActive = AppColors.grey50,
    this.bgDisabled = AppColors.grey100,
    this.bgOverlay = AppColors.grey950,
    this.bgBrandPrimary = AppColors.brand50,
    this.bgBrandSecondary = AppColors.brand100,
    this.bgBrandSolid = AppColors.brand600,
    this.bgBrandSection = AppColors.brand800,
    this.bgErrorPrimary = AppColors.error50,
    this.bgErrorSecondary = AppColors.error100,
    this.bgErrorSolid = AppColors.error600,
    this.bgWarningPrimary = AppColors.warning50,
    this.bgWarningSecondary = AppColors.warning100,
    this.bgWarningSolid = AppColors.warning600,
    this.bgSuccessPrimary = AppColors.success50,
    this.bgSuccessSecondary = AppColors.success100,
    this.bgSuccessSolid = AppColors.success600,
    this.textPrimaryOnBrand = AppColors.white,
    this.textSecondaryHover = AppColors.grey800,
    this.textSecondaryOnBrand = AppColors.brand200,
    this.textTertiaryHover = AppColors.grey700,
    this.textTertiaryOnBrand = AppColors.brand200,
    this.textQuaternaryOnBrand = AppColors.brand300,
    this.textPlaceholderSubtle = AppColors.grey300,
    this.textBrandSecondaryHover = AppColors.brand800,
    this.textBrandTertiaryAlt = AppColors.brand600,
    this.borderDisabledSubtle = AppColors.grey200,
    this.borderBrandAlt = AppColors.brand600,
    this.borderErrorSubtle = AppColors.error300,
    this.fgSecondaryHover = AppColors.grey800,
    this.fgTertiaryHover = AppColors.grey700,
    this.fgQuaternaryHover = AppColors.grey500,
    this.fgDisabledSubtle = AppColors.grey300,
    this.fgBrandPrimaryAlt = AppColors.brand600,
    this.fgBrandSecondaryAlt = AppColors.brand500,
    this.bgPrimaryAlt = AppColors.white,
    this.bgPrimaryHover = AppColors.grey50,
    this.bgSecondaryAlt = AppColors.grey50,
    this.bgSecondaryHover = AppColors.grey100,
    this.bgSecondarySubtle = AppColors.grey25,
    this.bgDisabledSubtle = AppColors.grey50,
    this.bgBrandPrimaryAlt = AppColors.brand50,
    this.bgBrandSolidHover = AppColors.brand700,
    this.bgBrandSectionSubtle = AppColors.brand700,
    this.bgErrorSolidHover = AppColors.error700,
    this.utilitySuccess50 = AppColors.success50,
    this.utilitySuccess700 = AppColors.success700,
    this.utilityError50 = AppColors.error50,
    this.utilityError700 = AppColors.error700,
    this.utilitySuccess200 = AppColors.success200,
    this.utilityError200 = AppColors.error200,
  });

  @override
  ThemeExtension<AppColorTheme> copyWith({
    Color? sidebarBackgroundColor,
    Color? successLight,
    Color? successClarity20,
    Color? primaryLight,
    Color? primaryActive,
    Color? grey200,
    Color? grey300,
    Color? grey400,
    Color? grey500,
    Color? grey600,
    Color? grey700,
    Color? grey800,
    Color? grey900,
    Color? successActive,
    Color? success,
    Color? danger,
    Color? dangerClarity20,
    Color? dangerLight,
    Color? primary,
    Color? systemBackground,
    Color? secondarySystemBackground,
    Color? border,
    Color? darkerBorder,  
    Color? lightActive,
    Color? textTertiary,
    Color? textPrimary,
    Color? textPlaceholder,
    Color? textSecondary,
    Color? textQuaternary,
    Color? textDisabled,
    Color? textBrandPrimary,
    Color? textBrandSecondary,
    Color? textBrandTertiary,
    Color? textErrorPrimary,
    Color? textWarningPrimary,
    Color? textSuccessPrimary,
    Color? borderPrimary,
    Color? borderSecondary,
    Color? borderTertiary,
    Color? borderDisabled,
    Color? borderBrand,
    Color? borderError,
    Color? fgPrimary,
    Color? fgSecondary,
    Color? fgTertiary,
    Color? fgQuaternary,
    Color? fgWhite,
    Color? fgDisabled,
    Color? fgBrandPrimary,
    Color? fgBrandSecondary,
    Color? fgErrorPrimary,
    Color? fgErrorSecondary,
    Color? fgWarningPrimary,
    Color? fgWarningSecondary,
    Color? fgSuccessPrimary,
    Color? fgSuccessSecondary,
    Color? bgPrimary,
    Color? bgPrimarySolid,
    Color? bgSecondary,
    Color? bgSecondarySolid,
    Color? bgTertiary,
    Color? bgQuaternary,
    Color? bgActive,
    Color? bgDisabled,
    Color? bgOverlay,
    Color? bgBrandPrimary,
    Color? bgBrandSecondary,
    Color? bgBrandSolid,
    Color? bgBrandSection,
    Color? bgErrorPrimary,
    Color? bgErrorSecondary,
    Color? bgErrorSolid,
    Color? bgWarningPrimary,
    Color? bgWarningSecondary,
    Color? bgWarningSolid,
    Color? bgSuccessPrimary,
    Color? bgSuccessSecondary,
    Color? bgSuccessSolid,
    Color? textPrimaryOnBrand,
    Color? textSecondaryHover,
    Color? textSecondaryOnBrand,
    Color? textTertiaryHover,
    Color? textTertiaryOnBrand,
    Color? textQuaternaryOnBrand,
    Color? textPlaceholderSubtle,
    Color? textBrandSecondaryHover,
    Color? textBrandTertiaryAlt,
    Color? borderDisabledSubtle,
    Color? borderBrandAlt,
    Color? borderErrorSubtle,
    Color? fgSecondaryHover,
    Color? fgTertiaryHover,
    Color? fgQuaternaryHover,
    Color? fgDisabledSubtle,
    Color? fgBrandPrimaryAlt,
    Color? fgBrandSecondaryAlt,
    Color? bgPrimaryAlt,
    Color? bgPrimaryHover,
    Color? bgSecondaryAlt,
    Color? bgSecondaryHover,
    Color? bgSecondarySubtle,
    Color? bgDisabledSubtle,
    Color? bgBrandPrimaryAlt,
    Color? bgBrandSolidHover,
    Color? bgBrandSectionSubtle,
    Color? bgErrorSolidHover,
    Color? utilitySuccess50,
    Color? utilitySuccess700,
    Color? utilityError50,
    Color? utilityError700,
    Color? utilitySuccess200,
    Color? utilityError200,
  }) {
    return AppColorTheme(
      sidebarBackgroundColor:
          sidebarBackgroundColor ?? this.sidebarBackgroundColor,
      successLight: successLight ?? this.successLight,
      successClarity20: successClarity20 ?? this.successClarity20,
      primaryLight: primaryLight ?? this.primaryLight,
      primaryActive: primaryActive ?? this.primaryActive,
      grey200: grey200 ?? this.grey200,
      grey300: grey300 ?? this.grey300,
      grey400: grey400 ?? this.grey400,
      grey500: grey500 ?? this.grey500,
      grey600: grey600 ?? this.grey600,
      grey700: grey700 ?? this.grey700,
      grey800: grey800 ?? this.grey800,
      grey900: grey900 ?? this.grey900,
      successActive: successActive ?? this.successActive,
      success: success ?? this.success,
      danger: danger ?? this.danger,
      dangerClarity20: dangerClarity20 ?? this.dangerClarity20,
      dangerLight: dangerLight ?? this.dangerLight,
      primary: primary ?? this.primary,
      systemBackground: systemBackground ?? this.systemBackground,
      secondarySystemBackground: secondarySystemBackground ?? this.secondarySystemBackground,
      border: border ?? this.border, 
      darkerBorder: darkerBorder ?? this.darkerBorder, 
      lightActive: lightActive ?? this.lightActive,
      textTertiary: textTertiary ?? this.textTertiary,
      textPrimary: textPrimary ?? this.textPrimary,
      textPlaceholder: textPlaceholder ?? this.textPlaceholder,
      textSecondary: textSecondary ?? this.textSecondary,
      textQuaternary: textQuaternary ?? this.textQuaternary,
      textDisabled: textDisabled ?? this.textDisabled,
      textBrandPrimary: textBrandPrimary ?? this.textBrandPrimary,
      textBrandSecondary: textBrandSecondary ?? this.textBrandSecondary,
      textBrandTertiary: textBrandTertiary ?? this.textBrandTertiary,
      textErrorPrimary: textErrorPrimary ?? this.textErrorPrimary,
      textWarningPrimary: textWarningPrimary ?? this.textWarningPrimary,
      textSuccessPrimary: textSuccessPrimary ?? this.textSuccessPrimary,
      borderPrimary: borderPrimary ?? this.borderPrimary,
      borderSecondary: borderSecondary ?? this.borderSecondary,
      borderTertiary: borderTertiary ?? this.borderTertiary,
      borderDisabled: borderDisabled ?? this.borderDisabled,
      borderBrand: borderBrand ?? this.borderBrand,
      borderError: borderError ?? this.borderError,
      fgPrimary: fgPrimary ?? this.fgPrimary,
      fgSecondary: fgSecondary ?? this.fgSecondary,
      fgTertiary: fgTertiary ?? this.fgTertiary,
      fgQuaternary: fgQuaternary ?? this.fgQuaternary,
      fgWhite: fgWhite ?? this.fgWhite,
      fgDisabled: fgDisabled ?? this.fgDisabled,
      fgBrandPrimary: fgBrandPrimary ?? this.fgBrandPrimary,
      fgBrandSecondary: fgBrandSecondary ?? this.fgBrandSecondary,
      fgErrorPrimary: fgErrorPrimary ?? this.fgErrorPrimary,
      fgErrorSecondary: fgErrorSecondary ?? this.fgErrorSecondary,
      fgWarningPrimary: fgWarningPrimary ?? this.fgWarningPrimary,
      fgWarningSecondary: fgWarningSecondary ?? this.fgWarningSecondary,
      fgSuccessPrimary: fgSuccessPrimary ?? this.fgSuccessPrimary,
      fgSuccessSecondary: fgSuccessSecondary ?? this.fgSuccessSecondary,
      bgPrimary: bgPrimary ?? this.bgPrimary,
      bgPrimarySolid: bgPrimarySolid ?? this.bgPrimarySolid,
      bgSecondary: bgSecondary ?? this.bgSecondary,
      bgSecondarySolid: bgSecondarySolid ?? this.bgSecondarySolid,
      bgTertiary: bgTertiary ?? this.bgTertiary,
      bgQuaternary: bgQuaternary ?? this.bgQuaternary,
      bgActive: bgActive ?? this.bgActive,
      bgDisabled: bgDisabled ?? this.bgDisabled,
      bgOverlay: bgOverlay ?? this.bgOverlay,
      bgBrandPrimary: bgBrandPrimary ?? this.bgBrandPrimary,
      bgBrandSecondary: bgBrandSecondary ?? this.bgBrandSecondary,
      bgBrandSolid: bgBrandSolid ?? this.bgBrandSolid,
      bgBrandSection: bgBrandSection ?? this.bgBrandSection,
      bgErrorPrimary: bgErrorPrimary ?? this.bgErrorPrimary,
      bgErrorSecondary: bgErrorSecondary ?? this.bgErrorSecondary,
      bgErrorSolid: bgErrorSolid ?? this.bgErrorSolid,
      bgWarningPrimary: bgWarningPrimary ?? this.bgWarningPrimary,
      bgWarningSecondary: bgWarningSecondary ?? this.bgWarningSecondary,
      bgWarningSolid: bgWarningSolid ?? this.bgWarningSolid,
      bgSuccessPrimary: bgSuccessPrimary ?? this.bgSuccessPrimary,
      bgSuccessSecondary: bgSuccessSecondary ?? this.bgSuccessSecondary,
      bgSuccessSolid: bgSuccessSolid ?? this.bgSuccessSolid,
      textPrimaryOnBrand: textPrimaryOnBrand ?? this.textPrimaryOnBrand,
      textSecondaryHover: textSecondaryHover ?? this.textSecondaryHover,
      textSecondaryOnBrand: textSecondaryOnBrand ?? this.textSecondaryOnBrand,
      textTertiaryHover: textTertiaryHover ?? this.textTertiaryHover,
      textTertiaryOnBrand: textTertiaryOnBrand ?? this.textTertiaryOnBrand,
      textQuaternaryOnBrand: textQuaternaryOnBrand ?? this.textQuaternaryOnBrand,
      textPlaceholderSubtle: textPlaceholderSubtle ?? this.textPlaceholderSubtle,
      textBrandSecondaryHover: textBrandSecondaryHover ?? this.textBrandSecondaryHover,
      textBrandTertiaryAlt: textBrandTertiaryAlt ?? this.textBrandTertiaryAlt,
      borderDisabledSubtle: borderDisabledSubtle ?? this.borderDisabledSubtle,
      borderBrandAlt: borderBrandAlt ?? this.borderBrandAlt,
      borderErrorSubtle: borderErrorSubtle ?? this.borderErrorSubtle,
      fgSecondaryHover: fgSecondaryHover ?? this.fgSecondaryHover,
      fgTertiaryHover: fgTertiaryHover ?? this.fgTertiaryHover,
      fgQuaternaryHover: fgQuaternaryHover ?? this.fgQuaternaryHover,
      fgDisabledSubtle: fgDisabledSubtle ?? this.fgDisabledSubtle,
      fgBrandPrimaryAlt: fgBrandPrimaryAlt ?? this.fgBrandPrimaryAlt,
      fgBrandSecondaryAlt: fgBrandSecondaryAlt ?? this.fgBrandSecondaryAlt,
      bgPrimaryAlt: bgPrimaryAlt ?? this.bgPrimaryAlt,
      bgPrimaryHover: bgPrimaryHover ?? this.bgPrimaryHover,
      bgSecondaryAlt: bgSecondaryAlt ?? this.bgSecondaryAlt,
      bgSecondaryHover: bgSecondaryHover ?? this.bgSecondaryHover,
      bgSecondarySubtle: bgSecondarySubtle ?? this.bgSecondarySubtle,
      bgDisabledSubtle: bgDisabledSubtle ?? this.bgDisabledSubtle,
      bgBrandPrimaryAlt: bgBrandPrimaryAlt ?? this.bgBrandPrimaryAlt,
      bgBrandSolidHover: bgBrandSolidHover ?? this.bgBrandSolidHover,
      bgBrandSectionSubtle: bgBrandSectionSubtle ?? this.bgBrandSectionSubtle,
      bgErrorSolidHover: bgErrorSolidHover ?? this.bgErrorSolidHover,
      utilitySuccess50: utilitySuccess50 ?? this.utilitySuccess50,
      utilitySuccess700: utilitySuccess700 ?? this.utilitySuccess700,
      utilityError50: utilityError50 ?? this.utilityError50,
      utilityError700: utilityError700 ?? this.utilityError700,
      utilitySuccess200: utilitySuccess200 ?? this.utilitySuccess200,
      utilityError200: utilityError200 ?? this.utilityError200,
    );
  }

  @override
  ThemeExtension<AppColorTheme> lerp (
    covariant ThemeExtension<AppColorTheme>? other,
    double t,
  ) {
    if (other is! AppColorTheme) {
      return this;
    }
    return AppColorTheme(
      sidebarBackgroundColor: Color.lerp(sidebarBackgroundColor, other.sidebarBackgroundColor, t) ?? sidebarBackgroundColor,
      textTertiary: Color.lerp(textTertiary, other.textTertiary, t) ?? textTertiary,
      successLight: Color.lerp(successLight, other.successLight, t) ?? successLight,
      successClarity20: Color.lerp(successClarity20, other.successClarity20, t) ?? successClarity20,
      primaryLight: Color.lerp(primaryLight, other.primaryLight, t) ?? primaryLight,
      primaryActive: Color.lerp(primaryActive, other.primaryActive, t) ?? primaryActive,
      grey200: Color.lerp(grey200, other.grey200, t) ?? grey200,
      grey300: Color.lerp(grey300, other.grey300, t) ?? grey300,
      grey400: Color.lerp(grey400, other.grey400, t) ?? grey400,
      grey500: Color.lerp(grey500, other.grey500, t) ?? grey500,
      grey600: Color.lerp(grey600, other.grey600, t) ?? grey600,
      grey700: Color.lerp(grey700, other.grey700, t) ?? grey700,
      grey800: Color.lerp(grey800, other.grey800, t) ?? grey800,
      grey900: Color.lerp(grey900, other.grey900, t) ?? grey900,
      successActive: Color.lerp(successActive, other.successActive, t) ?? successActive,
      success: Color.lerp(success, other.success, t) ?? success,
      danger: Color.lerp(danger, other.danger, t) ?? danger,
      dangerClarity20: Color.lerp(dangerClarity20, other.dangerClarity20, t) ?? dangerClarity20,
      dangerLight: Color.lerp(dangerLight, other.dangerLight, t) ?? dangerLight,
      primary: Color.lerp(primary, other.primary, t) ?? primary,
      systemBackground: Color.lerp(systemBackground, other.systemBackground, t) ?? systemBackground,
      secondarySystemBackground: Color.lerp(secondarySystemBackground, other.secondarySystemBackground, t) ?? secondarySystemBackground,
      border: Color.lerp(border, other.border, t) ?? border,
      darkerBorder: Color.lerp(darkerBorder, other.darkerBorder, t) ?? darkerBorder,
      lightActive: Color.lerp(lightActive, other.lightActive, t) ?? lightActive,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t) ?? textPrimary,
      textPlaceholder: Color.lerp(textPlaceholder, other.textPlaceholder, t) ?? textPlaceholder,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t) ?? textSecondary,
      textQuaternary: Color.lerp(textQuaternary, other.textQuaternary, t) ?? textQuaternary,
      textDisabled: Color.lerp(textDisabled, other.textDisabled, t) ?? textDisabled,
      textBrandPrimary: Color.lerp(textBrandPrimary, other.textBrandPrimary, t) ?? textBrandPrimary,
      textBrandSecondary: Color.lerp(textBrandSecondary, other.textBrandSecondary, t) ?? textBrandSecondary,
      textBrandTertiary: Color.lerp(textBrandTertiary, other.textBrandTertiary, t) ?? textBrandTertiary,
      textErrorPrimary: Color.lerp(textErrorPrimary, other.textErrorPrimary, t) ?? textErrorPrimary,
      textWarningPrimary: Color.lerp(textWarningPrimary, other.textWarningPrimary, t) ?? textWarningPrimary,
      textSuccessPrimary: Color.lerp(textSuccessPrimary, other.textSuccessPrimary, t) ?? textSuccessPrimary,
      borderPrimary: Color.lerp(borderPrimary, other.borderPrimary, t) ?? borderPrimary,
      borderSecondary: Color.lerp(borderSecondary, other.borderSecondary, t) ?? borderSecondary,
      borderTertiary: Color.lerp(borderTertiary, other.borderTertiary, t) ?? borderTertiary,
      borderDisabled: Color.lerp(borderDisabled, other.borderDisabled, t) ?? borderDisabled,
      borderBrand: Color.lerp(borderBrand, other.borderBrand, t) ?? borderBrand,
      borderError: Color.lerp(borderError, other.borderError, t) ?? borderError,
      fgPrimary: Color.lerp(fgPrimary, other.fgPrimary, t) ?? fgPrimary,
      fgSecondary: Color.lerp(fgSecondary, other.fgSecondary, t) ?? fgSecondary,
      fgTertiary: Color.lerp(fgTertiary, other.fgTertiary, t) ?? fgTertiary,
      fgQuaternary: Color.lerp(fgQuaternary, other.fgQuaternary, t) ?? fgQuaternary,
      fgWhite: Color.lerp(fgWhite, other.fgWhite, t) ?? fgWhite,
      fgDisabled: Color.lerp(fgDisabled, other.fgDisabled, t) ?? fgDisabled,
      fgBrandPrimary: Color.lerp(fgBrandPrimary, other.fgBrandPrimary, t) ?? fgBrandPrimary,
      fgBrandSecondary: Color.lerp(fgBrandSecondary, other.fgBrandSecondary, t) ?? fgBrandSecondary,
      fgErrorPrimary: Color.lerp(fgErrorPrimary, other.fgErrorPrimary, t) ?? fgErrorPrimary,
      fgErrorSecondary: Color.lerp(fgErrorSecondary, other.fgErrorSecondary, t) ?? fgErrorSecondary,
      fgWarningPrimary: Color.lerp(fgWarningPrimary, other.fgWarningPrimary, t) ?? fgWarningPrimary,
      fgWarningSecondary: Color.lerp(fgWarningSecondary, other.fgWarningSecondary, t) ?? fgWarningSecondary,
      fgSuccessPrimary: Color.lerp(fgSuccessPrimary, other.fgSuccessPrimary, t) ?? fgSuccessPrimary,
      fgSuccessSecondary: Color.lerp(fgSuccessSecondary, other.fgSuccessSecondary, t) ?? fgSuccessSecondary,
      bgPrimary: Color.lerp(bgPrimary, other.bgPrimary, t) ?? bgPrimary,
      bgPrimarySolid: Color.lerp(bgPrimarySolid, other.bgPrimarySolid, t) ?? bgPrimarySolid,
      bgSecondary: Color.lerp(bgSecondary, other.bgSecondary, t) ?? bgSecondary,
      bgSecondarySolid: Color.lerp(bgSecondarySolid, other.bgSecondarySolid, t) ?? bgSecondarySolid,
      bgTertiary: Color.lerp(bgTertiary, other.bgTertiary, t) ?? bgTertiary,
      bgQuaternary: Color.lerp(bgQuaternary, other.bgQuaternary, t) ?? bgQuaternary,
      bgActive: Color.lerp(bgActive, other.bgActive, t) ?? bgActive,
      bgDisabled: Color.lerp(bgDisabled, other.bgDisabled, t) ?? bgDisabled,
      bgOverlay: Color.lerp(bgOverlay, other.bgOverlay, t) ?? bgOverlay,
      bgBrandPrimary: Color.lerp(bgBrandPrimary, other.bgBrandPrimary, t) ?? bgBrandPrimary,
      bgBrandSecondary: Color.lerp(bgBrandSecondary, other.bgBrandSecondary, t) ?? bgBrandSecondary,
      bgBrandSolid: Color.lerp(bgBrandSolid, other.bgBrandSolid, t) ?? bgBrandSolid,
      bgBrandSection: Color.lerp(bgBrandSection, other.bgBrandSection, t) ?? bgBrandSection,
      bgErrorPrimary: Color.lerp(bgErrorPrimary, other.bgErrorPrimary, t) ?? bgErrorPrimary,
      bgErrorSecondary: Color.lerp(bgErrorSecondary, other.bgErrorSecondary, t) ?? bgErrorSecondary,
      bgErrorSolid: Color.lerp(bgErrorSolid, other.bgErrorSolid, t) ?? bgErrorSolid,
      bgWarningPrimary: Color.lerp(bgWarningPrimary, other.bgWarningPrimary, t) ?? bgWarningPrimary,
      bgWarningSecondary: Color.lerp(bgWarningSecondary, other.bgWarningSecondary, t) ?? bgWarningSecondary,
      bgWarningSolid: Color.lerp(bgWarningSolid, other.bgWarningSolid, t) ?? bgWarningSolid,
      bgSuccessPrimary: Color.lerp(bgSuccessPrimary, other.bgSuccessPrimary, t) ?? bgSuccessPrimary,
      bgSuccessSecondary: Color.lerp(bgSuccessSecondary, other.bgSuccessSecondary, t) ?? bgSuccessSecondary,
      bgSuccessSolid: Color.lerp(bgSuccessSolid, other.bgSuccessSolid, t) ?? bgSuccessSolid,
      textPrimaryOnBrand: Color.lerp(textPrimaryOnBrand, other.textPrimaryOnBrand, t) ?? textPrimaryOnBrand,
      textSecondaryHover: Color.lerp(textSecondaryHover, other.textSecondaryHover, t) ?? textSecondaryHover,
      textSecondaryOnBrand: Color.lerp(textSecondaryOnBrand, other.textSecondaryOnBrand, t) ?? textSecondaryOnBrand,
      textTertiaryHover: Color.lerp(textTertiaryHover, other.textTertiaryHover, t) ?? textTertiaryHover,
      textTertiaryOnBrand: Color.lerp(textTertiaryOnBrand, other.textTertiaryOnBrand, t) ?? textTertiaryOnBrand,
      textQuaternaryOnBrand: Color.lerp(textQuaternaryOnBrand, other.textQuaternaryOnBrand, t) ?? textQuaternaryOnBrand,
      textPlaceholderSubtle: Color.lerp(textPlaceholderSubtle, other.textPlaceholderSubtle, t) ?? textPlaceholderSubtle,
      textBrandSecondaryHover: Color.lerp(textBrandSecondaryHover, other.textBrandSecondaryHover, t) ?? textBrandSecondaryHover,
      textBrandTertiaryAlt: Color.lerp(textBrandTertiaryAlt, other.textBrandTertiaryAlt, t) ?? textBrandTertiaryAlt,
      borderDisabledSubtle: Color.lerp(borderDisabledSubtle, other.borderDisabledSubtle, t) ?? borderDisabledSubtle,
      borderBrandAlt: Color.lerp(borderBrandAlt, other.borderBrandAlt, t) ?? borderBrandAlt,
      borderErrorSubtle: Color.lerp(borderErrorSubtle, other.borderErrorSubtle, t) ?? borderErrorSubtle,
      fgSecondaryHover: Color.lerp(fgSecondaryHover, other.fgSecondaryHover, t) ?? fgSecondaryHover,
      fgTertiaryHover: Color.lerp(fgTertiaryHover, other.fgTertiaryHover, t) ?? fgTertiaryHover,
      fgQuaternaryHover: Color.lerp(fgQuaternaryHover, other.fgQuaternaryHover, t) ?? fgQuaternaryHover,
      fgDisabledSubtle: Color.lerp(fgDisabledSubtle, other.fgDisabledSubtle, t) ?? fgDisabledSubtle,
      fgBrandPrimaryAlt: Color.lerp(fgBrandPrimaryAlt, other.fgBrandPrimaryAlt, t) ?? fgBrandPrimaryAlt,
      fgBrandSecondaryAlt: Color.lerp(fgBrandSecondaryAlt, other.fgBrandSecondaryAlt, t) ?? fgBrandSecondaryAlt,
      bgPrimaryAlt: Color.lerp(bgPrimaryAlt, other.bgPrimaryAlt, t) ?? bgPrimaryAlt,
      bgPrimaryHover: Color.lerp(bgPrimaryHover, other.bgPrimaryHover, t) ?? bgPrimaryHover,
      bgSecondaryAlt: Color.lerp(bgSecondaryAlt, other.bgSecondaryAlt, t) ?? bgSecondaryAlt,
      bgSecondaryHover: Color.lerp(bgSecondaryHover, other.bgSecondaryHover, t) ?? bgSecondaryHover,
      bgSecondarySubtle: Color.lerp(bgSecondarySubtle, other.bgSecondarySubtle, t) ?? bgSecondarySubtle,
      bgDisabledSubtle: Color.lerp(bgDisabledSubtle, other.bgDisabledSubtle, t) ?? bgDisabledSubtle,
      bgBrandPrimaryAlt: Color.lerp(bgBrandPrimaryAlt, other.bgBrandPrimaryAlt, t) ?? bgBrandPrimaryAlt,
      bgBrandSolidHover: Color.lerp(bgBrandSolidHover, other.bgBrandSolidHover, t) ?? bgBrandSolidHover,
      bgBrandSectionSubtle: Color.lerp(bgBrandSectionSubtle, other.bgBrandSectionSubtle, t) ?? bgBrandSectionSubtle,
      bgErrorSolidHover: Color.lerp(bgErrorSolidHover, other.bgErrorSolidHover, t) ?? bgErrorSolidHover,
      utilitySuccess50: Color.lerp(utilitySuccess50, other.utilitySuccess50, t) ?? utilitySuccess50,
      utilitySuccess700: Color.lerp(utilitySuccess700, other.utilitySuccess700, t) ?? utilitySuccess700,
      utilityError50: Color.lerp(utilityError50, other.utilityError50, t) ?? utilityError50,
      utilityError700: Color.lerp(utilityError700, other.utilityError700, t) ?? utilityError700,
      utilitySuccess200: Color.lerp(utilitySuccess200, other.utilitySuccess200, t) ?? utilitySuccess200,
      utilityError200: Color.lerp(utilityError200, other.utilityError200, t) ?? utilityError200,
    );
  }
}