import 'package:flutter/material.dart';

abstract final class Dimens {
  const Dimens();

  /// Espaçamento horizontal geral usado para separar itens da interface do usuário
  static const paddingHorizontal = 16.0;

  /// Espaçamento vertical geral usado para separar itens da interface do usuário
  static const paddingVertical = 16.0;

  /// Espaçamento horizontal para as bordas da tela
  double get paddingScreenHorizontal;

  /// Espaçamento vertical para as bordas da tela
  double get paddingScreenVertical;

  /// Verifica se as dimensões são para dispositivos móveis
  bool get isMobile => this is _DimensMobile;


  /// Espaçamento horizontal simétrico para as bordas da tela
  EdgeInsets get edgeInsetsScreenHorizontal =>
      EdgeInsets.symmetric(horizontal: paddingScreenHorizontal);

  /// Espaçamento simétrico para as bordas da tela
  EdgeInsets get edgeInsetsScreenSymmetric => EdgeInsets.symmetric(
      horizontal: paddingScreenHorizontal, vertical: paddingScreenVertical);

  static const Dimens desktop = _DimensDesktop();
  static const Dimens mobile = _DimensMobile();

  /// Obtém a definição de dimensões com base no tamanho da tela
  factory Dimens.of(BuildContext context) =>
      switch (MediaQuery.sizeOf(context).width) {
        >= 600 => desktop,
        _ => mobile,
      };
}

/// Dimensões para dispositivos móveis
final class _DimensMobile extends Dimens {
  @override
  final double paddingScreenHorizontal = Dimens.paddingHorizontal;

  @override
  final double paddingScreenVertical = Dimens.paddingVertical;


  const _DimensMobile();
}

/// Dimensões para Desktop/Web
final class _DimensDesktop extends Dimens {
  @override
  final double paddingScreenHorizontal = 32.0;

  @override
  final double paddingScreenVertical = 32.0;


  const _DimensDesktop();
}