import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';

class DescriptionSection extends StatefulWidget {
  const DescriptionSection({super.key, required this.description});

  final String description;

  @override
  State<DescriptionSection> createState() => _DescriptionSectionState();
}

class _DescriptionSectionState extends State<DescriptionSection> {
  static const _collapsedLines = 5;

  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final textTheme = Theme.of(context).textTheme;
    final style = textTheme.bodyMedium;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.descriptionTitle, style: textTheme.titleMedium),
        const SizedBox(height: 8),
        LayoutBuilder(
          builder: (context, constraints) {
            final overflows = _exceedsCollapsedLines(
              context,
              style,
              constraints.maxWidth,
            );

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AnimatedSize(
                  duration: const Duration(milliseconds: 200),
                  alignment: Alignment.topCenter,
                  child: Text(
                    widget.description,
                    style: style,
                    maxLines: _expanded ? null : _collapsedLines,
                    overflow: _expanded ? null : TextOverflow.fade,
                  ),
                ),
                // Alleen een knop als er echt iets in te klappen valt.
                if (overflows)
                  TextButton(
                    onPressed: () => setState(() => _expanded = !_expanded),
                    child: Text(_expanded ? l10n.readLess : l10n.readMore),
                  ),
              ],
            );
          },
        ),
      ],
    );
  }

  /// Meet de tekst met dezelfde stijl, breedte en tekstschaal als de
  /// [Text] hierboven, zodat de uitkomst klopt met wat er getoond wordt.
  bool _exceedsCollapsedLines(
    BuildContext context,
    TextStyle? style,
    double maxWidth,
  ) {
    final painter = TextPainter(
      text: TextSpan(text: widget.description, style: style),
      maxLines: _collapsedLines,
      textDirection: Directionality.of(context),
      textScaler: MediaQuery.textScalerOf(context),
    )..layout(maxWidth: maxWidth);

    final exceeds = painter.didExceedMaxLines;
    painter.dispose();
    return exceeds;
  }
}
