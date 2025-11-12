import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

abstract final class AppColors {
  //grey (light mode)
  static const grey25 = Color(0xFFFDFDFD);
  static const grey50 = Color(0xFFFAFAFA);
  static const grey100 = Color(0xFFF5F5F5);
  static const grey200 = Color(0xFFE9EAEB);
  static const grey300 = Color(0xFFD5D7DA);
  static const grey400 = Color(0xFFA4A7AE);
  static const grey500 = Color(0xFF717680);
  static const grey600 = Color(0xFF535862);
  static const grey700 = Color(0xFF414651);
  static const grey800 = Color(0xFF252B37);
  static const grey900 = Color(0xFF181D27);
  static const grey950 = Color(0xFF0A0D12);

  //grey (dark mode)
  static const grey25Dark = Color(0xFFFAFAFA);
  static const grey50Dark = Color(0xFFF7F7F7);
  static const grey100Dark = Color(0xFFF0F0F1);
  static const grey200Dark = Color(0xFFECECED);
  static const grey300Dark = Color(0xFFCECFD2);
  static const grey400Dark = Color(0xFF94979C);
  static const grey500Dark = Color(0xFF85888E); 
  static const grey600Dark = Color(0xFF61656C);
  static const grey700Dark = Color(0xFF373A41);
  static const grey800Dark = Color(0xFF22262F);
  static const grey900Dark = Color(0xFF13161B);
  static const grey950Dark = Color(0xFF0C0E12);

  //Brand (primary)
  static const brand25 = Color(0xFFF5FAFF);
  static const brand50 = Color(0xFFEFF8FF);
  static const brand100 = Color(0xFFD1E9FF);
  static const brand200 = Color(0xFFB2DDFF);
  static const brand300 = Color(0xFF84CAFF);
  static const brand400 = Color(0xFF53B1FD);
  static const brand500 = Color(0xFF2E90FA);
  static const brand600 = Color(0xFF1570EF);
  static const brand700 = Color(0xFF175CD3);
  static const brand800 = Color(0xFF1849A9);
  static const brand900 = Color(0xFF194185);
  static const brand950 = Color(0xFF102A56);

  // Error palette
  static const error25 = Color(0xFFFFFBFA);
  static const error50 = Color(0xFFFEF3F2);
  static const error100 = Color(0xFFFEE4E2);
  static const error200 = Color(0xFFFECDCA);
  static const error300 = Color(0xFFFDA29B);
  static const error400 = Color(0xFFF97066);
  static const error500 = Color(0xFFF04438);
  static const error600 = Color(0xFFD92D20);
  static const error700 = Color(0xFFB42318);
  static const error800 = Color(0xFF912018);
  static const error900 = Color(0xFF7A271A);
  static const error950 = Color(0xFF55160C);

  // Warning palette
  static const warning25 = Color(0xFFFFFCF5);
  static const warning50 = Color(0xFFFFFAEB);
  static const warning100 = Color(0xFFFEF0C7);
  static const warning200 = Color(0xFFFEDF89);
  static const warning300 = Color(0xFFFEC84B);
  static const warning400 = Color(0xFFFDB022);
  static const warning500 = Color(0xFFF79009);
  static const warning600 = Color(0xFFDC6803);
  static const warning700 = Color(0xFFB54708);
  static const warning800 = Color(0xFF93370D);
  static const warning900 = Color(0xFF7A2E0E);
  static const warning950 = Color(0xFF4E1D09);

  // Success palette
  static const success25 = Color(0xFFF6FEF9);
  static const success50 = Color(0xFFECFDF3);
  static const success100 = Color(0xFFDCFAE6);
  static const success200 = Color(0xFFA9EFC5);
  static const success300 = Color(0xFF75E0A7);
  static const success400 = Color(0xFF47CD89);
  static const success500 = Color(0xFF17B26A);
  static const success600 = Color(0xFF079455);
  static const success700 = Color(0xFF067647);
  static const success800 = Color(0xFF085D3A);
  static const success900 = Color(0xFF074D31);
  static const success950 = Color(0xFF053321);

  //OLD COLORS
  static const primary = Color(0xFF1B84FF);
  static const primaryLight = Color(0xFFEFF6FF);
  static const primaryActive = Color(0xFF056EE9);

  static const coal100 = Color(0xFF15171C);
  static const coal200 = Color(0xFF13141A);
  static const coal300 = Color(0xFF111217);
  static const coal400 = Color(0xFF0F1014);
  static const coal500 = Color(0xFF0D0E12);
  static const coal600 = Color(0xFF0B0C10);

  static const lightgrey = Color(0xFFFEFEFE);
  static const black = Color(0xFF000000);
  static const white = Color(0xFFFFFFFF);
  static const coalCi50 = Color(0xFF18191F);

  //Primary Dark mode
  static const primaryDark = Color(0xFF006AE6);
  static const primaryLightDark = Color(0xFF172331);
  static const primaryActiveDark = Color(0xFF107EFF);

  //Success Light Mode
  static const success = Color(0xFF17C653);
  static const successLight = Color(0xFFEAFFF1);
  static const successClarity20 = Color(0xFFDAF4E1);
  static const successActive = Color(0xFF04B440);

  //Success Dark Mode
  static const successLightDark = Color(0xFF1F2623);
  static const successClarity20Dark = Color.fromARGB(204, 23, 198, 83);
  static const successActiveDark = Color(0xFF01BF73);
  static const successDark = Color(0xFF00A261);

  //Danger Light Mode
  static const danger = Color(0xFFF8285A);
  static const dangerClarity20 = Color(0xFFfdd3dd);
  static const dangerLight = Color(0xFFFFEEF3);

  //Danger Dark Mode
  static const dangerDark = Color(0xFFE42855);
  static const dangerClarity20Dark = Color(0xFFF9D4DC);
  static const dangerLightDark = Color(0xFF302024);

  //Secondary Light Mode
  static const secondaryClarity20 = Color(0xFFF9F9F9);

  //Ligth: Light Mode
  static const lightActive = Color(0xFFFCFCFC);

  //Light: Dark Mode
  static const lightActiveDark = Color(0xFF1F212A);

  //main colors
  static const onPrimary = Colors.white;
  static const onPrimaryDark = Colors.white;
  static const secondary = CupertinoColors.systemBlue;
  static const onSecondary = CupertinoColors.white;
  //error
  static const error = CupertinoColors.systemRed;
  static final errorDark = CupertinoColors.systemRed.darkColor;
  static const onError = CupertinoColors.white;
  //surface
  static const surface = CupertinoColors.systemBackground;
  static final surfaceDark = Color(0XFF0D0E12);
  static const onSurface = CupertinoColors.label;
  static final onSurfaceDark = CupertinoColors.label.darkColor;
  static const surfaceContainer = CupertinoColors.secondarySystemBackground;
  static final surfaceContainerDark = Color(0XFF111217);
  //grey
  static const border = Color(0XFF5b738b);
  //label
  static const secondaryLabel = CupertinoColors.secondaryLabel;
  static final secondaryLabelDark = CupertinoColors.secondaryLabel.darkColor;
}
