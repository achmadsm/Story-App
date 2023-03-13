import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.button,
    required this.text,
    required this.onPressed,
  });

  final String button;
  final String text;
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    if (button == 'Elevated') {
      return ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100),
          ),
        ),
        onPressed: onPressed,
        child: Text(text),
      );
    } else if (button == 'Outlined') {
      return OutlinedButton(
        style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100),
          ),
        ),
        onPressed: onPressed,
        child: Text(text),
      );
    } else {
      return const Placeholder();
    }
  }
}
