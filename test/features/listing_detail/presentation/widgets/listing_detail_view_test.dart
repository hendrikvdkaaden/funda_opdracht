import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:funda_listing/features/listing_detail/domain/entities/agent.dart';
import 'package:funda_listing/features/listing_detail/domain/entities/listing.dart';
import 'package:funda_listing/features/listing_detail/presentation/widgets/listing_detail_view.dart';
import 'package:funda_listing/features/listing_detail/presentation/widgets/price_call_bar.dart';
import 'package:funda_listing/l10n/app_localizations.dart';

void main() {
  // Zonder foto's en locatie: die laden van het netwerk, en in een
  // widget-test krijgt elk HTTP-verzoek een 400 terug.
  const listing = Listing(
    id: '9ddd5cc7-fabd-420a-abb0-3bb447cb169e',
    address: 'Amstelveenseweg 182-3',
    postalCode: '1075MJ',
    city: 'Amsterdam',
    price: 4400000,
    priceSuffix: 'k.k.',
    livingArea: 380,
    plotArea: 130,
    rooms: 10,
    bathrooms: 1,
    buildYear: '1930',
    energyLabel: 'E',
    description: 'Rustig en riant wonen in Amsterdam!',
    agent: Agent(name: 'DAMSTAD', phone: '020-1805189'),
  );

  Widget wrap(Widget child) => MaterialApp(
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    locale: const Locale('nl'),
    home: Scaffold(body: child),
  );

  /// Zoekt tekst, ook als die uit meerdere spans bestaat. intl zet een
  /// harde spatie tussen € en het bedrag; die telt hier als gewone spatie.
  Finder findText(String text) => find.byWidgetPredicate(
    (widget) =>
        widget is RichText &&
        widget.text.toPlainText().replaceAll('\u00a0', ' ') == text,
  );

  setUp(() {
    // Hoog genoeg dat de ListView alle secties bouwt.
    final view =
        TestWidgetsFlutterBinding.instance.platformDispatcher.views.first;
    view.physicalSize = const Size(1200, 4000);
    view.devicePixelRatio = 1;
  });

  tearDown(() {
    final view =
        TestWidgetsFlutterBinding.instance.platformDispatcher.views.first;
    view.resetPhysicalSize();
    view.resetDevicePixelRatio();
  });

  testWidgets('toont adres, prijs, prijs per m², kenmerken en makelaar', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();
    await tester.pumpWidget(wrap(const ListingDetailView(listing: listing)));

    expect(find.text('Amstelveenseweg 182-3'), findsOneWidget);
    expect(find.text('1075 MJ Amsterdam'), findsOneWidget);
    expect(findText('€ 4.400.000 k.k.'), findsOneWidget);
    // 4.400.000 / 380 = 11.578,9 → afgerond.
    expect(findText('€ 11.579 / m²'), findsOneWidget);
    expect(findText('380 m²'), findsOneWidget);
    expect(find.text('1 badkamer'), findsOneWidget);
    expect(find.bySemanticsLabel('Energielabel E'), findsOneWidget);
    expect(find.text('DAM'), findsOneWidget);
    // Bellen gaat via de PriceCallBar; de kaart toont alleen het nummer.
    expect(find.text('020-1805189'), findsOneWidget);
    semantics.dispose();
  });

  testWidgets('verbergt prijs per m² zonder woonoppervlakte', (tester) async {
    const withoutArea = Listing(id: '1', price: 250000);

    await tester.pumpWidget(
      wrap(const ListingDetailView(listing: withoutArea)),
    );

    expect(find.text('Prijs per m²'.toUpperCase()), findsNothing);
    expect(find.text('Bel makelaar'), findsNothing);
  });

  testWidgets('PriceCallBar toont geen belknop zonder telefoonnummer', (
    tester,
  ) async {
    const withoutPhone = Listing(
      id: '1',
      address: 'Damrak 1',
      agent: Agent(name: 'Makelaar'),
    );

    await tester.pumpWidget(wrap(const PriceCallBar(listing: withoutPhone)));

    expect(find.text('Damrak 1'), findsOneWidget);
    expect(find.text('Prijs op aanvraag'), findsOneWidget);
    expect(find.byType(FilledButton), findsNothing);
  });
}
