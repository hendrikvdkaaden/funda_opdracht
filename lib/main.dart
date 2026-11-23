// lib/main.dart
import 'package:flutter/material.dart';
import 'package:funda_listing/l10n/app_localizations.dart';
import 'package:funda_listing/core/app_config.dart';
import 'package:http/http.dart' as http;

import 'features/listing_detail/data/datasources/listing_remote_data_source.dart';
import 'features/listing_detail/domain/repositories/listing_repository.dart';
import 'features/listing_detail/data/repositories/listing_repository_impl.dart';
import 'features/listing_detail/presentation/pages/listing_detail_page.dart';

/// De woning die standaard getoond wordt. Te overschrijven met
/// `--dart-define=LISTING_ID=<id>`.
const _listingId = String.fromEnvironment(
  'LISTING_ID',
  defaultValue: '9ddd5cc7-fabd-420a-abb0-3bb447cb169e',
);

void main() {
  if (AppConfig.apiKey.isEmpty) {
    throw StateError(
      'FUNDA_API_KEY ontbreekt. Start de app met '
      '--dart-define-from-file=config.json (zie README).',
    );
  }
  final ListingRepository repository = ListingRepositoryImpl(
    remoteDataSource: ListingRemoteDataSource(client: http.Client()),
  );

  runApp(FundaApp(listingRepository: repository));
}

class FundaApp extends StatelessWidget {
  const FundaApp({super.key, required this.listingRepository});

  final ListingRepository listingRepository;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Funda',
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: ThemeData(
        colorSchemeSeed: const Color(0xFFF7A100), // Funda-oranje
        useMaterial3: true,
      ),
      home: ListingDetailPage(
        listingId: _listingId,
        listingRepository: listingRepository,
      ),
    );
  }
}
