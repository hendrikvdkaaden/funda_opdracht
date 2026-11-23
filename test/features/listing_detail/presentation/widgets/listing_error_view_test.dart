import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:funda_listing/features/listing_detail/domain/failures/listing_failures.dart';
import 'package:funda_listing/features/listing_detail/presentation/widgets/listing_error_view.dart';
import 'package:funda_listing/l10n/app_localizations.dart';

void main() {
  Widget wrap(Widget child) => MaterialApp(
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    locale: const Locale('nl'),
    home: Scaffold(body: child),
  );

  testWidgets('toont een retry-knop die onRetry aanroept bij NetworkFailure', (
    tester,
  ) async {
    var retries = 0;
    await tester.pumpWidget(
      wrap(
        ListingErrorView(
          failure: const NetworkFailure(),
          onRetry: () => retries++,
        ),
      ),
    );

    expect(
      find.text('Geen verbinding. Controleer je internet.'),
      findsOneWidget,
    );
    expect(find.byType(FilledButton), findsOneWidget);

    await tester.tap(find.byType(FilledButton));

    expect(retries, 1);
  });

  testWidgets('toont geen retry-knop bij NotFoundFailure', (tester) async {
    await tester.pumpWidget(
      wrap(ListingErrorView(failure: const NotFoundFailure(), onRetry: () {})),
    );

    expect(find.text('Deze woning is niet meer beschikbaar.'), findsOneWidget);
    expect(find.byType(FilledButton), findsNothing);
  });
}
