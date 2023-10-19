import 'package:contact/UI_Helper/UIHelper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final String? errorText;
  final int? maxLength;
  final String? helperText;
  TextInputType? keyboardType;
  List<TextInputFormatter>? inputFormatters;

  CustomTextField({
    super.key,
    required this.controller,
    required this.labelText,
    this.errorText,
    this.maxLength,
    this.helperText,
    this.keyboardType,
    this.inputFormatters,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        errorText: errorText,
        helperText: helperText,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 10.0, vertical: 16.0),
        border: const OutlineInputBorder(),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: MyColors.green, width: 2.0)),
        labelStyle: TextStyle(
          color: MyColors.green,
          fontSize: 15.0,
        ),
        floatingLabelStyle: TextStyle(
          color: MyColors.green,
          fontSize: 15.0,
        ),
      ),
      inputFormatters: inputFormatters,
      maxLength: maxLength,
      cursorColor: MyColors.green,
      cursorRadius: const Radius.circular(50.0),
      cursorHeight: 20.0,
      style: const TextStyle(
        color: Colors.black,
        fontSize: 17.0,
      ),
      maxLines: 1,
      scrollPhysics: const BouncingScrollPhysics(),
      keyboardType: keyboardType,
      textCapitalization: TextCapitalization.sentences,
      textInputAction: TextInputAction.next,
      autofocus: false,
    );
  }
}
