import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/listing.dart';

/// Eén kenmerk van de woning. [value] is null als de API het niet levert.
typedef _Fact = ({IconData icon, String label, String? value, Color? badge});

class KeyFacts extends StatelessWidget {
  const KeyFacts({super.key, required this.listing});

  final Listing listing;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final m2 = _m2Formatter(context);

    // Eerst alles opsommen, daarna de ontbrekende waarden wegfilteren.
    final candidates = <_Fact>[
      (
        icon: Icons.square_foot,
        label: l10n.livingArea,
        value: m2(listing.livingArea),
        badge: null,
      ),
      (
        icon: Icons.landscape_outlined,
        label: l10n.plotArea,
        value: m2(listing.plotArea),
        badge: null,
      ),
      (
        icon: Icons.meeting_room_outlined,
        label: l10n.rooms,
        value: listing.rooms?.toString(),
        badge: null,
      ),
      (
        icon: Icons.bed_outlined,
        label: l10n.bedrooms,
        value: listing.bedrooms?.toString(),
        badge: null,
      ),
      (
        icon: Icons.bathtub_outlined,
        label: l10n.bathrooms,
        value: listing.bathrooms?.toString(),
        badge: null,
      ),
      (
        icon: Icons.calendar_today_outlined,
        label: l10n.buildYear,
        value: listing.buildYear,
        badge: null,
      ),
      (
        icon: Icons.energy_savings_leaf_outlined,
        label: l10n.energyLabel,
        value: listing.energyLabel,
        badge: _energyLabelColor(listing.energyLabel),
      ),
    ];

    final facts = [
      for (final f in candidates)
        if (f.value case final value? when value.isNotEmpty)
          (icon: f.icon, label: f.label, value: value, badge: f.badge),
    ];

    if (facts.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.keyFactsTitle,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 24,
          runSpacing: 16,
          children: [
            for (final (:icon, :label, :value, :badge) in facts)
              _FactTile(icon: icon, label: label, value: value, badge: badge),
          ],
        ),
      ],
    );
  }

  /// Geeft een functie die m² opmaakt in de taal van de app, bijv. "1.250 m²".
  static String? Function(int?) _m2Formatter(BuildContext context) {
    final format = NumberFormat.decimalPattern(
      Localizations.localeOf(context).toString(),
    );
    return (value) => value == null ? null : '${format.format(value)} m²';
  }

  /// Kleuren van het EU-energielabel. "A+++" telt als A.
  static Color? _energyLabelColor(String? label) {
    if (label == null || label.isEmpty) return null;
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

class _FactTile extends StatelessWidget {
  const _FactTile({
    required this.icon,
    required this.label,
    required this.value,
    this.badge,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color? badge;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final badge = this.badge;
    final valueStyle = theme.textTheme.bodyLarge?.copyWith(
      fontWeight: FontWeight.w600,
    );

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: theme.colorScheme.primary),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            if (badge == null)
              Text(value, style: valueStyle)
            else
              Container(
                margin: const EdgeInsets.only(top: 2),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: badge,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  value,
                  // Boven ~0.18 geeft zwart meer contrast dan wit (WCAG).
                  // Bij alle labels A t/m G is dat zo: zwart haalt AA.
                  style: valueStyle?.copyWith(
                    color: badge.computeLuminance() > 0.18
                        ? Colors.black
                        : Colors.white,
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}
