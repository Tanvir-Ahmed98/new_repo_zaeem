import 'package:flutter/material.dart';

class CustomeTextFormField extends StatelessWidget {
  final TextEditingController? controller;
  final bool readOnly;
  final bool isValidate;
  final String? hintText;
  final TextStyle? hintStyle;
  final String? labelText;
  final String? validatorText;
  final int? maxLines;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final Function(String)? onChanged;
  final Function(String)? onKeyBoardPressSubmitted;
  final Function()? onTap;
  final Widget? suffixIcon;
  final Color? filledColor;
  final Color? borderColor;
  final bool obscureText;
  final bool autofocus;
  final int? textMaxLength;
  final TextStyle? inputStyle;
  final TextStyle? labelStyle;
  const CustomeTextFormField({
    super.key,
    this.controller,
    this.onTap,
    this.readOnly = false,
    this.isValidate = true,
    this.hintText,
    this.hintStyle,
    this.labelText,
    this.validatorText,
    this.maxLines = 1,
    this.textMaxLength,
    this.keyboardType,
    this.textInputAction,
    this.onChanged,
    this.onKeyBoardPressSubmitted,
    this.suffixIcon,
    this.filledColor,
    this.borderColor,
    this.obscureText = false,
    this.autofocus = false,
    this.inputStyle,
    this.labelStyle,
  });
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autofocus: autofocus,
      controller: controller,
      onChanged: onChanged,
      onTap: onTap,
      maxLines: maxLines,
      maxLength: textMaxLength,
      style: inputStyle ??
          TextStyle(
              color: Colors.grey.shade600,
              fontSize: 12,
              fontWeight: FontWeight.normal),
      validator: isValidate
          ? (value) {
              if (value == null || value == "") {
                return validatorText;
              }
              return null;
            }
          : null,
      onFieldSubmitted: onKeyBoardPressSubmitted,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      readOnly: readOnly,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: labelStyle ??
            TextStyle(
                color: Colors.grey.shade600,
                fontSize: 12,
                fontWeight: FontWeight.normal),
        fillColor: filledColor ?? Colors.white,
        filled: true,
        hintText: hintText,
        hintStyle: hintStyle ??
            TextStyle(
                color: Colors.grey.shade600,
                fontSize: 12,
                fontWeight: FontWeight.normal),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide:
                BorderSide(color: borderColor ?? Colors.black12, width: 0.5)),
        suffixIcon: suffixIcon,
      ),
    );
  }
}
