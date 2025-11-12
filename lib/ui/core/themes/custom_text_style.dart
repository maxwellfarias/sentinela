import 'package:flutter/material.dart';

@immutable
class CustomTextTheme {
  // Extra small text - 12px
  /// text-xs: fontSize: 12, lineHeight: 16
  final TextStyle textXs;
  /// text-xs font-medium: fontSize: 12, lineHeight: 16, fontWeight: 500
  final TextStyle textXsMedium;
  /// text-xs font-semibold: fontSize: 12, lineHeight: 16, fontWeight: 600
  final TextStyle textXsSemibold;
  /// text-xs font-bold: fontSize: 12, lineHeight: 16, fontWeight: 700
  final TextStyle textXsBold;

  // Small text - 14px
  /// text-sm: fontSize: 14, lineHeight: 20
  final TextStyle textSm;
  /// text-sm font-medium: fontSize: 14, lineHeight: 20, fontWeight: 500
  final TextStyle textSmMedium;
  /// text-sm font-semibold: fontSize: 14, lineHeight: 20, fontWeight: 600
  final TextStyle textSmSemibold;
  /// text-sm font-bold: fontSize: 14, lineHeight: 20, fontWeight: 700
  final TextStyle textSmBold;

  // Base text - 16px
  /// text-base: fontSize: 16, lineHeight: 24
  final TextStyle textBase;
  /// text-base font-medium: fontSize: 16, lineHeight: 24, fontWeight: 500
  final TextStyle textBaseMedium;
  /// text-base font-semibold: fontSize: 16, lineHeight: 24, fontWeight: 600
  final TextStyle textBaseSemibold;
  /// text-base font-bold: fontSize: 16, lineHeight: 24, fontWeight: 700
  final TextStyle textBaseBold;

  // Large text - 18px
  /// text-lg: fontSize: 18, lineHeight: 28
  final TextStyle textLg;
  /// text-lg font-medium: fontSize: 18, lineHeight: 28, fontWeight: 500
  final TextStyle textLgMedium;
  /// text-lg font-semibold: fontSize: 18, lineHeight: 28, fontWeight: 600
  final TextStyle textLgSemibold;
  /// text-lg font-bold: fontSize: 18, lineHeight: 28, fontWeight: 700
  final TextStyle textLgBold;

  // Extra large text - 20px
  /// text-xl: fontSize: 20, lineHeight: 28
  final TextStyle textXl;
  /// text-xl font-medium: fontSize: 20, lineHeight: 28, fontWeight: 500
  final TextStyle textXlMedium;
  /// text-xl font-semibold: fontSize: 20, lineHeight: 28, fontWeight: 600
  final TextStyle textXlSemibold;
  /// text-xl font-bold: fontSize: 20, lineHeight: 28, fontWeight: 700
  final TextStyle textXlBold;

  // 2X large text - 24px
  /// text-2xl: fontSize: 24, lineHeight: 32
  final TextStyle text2xl;
  /// text-2xl font-medium: fontSize: 24, lineHeight: 32, fontWeight: 500
  final TextStyle text2xlMedium;
  /// text-2xl font-semibold: fontSize: 24, lineHeight: 32, fontWeight: 600
  final TextStyle text2xlSemibold;
  /// text-2xl font-bold: fontSize: 24, lineHeight: 32, fontWeight: 700
  final TextStyle text2xlBold;

  // 3X large text - 30px
  /// text-3xl: fontSize: 30, lineHeight: 36
  final TextStyle text3xl;
  /// text-3xl font-medium: fontSize: 30, lineHeight: 36, fontWeight: 500
  final TextStyle text3xlMedium;
  /// text-3xl font-semibold: fontSize: 30, lineHeight: 36, fontWeight: 600
  final TextStyle text3xlSemibold;
  /// text-3xl font-bold: fontSize: 30, lineHeight: 36, fontWeight: 700
  final TextStyle text3xlBold;

  // 4X large text - 36px
  /// text-4xl: fontSize: 36, lineHeight: 40
  final TextStyle text4xl;
  /// text-4xl font-medium: fontSize: 36, lineHeight: 40, fontWeight: 500
  final TextStyle text4xlMedium;
  /// text-4xl font-semibold: fontSize: 36, lineHeight: 40, fontWeight: 600
  final TextStyle text4xlSemibold;
  /// text-4xl font-bold: fontSize: 36, lineHeight: 40, fontWeight: 700
  final TextStyle text4xlBold;

  // 5X large text - 48px
  /// text-5xl: fontSize: 48, lineHeight: 48
  final TextStyle text5xl;
  /// text-5xl font-medium: fontSize: 48, lineHeight: 48, fontWeight: 500
  final TextStyle text5xlMedium;
  /// text-5xl font-semibold: fontSize: 48, lineHeight: 48, fontWeight: 600
  final TextStyle text5xlSemibold;
  /// text-5xl font-bold: fontSize: 48, lineHeight: 48, fontWeight: 700
  final TextStyle text5xlBold;

  // 6X large text - 60px
  /// text-6xl: fontSize: 60, lineHeight: 60
  final TextStyle text6xl;
  /// text-6xl font-medium: fontSize: 60, lineHeight: 60, fontWeight: 500
  final TextStyle text6xlMedium;
  /// text-6xl font-semibold: fontSize: 60, lineHeight: 60, fontWeight: 600
  final TextStyle text6xlSemibold;
  /// text-6xl font-bold: fontSize: 60, lineHeight: 60, fontWeight: 700
  final TextStyle text6xlBold;

  // 7X large text - 72px
  /// text-7xl: fontSize: 72, lineHeight: 72
  final TextStyle text7xl;
  /// text-7xl font-medium: fontSize: 72, lineHeight: 72, fontWeight: 500
  final TextStyle text7xlMedium;
  /// text-7xl font-semibold: fontSize: 72, lineHeight: 72, fontWeight: 600
  final TextStyle text7xlSemibold;
  /// text-7xl font-bold: fontSize: 72, lineHeight: 72, fontWeight: 700
  final TextStyle text7xlBold;

  // 8X large text - 96px
  /// text-8xl: fontSize: 96, lineHeight: 96
  final TextStyle text8xl;
  /// text-8xl font-medium: fontSize: 96, lineHeight: 96, fontWeight: 500
  final TextStyle text8xlMedium;
  /// text-8xl font-semibold: fontSize: 96, lineHeight: 96, fontWeight: 600
  final TextStyle text8xlSemibold;
  /// text-8xl font-bold: fontSize: 96, lineHeight: 96, fontWeight: 700
  final TextStyle text8xlBold;

  // 9X large text - 128px
  /// text-9xl: fontSize: 128, lineHeight: 128
  final TextStyle text9xl;
  /// text-9xl font-medium: fontSize: 128, lineHeight: 128, fontWeight: 500
  final TextStyle text9xlMedium;
  /// text-9xl font-semibold: fontSize: 128, lineHeight: 128, fontWeight: 600
  final TextStyle text9xlSemibold;
  /// text-9xl font-bold: fontSize: 128, lineHeight: 128, fontWeight: 700
  final TextStyle text9xlBold;

  const CustomTextTheme({
    // text-xs variants (12px)
    this.textXs = const TextStyle(
      fontSize: 12,
      height: 16 / 12, // lineHeight: 16px
      fontWeight: FontWeight.w400,
    ),
    this.textXsMedium = const TextStyle(
      fontSize: 12,
      height: 16 / 12,
      fontWeight: FontWeight.w500,
    ),
    this.textXsSemibold = const TextStyle(
      fontSize: 12,
      height: 16 / 12,
      fontWeight: FontWeight.w600,
    ),
    this.textXsBold = const TextStyle(
      fontSize: 12,
      height: 16 / 12,
      fontWeight: FontWeight.w700,
    ),

    // text-sm variants (14px)
    this.textSm = const TextStyle(
      fontSize: 14,
      height: 20 / 14, // lineHeight: 20px
      fontWeight: FontWeight.w400,
    ),
    this.textSmMedium = const TextStyle(
      fontSize: 14,
      height: 20 / 14,
      fontWeight: FontWeight.w500,
    ),
    this.textSmSemibold = const TextStyle(
      fontSize: 14,
      height: 20 / 14,
      fontWeight: FontWeight.w600,
    ),
    this.textSmBold = const TextStyle(
      fontSize: 14,
      height: 20 / 14,
      fontWeight: FontWeight.w700,
    ),

    // text-base variants (16px)
    this.textBase = const TextStyle(
      fontSize: 16,
      height: 24 / 16, // lineHeight: 24px
      fontWeight: FontWeight.w400,
    ),
    this.textBaseMedium = const TextStyle(
      fontSize: 16,
      height: 24 / 16,
      fontWeight: FontWeight.w500,
    ),
    this.textBaseSemibold = const TextStyle(
      fontSize: 16,
      height: 24 / 16,
      fontWeight: FontWeight.w600,
    ),
    this.textBaseBold = const TextStyle(
      fontSize: 16,
      height: 24 / 16,
      fontWeight: FontWeight.w700,
    ),

    // text-lg variants (18px)
    this.textLg = const TextStyle(
      fontSize: 18,
      height: 28 / 18, // lineHeight: 28px
      fontWeight: FontWeight.w400,
    ),
    this.textLgMedium = const TextStyle(
      fontSize: 18,
      height: 28 / 18,
      fontWeight: FontWeight.w500,
    ),
    this.textLgSemibold = const TextStyle(
      fontSize: 18,
      height: 28 / 18,
      fontWeight: FontWeight.w600,
    ),
    this.textLgBold = const TextStyle(
      fontSize: 18,
      height: 28 / 18,
      fontWeight: FontWeight.w700,
    ),

    // text-xl variants (20px)
    this.textXl = const TextStyle(
      fontSize: 20,
      height: 28 / 20, // lineHeight: 28px
      fontWeight: FontWeight.w400,
    ),
    this.textXlMedium = const TextStyle(
      fontSize: 20,
      height: 28 / 20,
      fontWeight: FontWeight.w500,
    ),
    this.textXlSemibold = const TextStyle(
      fontSize: 20,
      height: 28 / 20,
      fontWeight: FontWeight.w600,
    ),
    this.textXlBold = const TextStyle(
      fontSize: 20,
      height: 28 / 20,
      fontWeight: FontWeight.w700,
    ),

    // text-2xl variants (24px)
    this.text2xl = const TextStyle(
      fontSize: 24,
      height: 32 / 24, // lineHeight: 32px
      fontWeight: FontWeight.w400,
    ),
    this.text2xlMedium = const TextStyle(
      fontSize: 24,
      height: 32 / 24,
      fontWeight: FontWeight.w500,
    ),
    this.text2xlSemibold = const TextStyle(
      fontSize: 24,
      height: 32 / 24,
      fontWeight: FontWeight.w600,
    ),
    this.text2xlBold = const TextStyle(
      fontSize: 24,
      height: 32 / 24,
      fontWeight: FontWeight.w700,
    ),

    // text-3xl variants (30px)
    this.text3xl = const TextStyle(
      fontSize: 30,
      height: 36 / 30, // lineHeight: 36px
      fontWeight: FontWeight.w400,
    ),
    this.text3xlMedium = const TextStyle(
      fontSize: 30,
      height: 36 / 30,
      fontWeight: FontWeight.w500,
    ),
    this.text3xlSemibold = const TextStyle(
      fontSize: 30,
      height: 36 / 30,
      fontWeight: FontWeight.w600,
    ),
    this.text3xlBold = const TextStyle(
      fontSize: 30,
      height: 36 / 30,
      fontWeight: FontWeight.w700,
    ),

    // text-4xl variants (36px)
    this.text4xl = const TextStyle(
      fontSize: 36,
      height: 40 / 36, // lineHeight: 40px
      fontWeight: FontWeight.w400,
    ),
    this.text4xlMedium = const TextStyle(
      fontSize: 36,
      height: 40 / 36,
      fontWeight: FontWeight.w500,
    ),
    this.text4xlSemibold = const TextStyle(
      fontSize: 36,
      height: 40 / 36,
      fontWeight: FontWeight.w600,
    ),
    this.text4xlBold = const TextStyle(
      fontSize: 36,
      height: 40 / 36,
      fontWeight: FontWeight.w700,
    ),

    // text-5xl variants (48px)
    this.text5xl = const TextStyle(
      fontSize: 48,
      height: 1, // lineHeight: 48px (1.0)
      fontWeight: FontWeight.w400,
    ),
    this.text5xlMedium = const TextStyle(
      fontSize: 48,
      height: 1,
      fontWeight: FontWeight.w500,
    ),
    this.text5xlSemibold = const TextStyle(
      fontSize: 48,
      height: 1,
      fontWeight: FontWeight.w600,
    ),
    this.text5xlBold = const TextStyle(
      fontSize: 48,
      height: 1,
      fontWeight: FontWeight.w700,
    ),

    // text-6xl variants (60px)
    this.text6xl = const TextStyle(
      fontSize: 60,
      height: 1, // lineHeight: 60px (1.0)
      fontWeight: FontWeight.w400,
    ),
    this.text6xlMedium = const TextStyle(
      fontSize: 60,
      height: 1,
      fontWeight: FontWeight.w500,
    ),
    this.text6xlSemibold = const TextStyle(
      fontSize: 60,
      height: 1,
      fontWeight: FontWeight.w600,
    ),
    this.text6xlBold = const TextStyle(
      fontSize: 60,
      height: 1,
      fontWeight: FontWeight.w700,
    ),

    // text-7xl variants (72px)
    this.text7xl = const TextStyle(
      fontSize: 72,
      height: 1, // lineHeight: 72px (1.0)
      fontWeight: FontWeight.w400,
    ),
    this.text7xlMedium = const TextStyle(
      fontSize: 72,
      height: 1,
      fontWeight: FontWeight.w500,
    ),
    this.text7xlSemibold = const TextStyle(
      fontSize: 72,
      height: 1,
      fontWeight: FontWeight.w600,
    ),
    this.text7xlBold = const TextStyle(
      fontSize: 72,
      height: 1,
      fontWeight: FontWeight.w700,
    ),

    // text-8xl variants (96px)
    this.text8xl = const TextStyle(
      fontSize: 96,
      height: 1, // lineHeight: 96px (1.0)
      fontWeight: FontWeight.w400,
    ),
    this.text8xlMedium = const TextStyle(
      fontSize: 96,
      height: 1,
      fontWeight: FontWeight.w500,
    ),
    this.text8xlSemibold = const TextStyle(
      fontSize: 96,
      height: 1,
      fontWeight: FontWeight.w600,
    ),
    this.text8xlBold = const TextStyle(
      fontSize: 96,
      height: 1,
      fontWeight: FontWeight.w700,
    ),

    // text-9xl variants (128px)
    this.text9xl = const TextStyle(
      fontSize: 128,
      height: 1, // lineHeight: 128px (1.0)
      fontWeight: FontWeight.w400,
    ),
    this.text9xlMedium = const TextStyle(
      fontSize: 128,
      height: 1,
      fontWeight: FontWeight.w500,
    ),
    this.text9xlSemibold = const TextStyle(
      fontSize: 128,
      height: 1,
      fontWeight: FontWeight.w600,
    ),
    this.text9xlBold = const TextStyle(
      fontSize: 128,
      height: 1,
      fontWeight: FontWeight.w700,
    ),
  });

  CustomTextTheme copyWith({
    TextStyle? textXs,
    TextStyle? textXsMedium,
    TextStyle? textXsSemibold,
    TextStyle? textXsBold,
    TextStyle? textSm,
    TextStyle? textSmMedium,
    TextStyle? textSmSemibold,
    TextStyle? textSmBold,
    TextStyle? textBase,
    TextStyle? textBaseMedium,
    TextStyle? textBaseSemibold,
    TextStyle? textBaseBold,
    TextStyle? textLg,
    TextStyle? textLgMedium,
    TextStyle? textLgSemibold,
    TextStyle? textLgBold,
    TextStyle? textXl,
    TextStyle? textXlMedium,
    TextStyle? textXlSemibold,
    TextStyle? textXlBold,
    TextStyle? text2xl,
    TextStyle? text2xlMedium,
    TextStyle? text2xlSemibold,
    TextStyle? text2xlBold,
    TextStyle? text3xl,
    TextStyle? text3xlMedium,
    TextStyle? text3xlSemibold,
    TextStyle? text3xlBold,
    TextStyle? text4xl,
    TextStyle? text4xlMedium,
    TextStyle? text4xlSemibold,
    TextStyle? text4xlBold,
    TextStyle? text5xl,
    TextStyle? text5xlMedium,
    TextStyle? text5xlSemibold,
    TextStyle? text5xlBold,
    TextStyle? text6xl,
    TextStyle? text6xlMedium,
    TextStyle? text6xlSemibold,
    TextStyle? text6xlBold,
    TextStyle? text7xl,
    TextStyle? text7xlMedium,
    TextStyle? text7xlSemibold,
    TextStyle? text7xlBold,
    TextStyle? text8xl,
    TextStyle? text8xlMedium,
    TextStyle? text8xlSemibold,
    TextStyle? text8xlBold,
    TextStyle? text9xl,
    TextStyle? text9xlMedium,
    TextStyle? text9xlSemibold,
    TextStyle? text9xlBold,
  }) {
    return CustomTextTheme(
      textXs: textXs ?? this.textXs,
      textXsMedium: textXsMedium ?? this.textXsMedium,
      textXsSemibold: textXsSemibold ?? this.textXsSemibold,
      textXsBold: textXsBold ?? this.textXsBold,
      textSm: textSm ?? this.textSm,
      textSmMedium: textSmMedium ?? this.textSmMedium,
      textSmSemibold: textSmSemibold ?? this.textSmSemibold,
      textSmBold: textSmBold ?? this.textSmBold,
      textBase: textBase ?? this.textBase,
      textBaseMedium: textBaseMedium ?? this.textBaseMedium,
      textBaseSemibold: textBaseSemibold ?? this.textBaseSemibold,
      textBaseBold: textBaseBold ?? this.textBaseBold,
      textLg: textLg ?? this.textLg,
      textLgMedium: textLgMedium ?? this.textLgMedium,
      textLgSemibold: textLgSemibold ?? this.textLgSemibold,
      textLgBold: textLgBold ?? this.textLgBold,
      textXl: textXl ?? this.textXl,
      textXlMedium: textXlMedium ?? this.textXlMedium,
      textXlSemibold: textXlSemibold ?? this.textXlSemibold,
      textXlBold: textXlBold ?? this.textXlBold,
      text2xl: text2xl ?? this.text2xl,
      text2xlMedium: text2xlMedium ?? this.text2xlMedium,
      text2xlSemibold: text2xlSemibold ?? this.text2xlSemibold,
      text2xlBold: text2xlBold ?? this.text2xlBold,
      text3xl: text3xl ?? this.text3xl,
      text3xlMedium: text3xlMedium ?? this.text3xlMedium,
      text3xlSemibold: text3xlSemibold ?? this.text3xlSemibold,
      text3xlBold: text3xlBold ?? this.text3xlBold,
      text4xl: text4xl ?? this.text4xl,
      text4xlMedium: text4xlMedium ?? this.text4xlMedium,
      text4xlSemibold: text4xlSemibold ?? this.text4xlSemibold,
      text4xlBold: text4xlBold ?? this.text4xlBold,
      text5xl: text5xl ?? this.text5xl,
      text5xlMedium: text5xlMedium ?? this.text5xlMedium,
      text5xlSemibold: text5xlSemibold ?? this.text5xlSemibold,
      text5xlBold: text5xlBold ?? this.text5xlBold,
      text6xl: text6xl ?? this.text6xl,
      text6xlMedium: text6xlMedium ?? this.text6xlMedium,
      text6xlSemibold: text6xlSemibold ?? this.text6xlSemibold,
      text6xlBold: text6xlBold ?? this.text6xlBold,
      text7xl: text7xl ?? this.text7xl,
      text7xlMedium: text7xlMedium ?? this.text7xlMedium,
      text7xlSemibold: text7xlSemibold ?? this.text7xlSemibold,
      text7xlBold: text7xlBold ?? this.text7xlBold,
      text8xl: text8xl ?? this.text8xl,
      text8xlMedium: text8xlMedium ?? this.text8xlMedium,
      text8xlSemibold: text8xlSemibold ?? this.text8xlSemibold,
      text8xlBold: text8xlBold ?? this.text8xlBold,
      text9xl: text9xl ?? this.text9xl,
      text9xlMedium: text9xlMedium ?? this.text9xlMedium,
      text9xlSemibold: text9xlSemibold ?? this.text9xlSemibold,
      text9xlBold: text9xlBold ?? this.text9xlBold,
    );
  }

  /// Método de extensão para fácil acesso aos estilos
  TextStyle getStyle({
    required String size,
    String weight = 'normal',
  }) {
    final sizeWeight = '$size${weight == 'normal' ? '' : weight.capitalize}';
    
    switch (sizeWeight) {
      case 'xs': return textXs;
      case 'xsMedium': return textXsMedium;
      case 'xsSemibold': return textXsSemibold;
      case 'xsBold': return textXsBold;
      case 'sm': return textSm;
      case 'smMedium': return textSmMedium;
      case 'smSemibold': return textSmSemibold;
      case 'smBold': return textSmBold;
      case 'base': return textBase;
      case 'baseMedium': return textBaseMedium;
      case 'baseSemibold': return textBaseSemibold;
      case 'baseBold': return textBaseBold;
      case 'lg': return textLg;
      case 'lgMedium': return textLgMedium;
      case 'lgSemibold': return textLgSemibold;
      case 'lgBold': return textLgBold;
      case 'xl': return textXl;
      case 'xlMedium': return textXlMedium;
      case 'xlSemibold': return textXlSemibold;
      case 'xlBold': return textXlBold;
      case '2xl': return text2xl;
      case '2xlMedium': return text2xlMedium;
      case '2xlSemibold': return text2xlSemibold;
      case '2xlBold': return text2xlBold;
      case '3xl': return text3xl;
      case '3xlMedium': return text3xlMedium;
      case '3xlSemibold': return text3xlSemibold;
      case '3xlBold': return text3xlBold;
      case '4xl': return text4xl;
      case '4xlMedium': return text4xlMedium;
      case '4xlSemibold': return text4xlSemibold;
      case '4xlBold': return text4xlBold;
      case '5xl': return text5xl;
      case '5xlMedium': return text5xlMedium;
      case '5xlSemibold': return text5xlSemibold;
      case '5xlBold': return text5xlBold;
      case '6xl': return text6xl;
      case '6xlMedium': return text6xlMedium;
      case '6xlSemibold': return text6xlSemibold;
      case '6xlBold': return text6xlBold;
      case '7xl': return text7xl;
      case '7xlMedium': return text7xlMedium;
      case '7xlSemibold': return text7xlSemibold;
      case '7xlBold': return text7xlBold;
      case '8xl': return text8xl;
      case '8xlMedium': return text8xlMedium;
      case '8xlSemibold': return text8xlSemibold;
      case '8xlBold': return text8xlBold;
      case '9xl': return text9xl;
      case '9xlMedium': return text9xlMedium;
      case '9xlSemibold': return text9xlSemibold;
      case '9xlBold': return text9xlBold;
      default: return textBase;
    }
  }
}

extension StringExtension on String {
  String get capitalize => isNotEmpty 
    ? '${this[0].toUpperCase()}${substring(1).toLowerCase()}' 
    : '';
}