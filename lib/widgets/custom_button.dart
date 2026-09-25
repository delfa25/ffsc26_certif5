import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final IconData? icon;
  final bool isSecondary;
  final String? semanticsHint;

  const CustomButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.isSecondary = false,
    this.semanticsHint,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final style = ElevatedButton.styleFrom(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      backgroundColor: isSecondary
          ? theme.colorScheme.surfaceContainerHighest
          : theme.primaryColor,
      foregroundColor: isSecondary
          ? theme.colorScheme.onSurface
          : theme.colorScheme.onPrimary,
    );

    return Semantics(
      button: true,
      label: label,
      hint: semanticsHint,
      child: icon != null
          ? ElevatedButton.icon(
              style: style,
              onPressed: onPressed,
              icon: Icon(icon, size: 18),
              label: Text(label),
            )
          : ElevatedButton(
              style: style,
              onPressed: onPressed,
              child: Text(label),
            ),
    );
  }
}
