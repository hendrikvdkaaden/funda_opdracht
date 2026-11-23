import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../l10n/app_localizations.dart';
import '../../domain/repositories/listing_repository.dart';
import '../bloc/listing_detail_bloc.dart';
import '../bloc/listing_detail_event.dart';
import '../bloc/listing_detail_state.dart';
import '../widgets/listing_detail_view.dart';
import '../widgets/listing_error_view.dart';
import '../widgets/price_call_bar.dart';

class ListingDetailPage extends StatelessWidget {
  const ListingDetailPage({
    super.key,
    required this.listingId,
    required this.listingRepository,
  });

  final String listingId;
  final ListingRepository listingRepository;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          ListingDetailBloc(listingRepository)
            ..add(ListingDetailRequested(listingId)),
      child: Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context).listingDetailTitle),
        ),
        // Alleen de delen die van de state afhangen worden opnieuw gebouwd.
        body: BlocBuilder<ListingDetailBloc, ListingDetailState>(
          builder: (context, state) => switch (state) {
            ListingDetailLoading() => const Center(
              child: CircularProgressIndicator(),
            ),
            ListingDetailLoaded(:final listing) => ListingDetailView(
              listing: listing,
            ),
            ListingDetailError(:final failure) => Center(
              child: ListingErrorView(
                failure: failure,
                onRetry: () => context.read<ListingDetailBloc>().add(
                  ListingDetailRequested(listingId),
                ),
              ),
            ),
          },
        ),
        bottomNavigationBar: BlocBuilder<ListingDetailBloc, ListingDetailState>(
          builder: (context, state) => switch (state) {
            ListingDetailLoaded(:final listing) => PriceCallBar(
              listing: listing,
            ),
            _ => const SizedBox.shrink(),
          },
        ),
      ),
    );
  }
}
