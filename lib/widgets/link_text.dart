import 'package:flutter/material.dart';

class LinkText extends StatelessWidget {
  const LinkText({
    super.key,
    required this.text,
    this.boldText = '',
    required this.onTap,
  });

  final String text;
  final String boldText;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Wrap(
        children: [
          Text(text),
          Text(
            boldText,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary),
          )
        ],
      ),
    );
  }
}
