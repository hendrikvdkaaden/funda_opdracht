import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';
import '../../domain/failures/listing_failures.dart';

class ListingErrorView extends StatelessWidget {
  const ListingErrorView({
    super.key,
    required this.failure,
    required this.onRetry,
  });

  final ListingFailure failure;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final (icon, message, canRetry) = switch (failure) {
      NetworkFailure() => (Icons.wifi_off, l10n.errorNetwork, true),
      NotFoundFailure() => (Icons.home_outlined, l10n.errorNotFound, false),
      UnexpectedFailure() => (Icons.error_outline, l10n.errorUnexpected, true),
    };

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 48),
            const SizedBox(height: 16),
            Text(message, textAlign: TextAlign.center),
            if (canRetry) ...[
              const SizedBox(height: 16),
              FilledButton(onPressed: onRetry, child: Text(l10n.retry)),
            ],
          ],
        ),
      ),
    );
  }
}
