import 'package:flutter/material.dart';

class FloatingActionIconButton extends StatelessWidget {
  const FloatingActionIconButton({
    super.key,
    required this.onPressed,
    this.icon = const Icon(Icons.add),
    this.isVisible = true,
  });

  final Function() onPressed;
  final Icon icon;
  final bool isVisible;

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: isVisible,
      child: FloatingActionButton(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        onPressed: onPressed,
        child: icon,
      ),
    );
  }
}
