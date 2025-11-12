import 'package:flutter/material.dart';
import 'package:w3_diploma/ui/core/themes/custom_text_style.dart';
import 'package:w3_diploma/ui/core/themes/dimens.dart';
import 'package:w3_diploma/ui/core/extensions/new_color_extension.dart';

extension CustomTextThemeContextExtension on BuildContext {
  TextTheme get textTheme => Theme.of(this).textTheme; 
  NewAppColorTheme get customColorTheme => Theme.of(this).extension<NewAppColorTheme>() ?? const NewAppColorTheme();
  ColorScheme get colorTheme => Theme.of(this).colorScheme;
  CustomTextTheme get customTextTheme => const CustomTextTheme();
  Dimens get dimens => Dimens.of(this);
  Size get screenSize => MediaQuery.sizeOf(this);
}