import 'package:flutter/material.dart';
import 'package:sentinela/ui/core/extensions/build_context_extension.dart';


class ResponsiveRow extends StatelessWidget {
  final Widget child1;
  final Widget child2;
  final int flex1;
  final int flex2;
  const ResponsiveRow({
    super.key,
    required this.child1,
    required this.child2,
    this.flex1 = 1,
    this.flex2 = 1,
  });

  @override
  Widget build(BuildContext context) {
    if (context.dimens.isMobile) {
      return Column(
        spacing: 16,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          child1,
          child2,
        ],
      );
    } else {
      return Row(
        spacing: 16,
        children: [
          Expanded(flex: flex1, child: child1),
          Expanded(flex: flex2, child: child2),
        ],
      );
    }
  }
}