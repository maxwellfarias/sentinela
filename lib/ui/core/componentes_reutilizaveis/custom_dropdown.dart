// import 'package:flutter/material.dart';
// import 'package:w3_diploma/ui/core/extensions/build_context_extension.dart';

// class CustomDropdown<T> extends StatelessWidget {
//   final T? valorInicial;
//   final List<DropdownMenuItem<T>> itens;
//   final void Function(T) aoSelecionar;
//   final String label;
//   final String? Function(T?)? validador;

//   const CustomDropdown({
//     super.key,
//     this.valorInicial,
//     required this.label,
//     required this.aoSelecionar,
//     required this.itens,
//     this.validador,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return DropdownButtonFormField<T>(
//       value: valorInicial,
//       decoration: InputDecoration(
//         labelText: label,
//         prefixIcon: const Icon(Icons.map, size: 20),
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(8),
//           borderSide: BorderSide(color: context.customColorTheme.border),
//         ),
//         enabledBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(8),
//           borderSide: BorderSide(color: context.customColorTheme.border),
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(8),
//           borderSide: BorderSide(
//             color: context.customColorTheme.primary,
//             width: 2,
//           ),
//         ),
//         filled: true,
//         fillColor: context.customColorTheme.background,
//       ),
//       items: itens,
//       onChanged: (value) => aoSelecionar(value ?? itens.first.value as T),
//       validator: validador,
//     );
//   }
// }
