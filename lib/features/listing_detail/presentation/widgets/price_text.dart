import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/listing.dart';
import '../utils/price_format.dart';

/// Vraagprijs in oranje met de suffix ("k.k.") klein erachter, of "Prijs op
/// aanvraag" als er geen prijs is.
class PriceText extends StatelessWidget {
  const PriceText({super.key, required this.listing, this.style});

  final Listing listing;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final price = listing.price;
    final suffix = listing.priceSuffix;
    final priceStyle = (style ?? theme.textTheme.headlineSmall)?.copyWith(
      fontWeight: FontWeight.w800,
      color: _priceColor(theme.colorScheme),
    );

    if (price == null) {
      return Text(
        AppLocalizations.of(context).priceOnRequest,
        style: priceStyle,
      );
    }

    return Text.rich(
      TextSpan(
        children: [
          TextSpan(text: formatEuro(context, price), style: priceStyle),
          if (suffix != null)
            TextSpan(
              text: ' $suffix',
              style: theme.textTheme.labelMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
        ],
      ),
    );
  }

  /// Op donker is het fel oranje goed leesbaar; op licht is het te zwak
  /// (WCAG), daar wordt het de donkerdere primary.
  static Color _priceColor(ColorScheme colorScheme) =>
      colorScheme.brightness == Brightness.dark
      ? colorScheme.primaryContainer
      : colorScheme.primary;
}
