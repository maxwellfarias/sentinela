import 'package:flutter/material.dart';
import 'package:sentinela/ui/core/themes/flowbite_colors.dart';

class CustomColorTheme extends ThemeExtension<CustomColorTheme> {
  // ============================================
  // 🔤 SEMANTIC TEXT COLORS (Foreground)
  // ============================================
  final Color fgBody;
  final Color fgBodySubtle;
  final Color fgHeading;
  final Color fgBrandSubtle;
  final Color fgBrand;
  final Color fgBrandStrong;
  final Color fgSuccess;
  final Color fgSuccessStrong;
  final Color fgDanger;
  final Color fgDangerStrong;
  final Color fgWarningSubtle;
  final Color fgWarning;
  final Color fgYellow;
  final Color fgDisabled;
  final Color fgPurple;
  final Color fgCyan;
  final Color fgIndigo;
  final Color fgPink;
  final Color fgLime;

  // ============================================
  // 🎨 SEMANTIC BACKGROUND COLORS
  // ============================================

  // Neutral Background Colors
  final Color bgNeutralPrimarySoft;
  final Color bgNeutralPrimary;
  final Color bgNeutralPrimaryMedium;
  final Color bgNeutralPrimaryStrong;
  final Color bgNeutralSecondarySoft;
  final Color bgNeutralSecondary;
  final Color bgNeutralSecondaryMedium;
  final Color bgNeutralSecondaryStrong;
  final Color bgNeutralSecondaryStrongest;
  final Color bgNeutralTertiarySoft;
  final Color bgNeutralTertiary;
  final Color bgNeutralTertiaryMedium;
  final Color bgNeutralQuaternary;
  final Color bgNeutralQuaternaryMedium;
  final Color bgGray;

  // Brand Background Colors
  final Color bgBrandSofter;
  final Color bgBrandSoft;
  final Color bgBrand;
  final Color bgBrandMedium;
  final Color bgBrandStrong;

  // Status Background Colors
  final Color bgSuccessSoft;
  final Color bgSuccess;
  final Color bgSuccessMedium;
  final Color bgSuccessStrong;

  final Color bgDangerSoft;
  final Color bgDanger;
  final Color bgDangerMedium;
  final Color bgDangerStrong;

  final Color bgWarningSoft;
  final Color bgWarning;
  final Color bgWarningMedium;
  final Color bgWarningStrong;

  final Color bgDarkSoft;
  final Color bgDark;
  final Color bgDarkStrong;

  final Color bgDisabled;

  // Additional Background Colors
  final Color bgPurple;
  final Color bgSky;
  final Color bgTeal;
  final Color bgPink;
  final Color bgCyan;
  final Color bgFuchsia;
  final Color bgIndigo;
  final Color bgOrange;

  // ============================================
  // 🔲 SEMANTIC BORDER COLORS
  // ============================================
  final Color borderBuffer;
  final Color borderBufferMedium;
  final Color borderBufferStrong;
  final Color borderMuted;
  final Color borderLightSubtle;
  final Color borderLight;
  final Color borderLightMedium;
  final Color borderDefaultSubtle;
  final Color borderDefault;
  final Color borderDefaultMedium;
  final Color borderDefaultStrong;
  final Color borderSuccessSubtle;
  final Color borderDangerSubtle;
  final Color borderWarningSubtle;
  final Color borderBrandSubtle;
  final Color borderBrandLight;
  final Color borderDarkSubtle;
  final Color borderDarkBackdrop;

  const CustomColorTheme({
    // Foreground Colors - Light Mode defaults
    this.fgBody = FlowbiteColors.fgBody,
    this.fgBodySubtle = FlowbiteColors.fgBodySubtle,
    this.fgHeading = FlowbiteColors.fgHeading,
    this.fgBrandSubtle = FlowbiteColors.fgBrandSubtle,
    this.fgBrand = FlowbiteColors.fgBrand,
    this.fgBrandStrong = FlowbiteColors.fgBrandStrong,
    this.fgSuccess = FlowbiteColors.fgSuccess,
    this.fgSuccessStrong = FlowbiteColors.fgSuccessStrong,
    this.fgDanger = FlowbiteColors.fgDanger,
    this.fgDangerStrong = FlowbiteColors.fgDangerStrong,
    this.fgWarningSubtle = FlowbiteColors.fgWarningSubtle,
    this.fgWarning = FlowbiteColors.fgWarning,
    this.fgYellow = FlowbiteColors.fgYellow,
    this.fgDisabled = FlowbiteColors.fgDisabled,
    this.fgPurple = FlowbiteColors.fgPurple,
    this.fgCyan = FlowbiteColors.fgCyan,
    this.fgIndigo = FlowbiteColors.fgIndigo,
    this.fgPink = FlowbiteColors.fgPink,
    this.fgLime = FlowbiteColors.fgLime,

    // Neutral Background Colors - Light Mode defaults
    this.bgNeutralPrimarySoft = FlowbiteColors.bgNeutralPrimarySoft,
    this.bgNeutralPrimary = FlowbiteColors.bgNeutralPrimary,
    this.bgNeutralPrimaryMedium = FlowbiteColors.bgNeutralPrimaryMedium,
    this.bgNeutralPrimaryStrong = FlowbiteColors.bgNeutralPrimaryStrong,
    this.bgNeutralSecondarySoft = FlowbiteColors.bgNeutralSecondarySoft,
    this.bgNeutralSecondary = FlowbiteColors.bgNeutralSecondary,
    this.bgNeutralSecondaryMedium = FlowbiteColors.bgNeutralSecondaryMedium,
    this.bgNeutralSecondaryStrong = FlowbiteColors.bgNeutralSecondaryStrong,
    this.bgNeutralSecondaryStrongest =
        FlowbiteColors.bgNeutralSecondaryStrongest,
    this.bgNeutralTertiarySoft = FlowbiteColors.bgNeutralTertiarySoft,
    this.bgNeutralTertiary = FlowbiteColors.bgNeutralTertiary,
    this.bgNeutralTertiaryMedium = FlowbiteColors.bgNeutralTertiaryMedium,
    this.bgNeutralQuaternary = FlowbiteColors.bgNeutralQuaternary,
    this.bgNeutralQuaternaryMedium = FlowbiteColors.bgNeutralQuaternaryMedium,
    this.bgGray = FlowbiteColors.bgGray,

    // Brand Background Colors - Light Mode defaults
    this.bgBrandSofter = FlowbiteColors.bgBrandSofter,
    this.bgBrandSoft = FlowbiteColors.bgBrandSoft,
    this.bgBrand = FlowbiteColors.bgBrand,
    this.bgBrandMedium = FlowbiteColors.bgBrandMedium,
    this.bgBrandStrong = FlowbiteColors.bgBrandStrong,

    // Status Background Colors - Light Mode defaults
    this.bgSuccessSoft = FlowbiteColors.bgSuccessSoft,
    this.bgSuccess = FlowbiteColors.bgSuccess,
    this.bgSuccessMedium = FlowbiteColors.bgSuccessMedium,
    this.bgSuccessStrong = FlowbiteColors.bgSuccessStrong,

    this.bgDangerSoft = FlowbiteColors.bgDangerSoft,
    this.bgDanger = FlowbiteColors.bgDanger,
    this.bgDangerMedium = FlowbiteColors.bgDangerMedium,
    this.bgDangerStrong = FlowbiteColors.bgDangerStrong,

    this.bgWarningSoft = FlowbiteColors.bgWarningSoft,
    this.bgWarning = FlowbiteColors.bgWarning,
    this.bgWarningMedium = FlowbiteColors.bgWarningMedium,
    this.bgWarningStrong = FlowbiteColors.bgWarningStrong,

    this.bgDarkSoft = FlowbiteColors.bgDarkSoft,
    this.bgDark = FlowbiteColors.bgDark,
    this.bgDarkStrong = FlowbiteColors.bgDarkStrong,

    this.bgDisabled = FlowbiteColors.bgDisabled,

    // Additional Background Colors - Light Mode defaults
    this.bgPurple = FlowbiteColors.bgPurple,
    this.bgSky = FlowbiteColors.bgSky,
    this.bgTeal = FlowbiteColors.bgTeal,
    this.bgPink = FlowbiteColors.bgPink,
    this.bgCyan = FlowbiteColors.bgCyan,
    this.bgFuchsia = FlowbiteColors.bgFuchsia,
    this.bgIndigo = FlowbiteColors.bgIndigo,
    this.bgOrange = FlowbiteColors.bgOrange,

    // Border Colors - Light Mode defaults
    this.borderBuffer = FlowbiteColors.borderBuffer,
    this.borderBufferMedium = FlowbiteColors.borderBufferMedium,
    this.borderBufferStrong = FlowbiteColors.borderBufferStrong,
    this.borderMuted = FlowbiteColors.borderMuted,
    this.borderLightSubtle = FlowbiteColors.borderLightSubtle,
    this.borderLight = FlowbiteColors.borderLight,
    this.borderLightMedium = FlowbiteColors.borderLightMedium,
    this.borderDefaultSubtle = FlowbiteColors.borderDefaultSubtle,
    this.borderDefault = FlowbiteColors.borderDefault,
    this.borderDefaultMedium = FlowbiteColors.borderDefaultMedium,
    this.borderDefaultStrong = FlowbiteColors.borderDefaultStrong,
    this.borderSuccessSubtle = FlowbiteColors.borderSuccessSubtle,
    this.borderDangerSubtle = FlowbiteColors.borderDangerSubtle,
    this.borderWarningSubtle = FlowbiteColors.borderWarningSubtle,
    this.borderBrandSubtle = FlowbiteColors.borderBrandSubtle,
    this.borderBrandLight = FlowbiteColors.borderBrandLight,
    this.borderDarkSubtle = FlowbiteColors.borderDarkSubtle,
    this.borderDarkBackdrop = FlowbiteColors.borderDarkBackdrop,
  });

  @override
  ThemeExtension<CustomColorTheme> copyWith({
    // Foreground Colors
    Color? fgBody,
    Color? fgBodySubtle,
    Color? fgHeading,
    Color? fgBrandSubtle,
    Color? fgBrand,
    Color? fgBrandStrong,
    Color? fgSuccess,
    Color? fgSuccessStrong,
    Color? fgDanger,
    Color? fgDangerStrong,
    Color? fgWarningSubtle,
    Color? fgWarning,
    Color? fgYellow,
    Color? fgDisabled,
    Color? fgPurple,
    Color? fgCyan,
    Color? fgIndigo,
    Color? fgPink,
    Color? fgLime,

    // Neutral Background Colors
    Color? bgNeutralPrimarySoft,
    Color? bgNeutralPrimary,
    Color? bgNeutralPrimaryMedium,
    Color? bgNeutralPrimaryStrong,
    Color? bgNeutralSecondarySoft,
    Color? bgNeutralSecondary,
    Color? bgNeutralSecondaryMedium,
    Color? bgNeutralSecondaryStrong,
    Color? bgNeutralSecondaryStrongest,
    Color? bgNeutralTertiarySoft,
    Color? bgNeutralTertiary,
    Color? bgNeutralTertiaryMedium,
    Color? bgNeutralQuaternary,
    Color? bgNeutralQuaternaryMedium,
    Color? bgGray,

    // Brand Background Colors
    Color? bgBrandSofter,
    Color? bgBrandSoft,
    Color? bgBrand,
    Color? bgBrandMedium,
    Color? bgBrandStrong,

    // Status Background Colors
    Color? bgSuccessSoft,
    Color? bgSuccess,
    Color? bgSuccessMedium,
    Color? bgSuccessStrong,

    Color? bgDangerSoft,
    Color? bgDanger,
    Color? bgDangerMedium,
    Color? bgDangerStrong,

    Color? bgWarningSoft,
    Color? bgWarning,
    Color? bgWarningMedium,
    Color? bgWarningStrong,

    Color? bgDarkSoft,
    Color? bgDark,
    Color? bgDarkStrong,

    Color? bgDisabled,

    // Additional Background Colors
    Color? bgPurple,
    Color? bgSky,
    Color? bgTeal,
    Color? bgPink,
    Color? bgCyan,
    Color? bgFuchsia,
    Color? bgIndigo,
    Color? bgOrange,

    // Border Colors
    Color? borderBuffer,
    Color? borderBufferMedium,
    Color? borderBufferStrong,
    Color? borderMuted,
    Color? borderLightSubtle,
    Color? borderLight,
    Color? borderLightMedium,
    Color? borderDefaultSubtle,
    Color? borderDefault,
    Color? borderDefaultMedium,
    Color? borderDefaultStrong,
    Color? borderSuccessSubtle,
    Color? borderDangerSubtle,
    Color? borderWarningSubtle,
    Color? borderBrandSubtle,
    Color? borderBrandLight,
    Color? borderDarkSubtle,
    Color? borderDarkBackdrop,
  }) {
    return CustomColorTheme(
      // Foreground Colors
      fgBody: fgBody ?? this.fgBody,
      fgBodySubtle: fgBodySubtle ?? this.fgBodySubtle,
      fgHeading: fgHeading ?? this.fgHeading,
      fgBrandSubtle: fgBrandSubtle ?? this.fgBrandSubtle,
      fgBrand: fgBrand ?? this.fgBrand,
      fgBrandStrong: fgBrandStrong ?? this.fgBrandStrong,
      fgSuccess: fgSuccess ?? this.fgSuccess,
      fgSuccessStrong: fgSuccessStrong ?? this.fgSuccessStrong,
      fgDanger: fgDanger ?? this.fgDanger,
      fgDangerStrong: fgDangerStrong ?? this.fgDangerStrong,
      fgWarningSubtle: fgWarningSubtle ?? this.fgWarningSubtle,
      fgWarning: fgWarning ?? this.fgWarning,
      fgYellow: fgYellow ?? this.fgYellow,
      fgDisabled: fgDisabled ?? this.fgDisabled,
      fgPurple: fgPurple ?? this.fgPurple,
      fgCyan: fgCyan ?? this.fgCyan,
      fgIndigo: fgIndigo ?? this.fgIndigo,
      fgPink: fgPink ?? this.fgPink,
      fgLime: fgLime ?? this.fgLime,

      // Neutral Background Colors
      bgNeutralPrimarySoft: bgNeutralPrimarySoft ?? this.bgNeutralPrimarySoft,
      bgNeutralPrimary: bgNeutralPrimary ?? this.bgNeutralPrimary,
      bgNeutralPrimaryMedium:
          bgNeutralPrimaryMedium ?? this.bgNeutralPrimaryMedium,
      bgNeutralPrimaryStrong:
          bgNeutralPrimaryStrong ?? this.bgNeutralPrimaryStrong,
      bgNeutralSecondarySoft:
          bgNeutralSecondarySoft ?? this.bgNeutralSecondarySoft,
      bgNeutralSecondary: bgNeutralSecondary ?? this.bgNeutralSecondary,
      bgNeutralSecondaryMedium:
          bgNeutralSecondaryMedium ?? this.bgNeutralSecondaryMedium,
      bgNeutralSecondaryStrong:
          bgNeutralSecondaryStrong ?? this.bgNeutralSecondaryStrong,
      bgNeutralSecondaryStrongest:
          bgNeutralSecondaryStrongest ?? this.bgNeutralSecondaryStrongest,
      bgNeutralTertiarySoft:
          bgNeutralTertiarySoft ?? this.bgNeutralTertiarySoft,
      bgNeutralTertiary: bgNeutralTertiary ?? this.bgNeutralTertiary,
      bgNeutralTertiaryMedium:
          bgNeutralTertiaryMedium ?? this.bgNeutralTertiaryMedium,
      bgNeutralQuaternary: bgNeutralQuaternary ?? this.bgNeutralQuaternary,
      bgNeutralQuaternaryMedium:
          bgNeutralQuaternaryMedium ?? this.bgNeutralQuaternaryMedium,
      bgGray: bgGray ?? this.bgGray,

      // Brand Background Colors
      bgBrandSofter: bgBrandSofter ?? this.bgBrandSofter,
      bgBrandSoft: bgBrandSoft ?? this.bgBrandSoft,
      bgBrand: bgBrand ?? this.bgBrand,
      bgBrandMedium: bgBrandMedium ?? this.bgBrandMedium,
      bgBrandStrong: bgBrandStrong ?? this.bgBrandStrong,

      // Status Background Colors
      bgSuccessSoft: bgSuccessSoft ?? this.bgSuccessSoft,
      bgSuccess: bgSuccess ?? this.bgSuccess,
      bgSuccessMedium: bgSuccessMedium ?? this.bgSuccessMedium,
      bgSuccessStrong: bgSuccessStrong ?? this.bgSuccessStrong,

      bgDangerSoft: bgDangerSoft ?? this.bgDangerSoft,
      bgDanger: bgDanger ?? this.bgDanger,
      bgDangerMedium: bgDangerMedium ?? this.bgDangerMedium,
      bgDangerStrong: bgDangerStrong ?? this.bgDangerStrong,

      bgWarningSoft: bgWarningSoft ?? this.bgWarningSoft,
      bgWarning: bgWarning ?? this.bgWarning,
      bgWarningMedium: bgWarningMedium ?? this.bgWarningMedium,
      bgWarningStrong: bgWarningStrong ?? this.bgWarningStrong,

      bgDarkSoft: bgDarkSoft ?? this.bgDarkSoft,
      bgDark: bgDark ?? this.bgDark,
      bgDarkStrong: bgDarkStrong ?? this.bgDarkStrong,

      bgDisabled: bgDisabled ?? this.bgDisabled,

      // Additional Background Colors
      bgPurple: bgPurple ?? this.bgPurple,
      bgSky: bgSky ?? this.bgSky,
      bgTeal: bgTeal ?? this.bgTeal,
      bgPink: bgPink ?? this.bgPink,
      bgCyan: bgCyan ?? this.bgCyan,
      bgFuchsia: bgFuchsia ?? this.bgFuchsia,
      bgIndigo: bgIndigo ?? this.bgIndigo,
      bgOrange: bgOrange ?? this.bgOrange,

      // Border Colors
      borderBuffer: borderBuffer ?? this.borderBuffer,
      borderBufferMedium: borderBufferMedium ?? this.borderBufferMedium,
      borderBufferStrong: borderBufferStrong ?? this.borderBufferStrong,
      borderMuted: borderMuted ?? this.borderMuted,
      borderLightSubtle: borderLightSubtle ?? this.borderLightSubtle,
      borderLight: borderLight ?? this.borderLight,
      borderLightMedium: borderLightMedium ?? this.borderLightMedium,
      borderDefaultSubtle: borderDefaultSubtle ?? this.borderDefaultSubtle,
      borderDefault: borderDefault ?? this.borderDefault,
      borderDefaultMedium: borderDefaultMedium ?? this.borderDefaultMedium,
      borderDefaultStrong: borderDefaultStrong ?? this.borderDefaultStrong,
      borderSuccessSubtle: borderSuccessSubtle ?? this.borderSuccessSubtle,
      borderDangerSubtle: borderDangerSubtle ?? this.borderDangerSubtle,
      borderWarningSubtle: borderWarningSubtle ?? this.borderWarningSubtle,
      borderBrandSubtle: borderBrandSubtle ?? this.borderBrandSubtle,
      borderBrandLight: borderBrandLight ?? this.borderBrandLight,
      borderDarkSubtle: borderDarkSubtle ?? this.borderDarkSubtle,
      borderDarkBackdrop: borderDarkBackdrop ?? this.borderDarkBackdrop,
    );
  }

  @override
  ThemeExtension<CustomColorTheme> lerp(
    covariant ThemeExtension<CustomColorTheme>? other,
    double t,
  ) {
    if (other is! CustomColorTheme) {
      return this;
    }
    return CustomColorTheme(
      // Foreground Colors
      fgBody: Color.lerp(fgBody, other.fgBody, t) ?? fgBody,
      fgBodySubtle:
          Color.lerp(fgBodySubtle, other.fgBodySubtle, t) ?? fgBodySubtle,
      fgHeading: Color.lerp(fgHeading, other.fgHeading, t) ?? fgHeading,
      fgBrandSubtle:
          Color.lerp(fgBrandSubtle, other.fgBrandSubtle, t) ?? fgBrandSubtle,
      fgBrand: Color.lerp(fgBrand, other.fgBrand, t) ?? fgBrand,
      fgBrandStrong:
          Color.lerp(fgBrandStrong, other.fgBrandStrong, t) ?? fgBrandStrong,
      fgSuccess: Color.lerp(fgSuccess, other.fgSuccess, t) ?? fgSuccess,
      fgSuccessStrong:
          Color.lerp(fgSuccessStrong, other.fgSuccessStrong, t) ??
          fgSuccessStrong,
      fgDanger: Color.lerp(fgDanger, other.fgDanger, t) ?? fgDanger,
      fgDangerStrong:
          Color.lerp(fgDangerStrong, other.fgDangerStrong, t) ?? fgDangerStrong,
      fgWarningSubtle:
          Color.lerp(fgWarningSubtle, other.fgWarningSubtle, t) ??
          fgWarningSubtle,
      fgWarning: Color.lerp(fgWarning, other.fgWarning, t) ?? fgWarning,
      fgYellow: Color.lerp(fgYellow, other.fgYellow, t) ?? fgYellow,
      fgDisabled: Color.lerp(fgDisabled, other.fgDisabled, t) ?? fgDisabled,
      fgPurple: Color.lerp(fgPurple, other.fgPurple, t) ?? fgPurple,
      fgCyan: Color.lerp(fgCyan, other.fgCyan, t) ?? fgCyan,
      fgIndigo: Color.lerp(fgIndigo, other.fgIndigo, t) ?? fgIndigo,
      fgPink: Color.lerp(fgPink, other.fgPink, t) ?? fgPink,
      fgLime: Color.lerp(fgLime, other.fgLime, t) ?? fgLime,

      // Neutral Background Colors
      bgNeutralPrimarySoft:
          Color.lerp(bgNeutralPrimarySoft, other.bgNeutralPrimarySoft, t) ??
          bgNeutralPrimarySoft,
      bgNeutralPrimary:
          Color.lerp(bgNeutralPrimary, other.bgNeutralPrimary, t) ??
          bgNeutralPrimary,
      bgNeutralPrimaryMedium:
          Color.lerp(bgNeutralPrimaryMedium, other.bgNeutralPrimaryMedium, t) ??
          bgNeutralPrimaryMedium,
      bgNeutralPrimaryStrong:
          Color.lerp(bgNeutralPrimaryStrong, other.bgNeutralPrimaryStrong, t) ??
          bgNeutralPrimaryStrong,
      bgNeutralSecondarySoft:
          Color.lerp(bgNeutralSecondarySoft, other.bgNeutralSecondarySoft, t) ??
          bgNeutralSecondarySoft,
      bgNeutralSecondary:
          Color.lerp(bgNeutralSecondary, other.bgNeutralSecondary, t) ??
          bgNeutralSecondary,
      bgNeutralSecondaryMedium:
          Color.lerp(
            bgNeutralSecondaryMedium,
            other.bgNeutralSecondaryMedium,
            t,
          ) ??
          bgNeutralSecondaryMedium,
      bgNeutralSecondaryStrong:
          Color.lerp(
            bgNeutralSecondaryStrong,
            other.bgNeutralSecondaryStrong,
            t,
          ) ??
          bgNeutralSecondaryStrong,
      bgNeutralSecondaryStrongest:
          Color.lerp(
            bgNeutralSecondaryStrongest,
            other.bgNeutralSecondaryStrongest,
            t,
          ) ??
          bgNeutralSecondaryStrongest,
      bgNeutralTertiarySoft:
          Color.lerp(bgNeutralTertiarySoft, other.bgNeutralTertiarySoft, t) ??
          bgNeutralTertiarySoft,
      bgNeutralTertiary:
          Color.lerp(bgNeutralTertiary, other.bgNeutralTertiary, t) ??
          bgNeutralTertiary,
      bgNeutralTertiaryMedium:
          Color.lerp(
            bgNeutralTertiaryMedium,
            other.bgNeutralTertiaryMedium,
            t,
          ) ??
          bgNeutralTertiaryMedium,
      bgNeutralQuaternary:
          Color.lerp(bgNeutralQuaternary, other.bgNeutralQuaternary, t) ??
          bgNeutralQuaternary,
      bgNeutralQuaternaryMedium:
          Color.lerp(
            bgNeutralQuaternaryMedium,
            other.bgNeutralQuaternaryMedium,
            t,
          ) ??
          bgNeutralQuaternaryMedium,
      bgGray: Color.lerp(bgGray, other.bgGray, t) ?? bgGray,

      // Brand Background Colors
      bgBrandSofter:
          Color.lerp(bgBrandSofter, other.bgBrandSofter, t) ?? bgBrandSofter,
      bgBrandSoft: Color.lerp(bgBrandSoft, other.bgBrandSoft, t) ?? bgBrandSoft,
      bgBrand: Color.lerp(bgBrand, other.bgBrand, t) ?? bgBrand,
      bgBrandMedium:
          Color.lerp(bgBrandMedium, other.bgBrandMedium, t) ?? bgBrandMedium,
      bgBrandStrong:
          Color.lerp(bgBrandStrong, other.bgBrandStrong, t) ?? bgBrandStrong,

      // Status Background Colors
      bgSuccessSoft:
          Color.lerp(bgSuccessSoft, other.bgSuccessSoft, t) ?? bgSuccessSoft,
      bgSuccess: Color.lerp(bgSuccess, other.bgSuccess, t) ?? bgSuccess,
      bgSuccessMedium:
          Color.lerp(bgSuccessMedium, other.bgSuccessMedium, t) ??
          bgSuccessMedium,
      bgSuccessStrong:
          Color.lerp(bgSuccessStrong, other.bgSuccessStrong, t) ??
          bgSuccessStrong,

      bgDangerSoft:
          Color.lerp(bgDangerSoft, other.bgDangerSoft, t) ?? bgDangerSoft,
      bgDanger: Color.lerp(bgDanger, other.bgDanger, t) ?? bgDanger,
      bgDangerMedium:
          Color.lerp(bgDangerMedium, other.bgDangerMedium, t) ?? bgDangerMedium,
      bgDangerStrong:
          Color.lerp(bgDangerStrong, other.bgDangerStrong, t) ?? bgDangerStrong,

      bgWarningSoft:
          Color.lerp(bgWarningSoft, other.bgWarningSoft, t) ?? bgWarningSoft,
      bgWarning: Color.lerp(bgWarning, other.bgWarning, t) ?? bgWarning,
      bgWarningMedium:
          Color.lerp(bgWarningMedium, other.bgWarningMedium, t) ??
          bgWarningMedium,
      bgWarningStrong:
          Color.lerp(bgWarningStrong, other.bgWarningStrong, t) ??
          bgWarningStrong,

      bgDarkSoft: Color.lerp(bgDarkSoft, other.bgDarkSoft, t) ?? bgDarkSoft,
      bgDark: Color.lerp(bgDark, other.bgDark, t) ?? bgDark,
      bgDarkStrong:
          Color.lerp(bgDarkStrong, other.bgDarkStrong, t) ?? bgDarkStrong,

      bgDisabled: Color.lerp(bgDisabled, other.bgDisabled, t) ?? bgDisabled,

      // Additional Background Colors
      bgPurple: Color.lerp(bgPurple, other.bgPurple, t) ?? bgPurple,
      bgSky: Color.lerp(bgSky, other.bgSky, t) ?? bgSky,
      bgTeal: Color.lerp(bgTeal, other.bgTeal, t) ?? bgTeal,
      bgPink: Color.lerp(bgPink, other.bgPink, t) ?? bgPink,
      bgCyan: Color.lerp(bgCyan, other.bgCyan, t) ?? bgCyan,
      bgFuchsia: Color.lerp(bgFuchsia, other.bgFuchsia, t) ?? bgFuchsia,
      bgIndigo: Color.lerp(bgIndigo, other.bgIndigo, t) ?? bgIndigo,
      bgOrange: Color.lerp(bgOrange, other.bgOrange, t) ?? bgOrange,

      // Border Colors
      borderBuffer:
          Color.lerp(borderBuffer, other.borderBuffer, t) ?? borderBuffer,
      borderBufferMedium:
          Color.lerp(borderBufferMedium, other.borderBufferMedium, t) ??
          borderBufferMedium,
      borderBufferStrong:
          Color.lerp(borderBufferStrong, other.borderBufferStrong, t) ??
          borderBufferStrong,
      borderMuted: Color.lerp(borderMuted, other.borderMuted, t) ?? borderMuted,
      borderLightSubtle:
          Color.lerp(borderLightSubtle, other.borderLightSubtle, t) ??
          borderLightSubtle,
      borderLight: Color.lerp(borderLight, other.borderLight, t) ?? borderLight,
      borderLightMedium:
          Color.lerp(borderLightMedium, other.borderLightMedium, t) ??
          borderLightMedium,
      borderDefaultSubtle:
          Color.lerp(borderDefaultSubtle, other.borderDefaultSubtle, t) ??
          borderDefaultSubtle,
      borderDefault:
          Color.lerp(borderDefault, other.borderDefault, t) ?? borderDefault,
      borderDefaultMedium:
          Color.lerp(borderDefaultMedium, other.borderDefaultMedium, t) ??
          borderDefaultMedium,
      borderDefaultStrong:
          Color.lerp(borderDefaultStrong, other.borderDefaultStrong, t) ??
          borderDefaultStrong,
      borderSuccessSubtle:
          Color.lerp(borderSuccessSubtle, other.borderSuccessSubtle, t) ??
          borderSuccessSubtle,
      borderDangerSubtle:
          Color.lerp(borderDangerSubtle, other.borderDangerSubtle, t) ??
          borderDangerSubtle,
      borderWarningSubtle:
          Color.lerp(borderWarningSubtle, other.borderWarningSubtle, t) ??
          borderWarningSubtle,
      borderBrandSubtle:
          Color.lerp(borderBrandSubtle, other.borderBrandSubtle, t) ??
          borderBrandSubtle,
      borderBrandLight:
          Color.lerp(borderBrandLight, other.borderBrandLight, t) ??
          borderBrandLight,
      borderDarkSubtle:
          Color.lerp(borderDarkSubtle, other.borderDarkSubtle, t) ??
          borderDarkSubtle,
      borderDarkBackdrop:
          Color.lerp(borderDarkBackdrop, other.borderDarkBackdrop, t) ??
          borderDarkBackdrop,
    );
  }
}
