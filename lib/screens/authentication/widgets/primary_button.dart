import 'package:flutter/material.dart';
import 'package:homieeee/utils/constants/constants.dart';

class PrimaryButton extends StatelessWidget {
  final String title;
  final VoidCallback? onTap;
  const PrimaryButton({super.key, required this.title, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
            color: primaryColor,
            borderRadius: borderRadius10,
            boxShadow: [
              BoxShadow(
                offset: const Offset(0, 10),
                blurRadius: 20,
                color: primaryColor.withOpacity(.30),
              )
            ]),
        child: Center(
            child: Text(
          title,
          style: whiteMedium20,
        )),
      ),
    );
  }
}
