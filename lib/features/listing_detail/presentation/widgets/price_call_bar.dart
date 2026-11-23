import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/listing.dart';
import '../utils/call_phone.dart';
import 'price_text.dart';

/// Vaste balk onderin met adres, prijs en de belknop, zodat de makelaar
/// overal op de pagina te bereiken is.
class PriceCallBar extends StatelessWidget {
  const PriceCallBar({super.key, required this.listing});

  final Listing listing;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final address = listing.address;
    final phone = listing.agent?.phone;

    return Material(
      color: theme.colorScheme.surfaceContainer,
      elevation: 8,
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (address != null)
                      Text(
                        address,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    PriceText(
                      listing: listing,
                      style: theme.textTheme.titleLarge,
                    ),
                  ],
                ),
              ),
              if (phone != null) ...[
                const SizedBox(width: 12),
                FilledButton.icon(
                  onPressed: () => callPhone(context, phone),
                  icon: const Icon(Icons.call),
                  label: Text(AppLocalizations.of(context).callAgent),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
