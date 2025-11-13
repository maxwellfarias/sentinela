// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
// import 'package:w3_diploma/data/services/api_client/api_model/endereco_api_model.dart';
// import 'package:w3_diploma/ui/core/extensions/build_context_extension.dart';
// import 'package:w3_diploma/utils/command.dart';

// final class CepTextField extends StatefulWidget {
//   final TextEditingController controller;
//   final Command1<EnderecoApiModel, String> buscarCep;
//   final bool isRequired;
//   final bool comLabelExterna;
//   final VoidCallback? onBuscaIniciada;

//   const CepTextField({
//     super.key,
//     required this.controller,
//     required this.buscarCep,
//     this.isRequired = true,
//     this.comLabelExterna = false,
//     this.onBuscaIniciada,
//   });

//   @override
//   State<CepTextField> createState() => _CepTextFieldState();
// }

// class _CepTextFieldState extends State<CepTextField> {

//   _textField() => TextFormField(
//       controller: widget.controller,
//       onChanged: (value) {
//         if (value.length == 9) {
//           final cep = value.replaceAll('-', '');
//           widget.onBuscaIniciada?.call();
//           widget.buscarCep.execute(cep);
//         } 
//       },
//       decoration: InputDecoration(
//         labelText: widget.comLabelExterna ? null : 'CEP *',
//         hintText: 'Ex: 12345-678',
//         prefixIcon: ListenableBuilder(
//           listenable: widget.buscarCep,
//           builder: (context, child) {
//             if (widget.buscarCep.running) {
//               return const CupertinoActivityIndicator();
//             }
//             return Icon(
//               Icons.mail,
//             );
//           },
//         ),
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
//         errorBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(8),
//           borderSide: BorderSide(color: context.customColorTheme.destructive),
//         ),
//         filled: true,
//         fillColor: context.customColorTheme.background,
//       ),
//       keyboardType: TextInputType.number,
//       inputFormatters: [
//         MaskTextInputFormatter(
//           mask: '#####-###',
//           filter: {"#": RegExp(r'[0-9]')},
//         ),
//       ],
//       validator: widget.isRequired
//           ? (value) {
//               if (value == null || value.trim().isEmpty) {
//                 return 'Este campo é obrigatório';
//               }

//               final cepRegex = RegExp(r'^\d{5}-?\d{3}$');
//               if (!cepRegex.hasMatch(value)) {
//                 return 'CEP inválido.';
//               }
//               return null;
//             }
//           : null,
//     );



//   @override
//   Widget build(BuildContext context) {
//     if (widget.comLabelExterna) {
//       return Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           SelectableText('CEP *',
//           style: context.customTextTheme.textSmMedium.copyWith(
//             color: context.customColorTheme.cardForeground,
//           ),
//         ),
//         const SizedBox(height: 4),
//           _textField(),
//         ],
//       );
//     } else {
//       return _textField();
//     }  
//   }
// }
