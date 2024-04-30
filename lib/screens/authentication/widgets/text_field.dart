import 'package:flutter/material.dart';
import 'package:homieeee/utils/constants/constants.dart';

class AuthTextFormField extends StatefulWidget {
  final TextEditingController? controller;
  final String? prefixIcon;
  final String? suffixIcon;
  final String? hintText;
  final TextInputAction? textInputAction;
  final TextInputType? keyboardType;
  final bool? isPassSecure;
  final int? maxLines;
  final String? Function(String?)? validator;
  const AuthTextFormField(
      {super.key,
      this.textInputAction = TextInputAction.next,
      this.prefixIcon,
      this.suffixIcon,
      this.hintText,
      this.isPassSecure,
      this.maxLines,
      this.keyboardType,
      this.controller,
      required this.validator});

  @override
  State<AuthTextFormField> createState() => _AuthTextFormFieldState();
}

class _AuthTextFormFieldState extends State<AuthTextFormField> {
  bool? _isPassSecure;

  @override
  void initState() {
    super.initState();
    _isPassSecure = widget.isPassSecure;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: colorF9,
        borderRadius: borderRadius10,
      ),
      child: TextFormField(
        controller: widget.controller,
        validator: widget.validator,
        maxLines: widget.maxLines,
        cursorColor: black,
        style: blackRegular16,
        obscureText: _isPassSecure ?? false,
        textInputAction: widget.textInputAction,
        keyboardType: widget.keyboardType,
        decoration: InputDecoration(
          hintText: widget.hintText,
          prefixIcon: widget.prefixIcon != null
              ? Image.asset(
                  widget.prefixIcon!,
                  scale: 2.8,
                )
              : null,
          suffixIcon: widget.suffixIcon != null
              ? GestureDetector(
                  onTap: () => setState(() => _isPassSecure = !_isPassSecure!),
                  child: Image.asset(
                    widget.suffixIcon!,
                    scale: 2.8,
                  ),
                )
              : null,
          enabledBorder: OutlineInputBorder(
              borderRadius: borderRadius10,
              borderSide: BorderSide(color: transparent)),
          focusedBorder: OutlineInputBorder(
              borderRadius: borderRadius10,
              borderSide: BorderSide(color: primaryColor)),
        ),
      ),
    );
  }
}
