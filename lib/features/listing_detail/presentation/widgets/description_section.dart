import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';
import 'section_card.dart';

class DescriptionSection extends StatefulWidget {
  const DescriptionSection({super.key, required this.description});

  final String description;

  @override
  State<DescriptionSection> createState() => _DescriptionSectionState();
}

class _DescriptionSectionState extends State<DescriptionSection> {
  static const _collapsedLines = 5;
  static const _duration = Duration(milliseconds: 200);

  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final cardColor = SectionCard.defaultColor(context);
    final style = textTheme.bodyMedium?.copyWith(
      color: theme.colorScheme.onSurfaceVariant,
      height: 1.5,
    );

    return SectionCard(
      child: Column(
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
              final collapsed = overflows && !_expanded;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AnimatedSize(
                    duration: _duration,
                    alignment: Alignment.topCenter,
                    child: Stack(
                      children: [
                        Text(
                          widget.description,
                          style: style,
                          maxLines: _expanded ? null : _collapsedLines,
                          overflow: _expanded ? null : TextOverflow.clip,
                        ),
                        // Laat de laatste regel uitvloeien in de kaart.
                        Positioned(
                          left: 0,
                          right: 0,
                          bottom: 0,
                          height: 40,
                          child: IgnorePointer(
                            child: AnimatedOpacity(
                              opacity: collapsed ? 1 : 0,
                              duration: _duration,
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      cardColor.withValues(alpha: 0),
                                      cardColor,
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Alleen een knop als er echt iets in te klappen valt.
                  if (overflows)
                    TextButton.icon(
                      onPressed: () => setState(() => _expanded = !_expanded),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                      ),
                      iconAlignment: IconAlignment.end,
                      icon: AnimatedRotation(
                        turns: _expanded ? 0.5 : 0,
                        duration: _duration,
                        child: const Icon(Icons.expand_more),
                      ),
                      label: Text(_expanded ? l10n.readLess : l10n.readMore),
                    ),
                ],
              );
            },
          ),
        ],
      ),
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
