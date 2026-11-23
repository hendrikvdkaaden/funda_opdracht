import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/listing.dart';
import 'section_card.dart';

/// Eén tegel in het raster. [value] of [trailing] is altijd gevuld.
typedef _Fact = ({
  IconData icon,
  Color iconColor,
  String label,
  String? value,
  String? unit,
  String? subtitle,
  Widget? trailing,
});

class KeyFacts extends StatelessWidget {
  const KeyFacts({super.key, required this.listing});

  static const _gap = 8.0;

  final Listing listing;

  @override
  Widget build(BuildContext context) {
    final facts = _facts(context);
    if (facts.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context).keyFactsTitle,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        // Per twee tegels een rij; IntrinsicHeight maakt ze even hoog, ook
        // als de tekst groter is ingesteld.
        for (var i = 0; i < facts.length; i += 2) ...[
          if (i > 0) const SizedBox(height: _gap),
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(child: _FactTile(fact: facts[i])),
                const SizedBox(width: _gap),
                Expanded(
                  child: i + 1 < facts.length
                      ? _FactTile(fact: facts[i + 1])
                      : const SizedBox.shrink(),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  List<_Fact> _facts(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;
    final number = NumberFormat.decimalPattern(
      Localizations.localeOf(context).toString(),
    );
    final buildYear = listing.buildYear;
    final energyLabel = listing.energyLabel;
    final energyBadge = energyLabel == null
        ? null
        : _EnergyLabelBadge(label: energyLabel);
    final roomDetails = [
      if (listing.bedrooms case final count?) l10n.bedroomsCount(count),
      if (listing.bathrooms case final count?) l10n.bathroomsCount(count),
    ].join(' · ');

    return [
      if (listing.livingArea case final area?)
        (
          icon: Icons.square_foot,
          iconColor: colorScheme.primary,
          label: l10n.livingArea,
          value: number.format(area),
          unit: 'm²',
          subtitle: null,
          trailing: null,
        ),
      if (listing.plotArea case final area?)
        (
          icon: Icons.yard_outlined,
          iconColor: colorScheme.secondary,
          label: l10n.plotArea,
          value: number.format(area),
          unit: 'm²',
          subtitle: null,
          trailing: null,
        ),
      if (listing.rooms case final rooms?)
        (
          icon: Icons.meeting_room_outlined,
          iconColor: colorScheme.tertiary,
          label: l10n.rooms,
          value: rooms.toString(),
          unit: null,
          subtitle: roomDetails.isEmpty ? null : roomDetails,
          trailing: null,
        )
      // Zonder aantal kamers krijgen slaap- en badkamers een eigen tegel.
      else ...[
        if (listing.bedrooms case final count?)
          (
            icon: Icons.bed_outlined,
            iconColor: colorScheme.tertiary,
            label: l10n.bedrooms,
            value: count.toString(),
            unit: null,
            subtitle: null,
            trailing: null,
          ),
        if (listing.bathrooms case final count?)
          (
            icon: Icons.bathtub_outlined,
            iconColor: colorScheme.tertiary,
            label: l10n.bathrooms,
            value: count.toString(),
            unit: null,
            subtitle: null,
            trailing: null,
          ),
      ],
      // Bouwjaar en energielabel delen een tegel. Zonder bouwjaar krijgt
      // het label de tegel alleen.
      if (buildYear != null || energyBadge != null)
        (
          icon: buildYear != null
              ? Icons.calendar_month_outlined
              : Icons.energy_savings_leaf_outlined,
          iconColor: colorScheme.primary,
          label: buildYear != null ? l10n.buildYear : l10n.energyLabel,
          value: buildYear,
          unit: null,
          subtitle: null,
          trailing: energyBadge,
        ),
    ];
  }
}

class _FactTile extends StatelessWidget {
  const _FactTile({required this.fact});

  final _Fact fact;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final mutedColor = theme.colorScheme.onSurfaceVariant;
    final (:icon, :iconColor, :label, :value, :unit, :subtitle, :trailing) =
        fact;

    return SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: iconColor),
              const SizedBox(width: 8),
              Expanded(child: OverlineText(label, textAlign: TextAlign.end)),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (value != null)
                Expanded(
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: value,
                          style: textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        if (unit != null)
                          TextSpan(
                            text: ' $unit',
                            style: textTheme.labelMedium?.copyWith(
                              color: mutedColor,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              if (trailing != null) Flexible(child: trailing),
            ],
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: textTheme.bodySmall?.copyWith(color: mutedColor),
            ),
          ],
        ],
      ),
    );
  }
}

class _EnergyLabelBadge extends StatelessWidget {
  const _EnergyLabelBadge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final color = _energyLabelColor(label);
    // Boven ~0.18 geeft zwart meer contrast dan wit (WCAG).
    // Bij alle labels A t/m G is dat zo: zwart haalt AA.
    final foreground = color == null
        ? Theme.of(context).colorScheme.onSurface
        : color.computeLuminance() > 0.18
        ? Colors.black
        : Colors.white;

    // Eigen node, anders gaat het label op in de tekst van de tegel.
    return Semantics(
      container: true,
      label: '${l10n.energyLabel} $label',
      excludeSemantics: true,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: color ?? Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Alleen bij een echte klasse; bij "Niet verplicht" klopt het
            // icoon niet.
            if (color != null) ...[
              Icon(Icons.bolt, size: 16, color: foreground),
              const SizedBox(width: 2),
            ],
            Flexible(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: foreground,
                  fontSize: color != null ? 17 : 13,
                  fontWeight: color != null ? FontWeight.w900 : FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Kleuren van het EU-energielabel. "A+++" telt als A.
  static Color? _energyLabelColor(String label) {
    return switch (label[0].toUpperCase()) {
      'A' => const Color(0xFF00A651),
      'B' => const Color(0xFF50B848),
      'C' => const Color(0xFFBED630),
      'D' => const Color(0xFFFFF200),
      'E' => const Color(0xFFFDB913),
      'F' => const Color(0xFFF37021),
      'G' => const Color(0xFFED1C24),
      _ => null,
    };
  }
}
