import 'package:flutter/material.dart';

class AuthTextField extends StatefulWidget {
  final TextEditingController? controller;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final String? hintText;
  final TextInputAction? textInputAction;
  final TextInputType? keyboardType;
  final bool? isPassSecure;
  final int? maxLines;
  const AuthTextField(
      {super.key,
      this.textInputAction = TextInputAction.next,
      this.prefixIcon,
      this.suffixIcon,
      this.hintText,
      this.isPassSecure,
      this.maxLines,
      this.keyboardType,
      this.controller});

  @override
  State<AuthTextField> createState() => _AuthTextFieldState();
}

class _AuthTextFieldState extends State<AuthTextField> {
  bool? _isPassSecure;

  @override
  void initState() {
    super.initState();
    _isPassSecure = widget.isPassSecure;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 237, 237, 239),
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextField(
        controller: widget.controller,
        maxLines: widget.maxLines,
        cursorColor: Colors.black,
        style: const TextStyle(
          color: Colors.black,
          fontFamily: 'R',
          fontSize: 13,
        ),
        obscureText: _isPassSecure ?? false,
        textInputAction: widget.textInputAction,
        keyboardType: widget.keyboardType,
        decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: const TextStyle(
            color: Color(0xff8A9CBF),
            fontSize: 12,
          ),
          prefixIcon:
              widget.prefixIcon != null ? Icon(widget.prefixIcon) : null,
          suffixIcon: widget.suffixIcon != null
              ? GestureDetector(
                  onTap: () => setState(() => _isPassSecure = !_isPassSecure!),
                  child: Icon(widget.prefixIcon))
              : null,
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.transparent)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xffF62354))),
        ),
      ),
    );
  }
}
