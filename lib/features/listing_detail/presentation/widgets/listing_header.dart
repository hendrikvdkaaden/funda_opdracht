import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/listing.dart';

class ListingHeader extends StatelessWidget {
  const ListingHeader({super.key, required this.listing});

  final Listing listing;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final textTheme = Theme.of(context).textTheme;
    final location = [
      listing.postalCode,
      listing.city,
    ].whereType<String>().where((part) => part.isNotEmpty).join(' ');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          listing.address ?? l10n.addressUnknown,
          style: textTheme.headlineSmall,
        ),
        if (location.isNotEmpty) ...[
          const SizedBox(height: 4),
          Text(
            location,
            style: textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
        const SizedBox(height: 12),
        Text(
          _formatPrice(context, listing.price, listing.priceSuffix),
          style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  static String _formatPrice(BuildContext context, int? price, String? suffix) {
    if (price == null) return AppLocalizations.of(context).priceOnRequest;
    // Scheidingstekens volgen de taal van de app: "€ 4.400.000" in het
    // Nederlands, "€4,400,000" in het Engels.
    final formatted = NumberFormat.currency(
      locale: Localizations.localeOf(context).toString(),
      symbol: '€',
      decimalDigits: 0,
    ).format(price);
    return (suffix == null || suffix.isEmpty)
        ? formatted
        : '$formatted $suffix';
  }
}
