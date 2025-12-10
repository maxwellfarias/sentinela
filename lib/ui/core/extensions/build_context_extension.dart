import 'package:flutter/material.dart';
import 'package:sentinela/ui/core/extensions/custom_color_theme_extension.dart';
import 'package:sentinela/ui/core/themes/custom_text_style.dart';
import 'package:sentinela/ui/core/themes/dimens.dart';

extension CustomTextThemeContextExtension on BuildContext {
  CustomColorTheme get colorTheme => Theme.of(this).extension<CustomColorTheme>() ?? const CustomColorTheme();
  TextTheme get textTheme => Theme.of(this).textTheme;
  CustomTextTheme get customTextTheme => const CustomTextTheme();
  Dimens get dimens => Dimens.of(this);
  Size get screenSize => MediaQuery.sizeOf(this);
}
