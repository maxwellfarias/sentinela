import 'package:flutter/material.dart';

/// Flowbite Design System - Complete Color Tokens
/// Based on Flowbite/Tailwind CSS color palette converted to Flutter
abstract final class FlowbiteColors {
  // ============================================
  // 🎨 BASE COLOR PALETTE
  // ============================================

  // Gray (Cinza)
  static const gray50 = Color(0xFFF9FAFB);
  static const gray100 = Color(0xFFF3F4F6);
  static const gray200 = Color(0xFFE5E7EB);
  static const gray300 = Color(0xFFD1D5DB);
  static const gray400 = Color(0xFF9CA3AF);
  static const gray500 = Color(0xFF6B7280);
  static const gray600 = Color(0xFF4B5563);
  static const gray700 = Color(0xFF374151);
  static const gray800 = Color(0xFF1F2937);
  static const gray900 = Color(0xFF111827);
  static const gray950 = Color(0xFF030712);

  // Red (Vermelho)
  static const red50 = Color(0xFFFDF2F2);
  static const red100 = Color(0xFFFDE8E8);
  static const red200 = Color(0xFFFBD5D5);
  static const red300 = Color(0xFFF8B4B4);
  static const red400 = Color(0xFFF98080);
  static const red500 = Color(0xFFF05252);
  static const red600 = Color(0xFFE02424);
  static const red700 = Color(0xFFC81E1E);
  static const red800 = Color(0xFF9B1C1C);
  static const red900 = Color(0xFF771D1D);

  // Orange (Laranja)
  static const orange50 = Color(0xFFFFF8F1);
  static const orange100 = Color(0xFFFEECDC);
  static const orange200 = Color(0xFFFCD9BD);
  static const orange300 = Color(0xFFFDBA8C);
  static const orange400 = Color(0xFFFF8A4C);
  static const orange500 = Color(0xFFFF5A1F);
  static const orange600 = Color(0xFFD03801);
  static const orange700 = Color(0xFFB43403);
  static const orange800 = Color(0xFF8A2C0D);
  static const orange900 = Color(0xFF771D1D);

  // Yellow (Amarelo)
  static const yellow50 = Color(0xFFFDFDEA);
  static const yellow100 = Color(0xFFFDF6B2);
  static const yellow200 = Color(0xFFFCE96A);
  static const yellow300 = Color(0xFFFACA15);
  static const yellow400 = Color(0xFFE3A008);
  static const yellow500 = Color(0xFFC27803);
  static const yellow600 = Color(0xFF9F580A);
  static const yellow700 = Color(0xFF8E4B10);
  static const yellow800 = Color(0xFF723B13);
  static const yellow900 = Color(0xFF633112);

  // Green (Verde)
  static const green50 = Color(0xFFF3FAF7);
  static const green100 = Color(0xFFDEF7EC);
  static const green200 = Color(0xFFBCF0DA);
  static const green300 = Color(0xFF84E1BC);
  static const green400 = Color(0xFF31C48D);
  static const green500 = Color(0xFF0E9F6E);
  static const green600 = Color(0xFF057A55);
  static const green700 = Color(0xFF046C4E);
  static const green800 = Color(0xFF03543F);
  static const green900 = Color(0xFF014737);

  // Emerald (Esmeralda)
  static const emerald50 = Color(0xFFECFDF5);
  static const emerald100 = Color(0xFFD1FAE5);
  static const emerald200 = Color(0xFFA7F3D0);
  static const emerald300 = Color(0xFF6EE7B7);
  static const emerald400 = Color(0xFF34D399);
  static const emerald500 = Color(0xFF10B981);
  static const emerald600 = Color(0xFF059669);
  static const emerald700 = Color(0xFF047857);
  static const emerald800 = Color(0xFF065F46);
  static const emerald900 = Color(0xFF064E3B);
  static const emerald950 = Color(0xFF022C22);

  // Blue (Azul)
  static const blue50 = Color(0xFFEBF5FF);
  static const blue100 = Color(0xFFE1EFFE);
  static const blue200 = Color(0xFFC3DDFD);
  static const blue300 = Color(0xFFA4CAFE);
  static const blue400 = Color(0xFF76A9FA);
  static const blue500 = Color(0xFF3F83F8);
  static const blue600 = Color(0xFF1C64F2);
  static const blue700 = Color(0xFF1A56DB);
  static const blue800 = Color(0xFF1E429F);
  static const blue900 = Color(0xFF233876);
  static const blue950 = Color(0xFF172554);

  // Indigo (Índigo)
  static const indigo50 = Color(0xFFF0F5FF);
  static const indigo100 = Color(0xFFE5EDFF);
  static const indigo200 = Color(0xFFCDDBFE);
  static const indigo300 = Color(0xFFB4C6FC);
  static const indigo400 = Color(0xFF8DA2FB);
  static const indigo500 = Color(0xFF6875F5);
  static const indigo600 = Color(0xFF5850EC);
  static const indigo700 = Color(0xFF5145CD);
  static const indigo800 = Color(0xFF42389D);
  static const indigo900 = Color(0xFF362F78);

  // Purple (Roxo)
  static const purple50 = Color(0xFFF6F5FF);
  static const purple100 = Color(0xFFEDEBFE);
  static const purple200 = Color(0xFFDCD7FE);
  static const purple300 = Color(0xFFCABFFD);
  static const purple400 = Color(0xFFAC94FA);
  static const purple500 = Color(0xFF9061F9);
  static const purple600 = Color(0xFF7E3AF2);
  static const purple700 = Color(0xFF6C2BD9);
  static const purple800 = Color(0xFF5521B5);
  static const purple900 = Color(0xFF4A1D96);

  // Pink (Rosa)
  static const pink50 = Color(0xFFFDF2F8);
  static const pink100 = Color(0xFFFCE7F3);
  static const pink200 = Color(0xFFFBCFE8);
  static const pink300 = Color(0xFFF9A8D4);
  static const pink400 = Color(0xFFF472B6);
  static const pink500 = Color(0xFFEC4899);
  static const pink600 = Color(0xFFDB2777);
  static const pink700 = Color(0xFFBE185D);
  static const pink800 = Color(0xFF9D174D);
  static const pink900 = Color(0xFF831843);

  // Rose (Rosa/Vermelho)
  static const rose50 = Color(0xFFFFF1F2);
  static const rose100 = Color(0xFFFFE4E6);
  static const rose200 = Color(0xFFFECDD3);
  static const rose300 = Color(0xFFFDA4AF);
  static const rose400 = Color(0xFFFB7185);
  static const rose500 = Color(0xFFF43F5E);
  static const rose600 = Color(0xFFE11D48);
  static const rose700 = Color(0xFFBE123C);
  static const rose800 = Color(0xFF9F1239);
  static const rose900 = Color(0xFF881337);
  static const rose950 = Color(0xFF4C0519);

  // Cyan (Ciano)
  static const cyan50 = Color(0xFFECFEFF);
  static const cyan100 = Color(0xFFCFFAFE);
  static const cyan200 = Color(0xFFA5F3FC);
  static const cyan300 = Color(0xFF67E8F9);
  static const cyan400 = Color(0xFF22D3EE);
  static const cyan500 = Color(0xFF06B6D4);
  static const cyan600 = Color(0xFF0891B2);
  static const cyan700 = Color(0xFF0E7490);
  static const cyan800 = Color(0xFF155E75);
  static const cyan900 = Color(0xFF164E63);

  // Teal (Verde-azulado)
  static const teal50 = Color(0xFFEDFAFA);
  static const teal100 = Color(0xFFD5F5F6);
  static const teal200 = Color(0xFFAFECEF);
  static const teal300 = Color(0xFF7EDCE2);
  static const teal400 = Color(0xFF16BDCA);
  static const teal500 = Color(0xFF0694A2);
  static const teal600 = Color(0xFF047481);
  static const teal700 = Color(0xFF036672);
  static const teal800 = Color(0xFF05505C);
  static const teal900 = Color(0xFF014451);

  // Stone (Pedra) - Used for semantic text colors
  static const stone50 = Color(0xFFFAFAF9);
  static const stone100 = Color(0xFFF5F5F4);
  static const stone200 = Color(0xFFE7E5E4);
  static const stone300 = Color(0xFFD6D3D1);
  static const stone400 = Color(0xFFA8A29E);
  static const stone500 = Color(0xFF78716C);
  static const stone600 = Color(0xFF57534E);
  static const stone700 = Color(0xFF44403C);
  static const stone800 = Color(0xFF292524);
  static const stone900 = Color(0xFF1C1917);
  static const stone950 = Color(0xFF0C0A09);

  // Sky (Céu)
  static const sky400 = Color(0xFF38BDF8);
  static const sky500 = Color(0xFF0EA5E9);

  // Lime (Lima)
  static const lime400 = Color(0xFFA3E635);
  static const lime600 = Color(0xFF65A30D);

  // Fuchsia (Fúcsia)
  static const fuchsia400 = Color(0xFFE879F9);
  static const fuchsia600 = Color(0xFFC026D3);

  // White & Black
  static const white = Color(0xFFFFFFFF);
  static const black = Color(0xFF000000);

  // ============================================
  // 🔤 SEMANTIC TEXT COLORS (Foreground)
  // ============================================

  // Light Mode - Text Colors
  static const fgBody = stone600;
  static const fgBodySubtle = stone500;
  static const fgHeading = stone900;
  static const fgBrandSubtle = stone200;
  static const fgBrand = stone950;
  static const fgBrandStrong = stone900;
  static const fgSuccess = green700;
  static const fgSuccessStrong = green900;
  static const fgDanger = red700;
  static const fgDangerStrong = red900;
  static const fgWarningSubtle = orange600;
  static const fgWarning = orange900;
  static const fgYellow = yellow400;
  static const fgDisabled = stone400;
  static const fgPurple = purple600;
  static const fgCyan = cyan600;
  static const fgIndigo = indigo600;
  static const fgPink = pink600;
  static const fgLime = lime600;

  // Dark Mode - Text Colors
  static const fgBodyDark = stone300;
  static const fgBodySubtleDark = stone400;
  static const fgHeadingDark = white;
  static const fgBrandSubtleDark = stone700;
  static const fgBrandDark = stone50;
  static const fgBrandStrongDark = stone200;
  static const fgSuccessDark = green400;
  static const fgSuccessStrongDark = green300;
  static const fgDangerDark = red400;
  static const fgDangerStrongDark = red300;
  static const fgWarningSubtleDark = orange400;
  static const fgWarningDark = orange300;
  static const fgYellowDark = yellow300;
  static const fgDisabledDark = stone600;
  static const fgPurpleDark = purple400;
  static const fgCyanDark = cyan400;
  static const fgIndigoDark = indigo400;
  static const fgPinkDark = pink400;
  static const fgLimeDark = lime400;

  // ============================================
  // 🎨 SEMANTIC BACKGROUND COLORS
  // ============================================

  // Light Mode - Neutral Background Colors
  static const bgNeutralPrimarySoft = white;
  static const bgNeutralPrimary = white;
  static const bgNeutralPrimaryMedium = white;
  static const bgNeutralPrimaryStrong = white;
  static const bgNeutralSecondarySoft = gray50;
  static const bgNeutralSecondary = gray50;
  static const bgNeutralSecondaryMedium = gray50;
  static const bgNeutralSecondaryStrong = gray50;
  static const bgNeutralSecondaryStrongest = gray50;
  static const bgNeutralTertiarySoft = gray100;
  static const bgNeutralTertiary = gray100;
  static const bgNeutralTertiaryMedium = gray100;
  static const bgNeutralQuaternary = gray200;
  static const bgNeutralQuaternaryMedium = gray200;
  static const bgGray = gray300;

  // Light Mode - Brand Background Colors
  static const bgBrandSofter = blue50;
  static const bgBrandSoft = blue100;
  static const bgBrand = blue700;
  static const bgBrandMedium = blue200;
  static const bgBrandStrong = blue800;

  // Light Mode - Status Background Colors
  static const bgSuccessSoft = emerald50;
  static const bgSuccess = emerald700;
  static const bgSuccessMedium = emerald100;
  static const bgSuccessStrong = emerald800;

  static const bgDangerSoft = rose50;
  static const bgDanger = rose700;
  static const bgDangerMedium = rose100;
  static const bgDangerStrong = rose800;

  static const bgWarningSoft = orange50;
  static const bgWarning = orange500;
  static const bgWarningMedium = orange100;
  static const bgWarningStrong = orange700;

  static const bgDarkSoft = gray800;
  static const bgDark = gray800;
  static const bgDarkStrong = gray900;

  static const bgDisabled = gray100;

  // Light Mode - Additional Background Colors
  static const bgPurple = purple500;
  static const bgSky = sky500;
  static const bgTeal = teal600;
  static const bgPink = pink600;
  static const bgCyan = cyan500;
  static const bgFuchsia = fuchsia600;
  static const bgIndigo = indigo600;
  static const bgOrange = orange400;

  // Dark Mode - Neutral Background Colors
  static const bgNeutralPrimarySoftDark = gray900;
  static const bgNeutralPrimaryDark = gray900;
  static const bgNeutralPrimaryMediumDark = gray800;
  static const bgNeutralPrimaryStrongDark = gray950;
  static const bgNeutralSecondarySoftDark = gray800;
  static const bgNeutralSecondaryDark = gray800;
  static const bgNeutralSecondaryMediumDark = gray700;
  static const bgNeutralSecondaryStrongDark = gray900;
  static const bgNeutralSecondaryStrongestDark = gray950;
  static const bgNeutralTertiarySoftDark = gray700;
  static const bgNeutralTertiaryDark = gray700;
  static const bgNeutralTertiaryMediumDark = gray600;
  static const bgNeutralQuaternaryDark = gray600;
  static const bgNeutralQuaternaryMediumDark = gray500;
  static const bgGrayDark = gray600;

  // Dark Mode - Brand Background Colors
  static const bgBrandSofterDark = blue950;
  static const bgBrandSoftDark = blue900;
  static const bgBrandDark = blue600;
  static const bgBrandMediumDark = blue800;
  static const bgBrandStrongDark = blue300;

  // Dark Mode - Status Background Colors
  static const bgSuccessSoftDark = emerald950;
  static const bgSuccessDark = emerald600;
  static const bgSuccessMediumDark = emerald900;
  static const bgSuccessStrongDark = emerald500;

  static const bgDangerSoftDark = rose950;
  static const bgDangerDark = rose600;
  static const bgDangerMediumDark = rose900;
  static const bgDangerStrongDark = rose500;

  static const bgWarningSoftDark = orange950;
  static const bgWarningDark = orange500;
  static const bgWarningMediumDark = orange900;
  static const bgWarningStrongDark = orange400;

  static const bgDarkSoftDark = gray700;
  static const bgDarkDark = gray700;
  static const bgDarkStrongDark = gray600;

  static const bgDisabledDark = gray800;

  // Dark Mode - Additional Background Colors
  static const bgPurpleDark = purple400;
  static const bgSkyDark = sky400;
  static const bgTealDark = teal400;
  static const bgPinkDark = pink400;
  static const bgCyanDark = cyan400;
  static const bgFuchsiaDark = fuchsia400;
  static const bgIndigoDark = indigo400;
  static const bgOrangeDark = orange300;

  // Missing orange950 for dark mode
  static const orange950 = Color(0xFF431407);

  // ============================================
  // 🔲 SEMANTIC BORDER COLORS
  // ============================================

  // Light Mode - Border Colors
  static const borderBuffer = white;
  static const borderBufferMedium = white;
  static const borderBufferStrong = white;
  static const borderMuted = gray50;
  static const borderLightSubtle = gray100;
  static const borderLight = gray100;
  static const borderLightMedium = gray100;
  static const borderDefaultSubtle = gray200;
  static const borderDefault = gray200;
  static const borderDefaultMedium = gray200;
  static const borderDefaultStrong = gray200;
  static const borderSuccessSubtle = emerald200;
  static const borderDangerSubtle = rose200;
  static const borderWarningSubtle = orange200;
  static const borderBrandSubtle = blue200;
  static const borderBrandLight = blue600;
  static const borderDarkSubtle = gray800;
  static const borderDarkBackdrop = gray950;

  // Dark Mode - Border Colors
  static const borderBufferDark = gray900;
  static const borderBufferMediumDark = gray800;
  static const borderBufferStrongDark = gray950;
  static const borderMutedDark = gray800;
  static const borderLightSubtleDark = gray700;
  static const borderLightDark = gray700;
  static const borderLightMediumDark = gray600;
  static const borderDefaultSubtleDark = gray600;
  static const borderDefaultDark = gray600;
  static const borderDefaultMediumDark = gray500;
  static const borderDefaultStrongDark = gray600;
  static const borderSuccessSubtleDark = emerald800;
  static const borderDangerSubtleDark = rose800;
  static const borderWarningSubtleDark = orange800;
  static const borderBrandSubtleDark = blue800;
  static const borderBrandLightDark = blue400;
  static const borderDarkSubtleDark = gray700;
  static const borderDarkBackdropDark = gray950;

  // ============================================
  // 🎯 HELPER METHODS
  // ============================================

  /// Get foreground color based on brightness
  static Color getFgBody(Brightness brightness) =>
      brightness == Brightness.light ? fgBody : fgBodyDark;

  static Color getFgBodySubtle(Brightness brightness) =>
      brightness == Brightness.light ? fgBodySubtle : fgBodySubtleDark;

  static Color getFgHeading(Brightness brightness) =>
      brightness == Brightness.light ? fgHeading : fgHeadingDark;

  static Color getFgSuccess(Brightness brightness) =>
      brightness == Brightness.light ? fgSuccess : fgSuccessDark;

  static Color getFgDanger(Brightness brightness) =>
      brightness == Brightness.light ? fgDanger : fgDangerDark;

  static Color getFgWarning(Brightness brightness) =>
      brightness == Brightness.light ? fgWarning : fgWarningDark;

  static Color getFgDisabled(Brightness brightness) =>
      brightness == Brightness.light ? fgDisabled : fgDisabledDark;

  /// Get background color based on brightness
  static Color getBgNeutralPrimary(Brightness brightness) =>
      brightness == Brightness.light ? bgNeutralPrimary : bgNeutralPrimaryDark;

  static Color getBgNeutralSecondary(Brightness brightness) =>
      brightness == Brightness.light
      ? bgNeutralSecondary
      : bgNeutralSecondaryDark;

  static Color getBgNeutralTertiary(Brightness brightness) =>
      brightness == Brightness.light
      ? bgNeutralTertiary
      : bgNeutralTertiaryDark;

  static Color getBgBrand(Brightness brightness) =>
      brightness == Brightness.light ? bgBrand : bgBrandDark;

  static Color getBgSuccess(Brightness brightness) =>
      brightness == Brightness.light ? bgSuccess : bgSuccessDark;

  static Color getBgDanger(Brightness brightness) =>
      brightness == Brightness.light ? bgDanger : bgDangerDark;

  static Color getBgWarning(Brightness brightness) =>
      brightness == Brightness.light ? bgWarning : bgWarningDark;

  static Color getBgDisabled(Brightness brightness) =>
      brightness == Brightness.light ? bgDisabled : bgDisabledDark;

  /// Get border color based on brightness
  static Color getBorderDefault(Brightness brightness) =>
      brightness == Brightness.light ? borderDefault : borderDefaultDark;

  static Color getBorderLight(Brightness brightness) =>
      brightness == Brightness.light ? borderLight : borderLightDark;

  static Color getBorderBrandSubtle(Brightness brightness) =>
      brightness == Brightness.light
      ? borderBrandSubtle
      : borderBrandSubtleDark;

  static Color getBorderSuccessSubtle(Brightness brightness) =>
      brightness == Brightness.light
      ? borderSuccessSubtle
      : borderSuccessSubtleDark;

  static Color getBorderDangerSubtle(Brightness brightness) =>
      brightness == Brightness.light
      ? borderDangerSubtle
      : borderDangerSubtleDark;

  static Color getBorderWarningSubtle(Brightness brightness) =>
      brightness == Brightness.light
      ? borderWarningSubtle
      : borderWarningSubtleDark;
}
