import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/listing.dart';
import '../utils/price_format.dart';
import 'price_text.dart';
import 'section_card.dart';

class ListingHeader extends StatelessWidget {
  const ListingHeader({super.key, required this.listing});

  final Listing listing;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;
    final location = [
      _formatPostalCode(listing.postalCode),
      listing.city,
    ].whereType<String>().join(' ');
    final pricePerM2 = _pricePerM2(listing);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          listing.address ?? l10n.addressUnknown,
          style: textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w800,
            letterSpacing: -0.5,
          ),
        ),
        if (location.isNotEmpty) ...[
          const SizedBox(height: 4),
          Text(
            location,
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
        const SizedBox(height: 16),
        SectionCard(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    OverlineText(l10n.askingPrice),
                    const SizedBox(height: 2),
                    PriceText(listing: listing),
                  ],
                ),
              ),
              if (pricePerM2 != null) ...[
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    OverlineText(l10n.pricePerM2, textAlign: TextAlign.end),
                    const SizedBox(height: 2),
                    Text(
                      l10n.pricePerM2Value(formatEuro(context, pricePerM2)),
                      style: textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  /// Alleen als prijs en woonoppervlakte allebei bekend zijn.
  static int? _pricePerM2(Listing listing) {
    final price = listing.price;
    final area = listing.livingArea;
    if (price == null || area == null || area <= 0) return null;
    return (price / area).round();
  }

  /// "1075MJ" → "1075 MJ". Andere notaties blijven zoals ze zijn.
  static String? _formatPostalCode(String? postalCode) {
    final match = RegExp(r'^(\d{4})\s?([A-Za-z]{2})$')
        .firstMatch(postalCode?.trim() ?? '');
    if (match == null) return postalCode;
    return '${match[1]} ${match[2]!.toUpperCase()}';
  }
}
