import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

/// Bedrag in hele euro's in de taal van de app: "€ 4.400.000" in het
/// Nederlands, "€4,400,000" in het Engels.
String formatEuro(BuildContext context, num amount) {
  return NumberFormat.currency(
    locale: Localizations.localeOf(context).toString(),
    symbol: '€',
    decimalDigits: 0,
  ).format(amount);
}
