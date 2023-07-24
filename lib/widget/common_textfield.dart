import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyTextField extends StatelessWidget {
  final int maxLine;
  final String lableText;
  final bool isPassword;
  final bool isEmail;
  final String? Function(String?)? onSaved;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  // final <FilteringTextInputFormatter>? textInputFormatter;

  final TextEditingController? controller;

  const MyTextField({
    Key? key,
    required this.controller,
    required this.onSaved,
    required this.lableText,
    this.validator,
    this.isPassword = false,
    this.isEmail = false,
    this.maxLine = 1,
    this.keyboardType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      maxLines: maxLine,
      validator: validator,
      onSaved: onSaved,
      decoration: InputDecoration(
          labelText: lableText,
          // hintText: hintText,
          hintStyle: TextStyle(
            color: Colors.grey.withOpacity(0.7),
          ),
          contentPadding: const EdgeInsets.all(8),
          labelStyle:
              TextStyle(color: Colors.grey.withOpacity(0.9), fontSize: 14)
          // border: InputBorder.none,
          // fillColor: Colors.grey[200],
          // filled: true
          ),
      obscureText: isPassword ? true : false,
      keyboardType: keyboardType,
    );
  }
}
