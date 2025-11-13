import 'package:flutter/material.dart';
import 'package:sentinela/ui/core/themes/new_colors.dart';

class NewAppColorTheme extends ThemeExtension<NewAppColorTheme> {
  // Base colors
  final Color background;
  final Color foreground;
  
  // Primary colors
  final Color primary;
  final Color primaryForeground;
  final Color primaryLight;
  final Color primaryShade;
  
  // Success colors
  final Color success;
  final Color successForeground;
  final Color successLight;
  
  // Warning colors
  final Color warning;
  final Color warningForeground;
  
  // Error/Destructive colors
  final Color destructive;
  final Color destructiveForeground;
  
  // Card colors
  final Color card;
  final Color cardForeground;
  
  // Popover colors
  final Color popover;
  final Color popoverForeground;
  
  // Secondary colors
  final Color secondary;
  final Color secondaryForeground;
  
  // Muted colors
  final Color muted;
  final Color mutedForeground;
  
  // Accent colors
  final Color accent;
  final Color accentForeground;
  
  // Border & Input
  final Color border;
  final Color input;
  final Color ring;
  
  // Sidebar colors
  final Color sidebarBackground;
  final Color sidebarForeground;
  final Color sidebarPrimary;
  final Color sidebarPrimaryForeground;
  final Color sidebarAccent;
  final Color sidebarAccentForeground;
  final Color sidebarBorder;
  final Color sidebarRing;
  
  // Shadow colors
  final Color shadowElegant;
  final Color shadowCard;

  const NewAppColorTheme({
    this.background = NewAppColors.background,
    this.foreground = NewAppColors.foreground,
    this.primary = NewAppColors.primary,
    this.primaryForeground = NewAppColors.primaryForeground,
    this.primaryLight = NewAppColors.primaryLight,
    this.primaryShade = NewAppColors.primaryShade,
    this.success = NewAppColors.success,
    this.successForeground = NewAppColors.successForeground,
    this.successLight = NewAppColors.successLight,
    this.warning = NewAppColors.warning,
    this.warningForeground = NewAppColors.warningForeground,
    this.destructive = NewAppColors.destructive,
    this.destructiveForeground = NewAppColors.destructiveForeground,
    this.card = NewAppColors.card,
    this.cardForeground = NewAppColors.cardForeground,
    this.popover = NewAppColors.popover,
    this.popoverForeground = NewAppColors.popoverForeground,
    this.secondary = NewAppColors.secondary,
    this.secondaryForeground = NewAppColors.secondaryForeground,
    this.muted = NewAppColors.muted,
    this.mutedForeground = NewAppColors.mutedForeground,
    this.accent = NewAppColors.accent,
    this.accentForeground = NewAppColors.accentForeground,
    this.border = NewAppColors.border,
    this.input = NewAppColors.input,
    this.ring = NewAppColors.ring,
    this.sidebarBackground = NewAppColors.sidebarBackground,
    this.sidebarForeground = NewAppColors.sidebarForeground,
    this.sidebarPrimary = NewAppColors.sidebarPrimary,
    this.sidebarPrimaryForeground = NewAppColors.sidebarPrimaryForeground,
    this.sidebarAccent = NewAppColors.sidebarAccent,
    this.sidebarAccentForeground = NewAppColors.sidebarAccentForeground,
    this.sidebarBorder = NewAppColors.sidebarBorder,
    this.sidebarRing = NewAppColors.sidebarRing,
    this.shadowElegant = NewAppColors.shadowElegant,
    this.shadowCard = NewAppColors.shadowCard,
  });

  @override
  ThemeExtension<NewAppColorTheme> copyWith({
    Color? background,
    Color? foreground,
    Color? primary,
    Color? primaryForeground,
    Color? primaryLight,
    Color? primaryShade,
    Color? success,
    Color? successForeground,
    Color? successLight,
    Color? warning,
    Color? warningForeground,
    Color? destructive,
    Color? destructiveForeground,
    Color? card,
    Color? cardForeground,
    Color? popover,
    Color? popoverForeground,
    Color? secondary,
    Color? secondaryForeground,
    Color? muted,
    Color? mutedForeground,
    Color? accent,
    Color? accentForeground,
    Color? border,
    Color? input,
    Color? ring,
    Color? sidebarBackground,
    Color? sidebarForeground,
    Color? sidebarPrimary,
    Color? sidebarPrimaryForeground,
    Color? sidebarAccent,
    Color? sidebarAccentForeground,
    Color? sidebarBorder,
    Color? sidebarRing,
    Color? shadowElegant,
    Color? shadowCard,
  }) {
    return NewAppColorTheme(
      background: background ?? this.background,
      foreground: foreground ?? this.foreground,
      primary: primary ?? this.primary,
      primaryForeground: primaryForeground ?? this.primaryForeground,
      primaryLight: primaryLight ?? this.primaryLight,
      primaryShade: primaryShade ?? this.primaryShade,
      success: success ?? this.success,
      successForeground: successForeground ?? this.successForeground,
      successLight: successLight ?? this.successLight,
      warning: warning ?? this.warning,
      warningForeground: warningForeground ?? this.warningForeground,
      destructive: destructive ?? this.destructive,
      destructiveForeground: destructiveForeground ?? this.destructiveForeground,
      card: card ?? this.card,
      cardForeground: cardForeground ?? this.cardForeground,
      popover: popover ?? this.popover,
      popoverForeground: popoverForeground ?? this.popoverForeground,
      secondary: secondary ?? this.secondary,
      secondaryForeground: secondaryForeground ?? this.secondaryForeground,
      muted: muted ?? this.muted,
      mutedForeground: mutedForeground ?? this.mutedForeground,
      accent: accent ?? this.accent,
      accentForeground: accentForeground ?? this.accentForeground,
      border: border ?? this.border,
      input: input ?? this.input,
      ring: ring ?? this.ring,
      sidebarBackground: sidebarBackground ?? this.sidebarBackground,
      sidebarForeground: sidebarForeground ?? this.sidebarForeground,
      sidebarPrimary: sidebarPrimary ?? this.sidebarPrimary,
      sidebarPrimaryForeground: sidebarPrimaryForeground ?? this.sidebarPrimaryForeground,
      sidebarAccent: sidebarAccent ?? this.sidebarAccent,
      sidebarAccentForeground: sidebarAccentForeground ?? this.sidebarAccentForeground,
      sidebarBorder: sidebarBorder ?? this.sidebarBorder,
      sidebarRing: sidebarRing ?? this.sidebarRing,
      shadowElegant: shadowElegant ?? this.shadowElegant,
      shadowCard: shadowCard ?? this.shadowCard,
    );
  }

  @override
  ThemeExtension<NewAppColorTheme> lerp(
    covariant ThemeExtension<NewAppColorTheme>? other,
    double t,
  ) {
    if (other is! NewAppColorTheme) {
      return this;
    }
    return NewAppColorTheme(
      background: Color.lerp(background, other.background, t) ?? background,
      foreground: Color.lerp(foreground, other.foreground, t) ?? foreground,
      primary: Color.lerp(primary, other.primary, t) ?? primary,
      primaryForeground: Color.lerp(primaryForeground, other.primaryForeground, t) ?? primaryForeground,
      primaryLight: Color.lerp(primaryLight, other.primaryLight, t) ?? primaryLight,
      primaryShade: Color.lerp(primaryShade, other.primaryShade, t) ?? primaryShade,
      success: Color.lerp(success, other.success, t) ?? success,
      successForeground: Color.lerp(successForeground, other.successForeground, t) ?? successForeground,
      successLight: Color.lerp(successLight, other.successLight, t) ?? successLight,
      warning: Color.lerp(warning, other.warning, t) ?? warning,
      warningForeground: Color.lerp(warningForeground, other.warningForeground, t) ?? warningForeground,
      destructive: Color.lerp(destructive, other.destructive, t) ?? destructive,
      destructiveForeground: Color.lerp(destructiveForeground, other.destructiveForeground, t) ?? destructiveForeground,
      card: Color.lerp(card, other.card, t) ?? card,
      cardForeground: Color.lerp(cardForeground, other.cardForeground, t) ?? cardForeground,
      popover: Color.lerp(popover, other.popover, t) ?? popover,
      popoverForeground: Color.lerp(popoverForeground, other.popoverForeground, t) ?? popoverForeground,
      secondary: Color.lerp(secondary, other.secondary, t) ?? secondary,
      secondaryForeground: Color.lerp(secondaryForeground, other.secondaryForeground, t) ?? secondaryForeground,
      muted: Color.lerp(muted, other.muted, t) ?? muted,
      mutedForeground: Color.lerp(mutedForeground, other.mutedForeground, t) ?? mutedForeground,
      accent: Color.lerp(accent, other.accent, t) ?? accent,
      accentForeground: Color.lerp(accentForeground, other.accentForeground, t) ?? accentForeground,
      border: Color.lerp(border, other.border, t) ?? border,
      input: Color.lerp(input, other.input, t) ?? input,
      ring: Color.lerp(ring, other.ring, t) ?? ring,
      sidebarBackground: Color.lerp(sidebarBackground, other.sidebarBackground, t) ?? sidebarBackground,
      sidebarForeground: Color.lerp(sidebarForeground, other.sidebarForeground, t) ?? sidebarForeground,
      sidebarPrimary: Color.lerp(sidebarPrimary, other.sidebarPrimary, t) ?? sidebarPrimary,
      sidebarPrimaryForeground: Color.lerp(sidebarPrimaryForeground, other.sidebarPrimaryForeground, t) ?? sidebarPrimaryForeground,
      sidebarAccent: Color.lerp(sidebarAccent, other.sidebarAccent, t) ?? sidebarAccent,
      sidebarAccentForeground: Color.lerp(sidebarAccentForeground, other.sidebarAccentForeground, t) ?? sidebarAccentForeground,
      sidebarBorder: Color.lerp(sidebarBorder, other.sidebarBorder, t) ?? sidebarBorder,
      sidebarRing: Color.lerp(sidebarRing, other.sidebarRing, t) ?? sidebarRing,
      shadowElegant: Color.lerp(shadowElegant, other.shadowElegant, t) ?? shadowElegant,
      shadowCard: Color.lerp(shadowCard, other.shadowCard, t) ?? shadowCard,
    );
  }
}

