import 'package:flutter/material.dart';

/// Afgerond vlak waarin de secties van de detailpagina staan.
class SectionCard extends StatelessWidget {
  const SectionCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.color,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;

  final Color? color;

  /// Achtergrond als er geen [color] is meegegeven.
  static Color defaultColor(BuildContext context) =>
      Theme.of(context).colorScheme.surfaceContainerLow;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color ?? defaultColor(context),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(padding: padding, child: child),
    );
  }
}

/// Klein label in hoofdletters, zoals "VRAAGPRIJS".
class OverlineText extends StatelessWidget {
  const OverlineText(this.text, {super.key, this.textAlign});

  final String text;
  final TextAlign? textAlign;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Text(
      text.toUpperCase(),
      textAlign: textAlign,
      style: theme.textTheme.labelSmall?.copyWith(
        color: theme.colorScheme.onSurfaceVariant,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.6,
      ),
    );
  }
}
