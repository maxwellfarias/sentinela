import 'package:flutter/material.dart';
import 'package:sentinela/ui/core/extensions/new_color_extension.dart';
import 'package:sentinela/ui/core/themes/custom_text_style.dart';
import 'package:sentinela/ui/core/themes/dimens.dart';

extension CustomTextThemeContextExtension on BuildContext {
  TextTheme get textTheme => Theme.of(this).textTheme; 
  NewAppColorTheme get customColorTheme => Theme.of(this).extension<NewAppColorTheme>() ?? const NewAppColorTheme();
  ColorScheme get colorTheme => Theme.of(this).colorScheme;
  CustomTextTheme get customTextTheme => const CustomTextTheme();
  Dimens get dimens => Dimens.of(this);
  Size get screenSize => MediaQuery.sizeOf(this);
}
