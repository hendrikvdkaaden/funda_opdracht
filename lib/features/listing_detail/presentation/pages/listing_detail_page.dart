import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:funda_listing/features/listing_detail/domain/repositories/listing_repository.dart';
import 'package:funda_listing/features/listing_detail/presentation/bloc/listing_detail_bloc.dart';
import 'package:funda_listing/features/listing_detail/presentation/bloc/listing_detail_state.dart';
import 'package:funda_listing/features/listing_detail/presentation/widgets/listing_detail_view.dart';
import 'package:funda_listing/features/listing_detail/presentation/widgets/listing_error_view.dart';
import 'package:funda_listing/l10n/app_localizations.dart';

import '../bloc/listing_detail_event.dart';

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
        body: BlocBuilder<ListingDetailBloc, ListingDetailState>(
          builder: (context, state) => switch (state) {
            ListingDetailLoading() => const Center(
              child: CircularProgressIndicator(),
            ),
            ListingDetailLoaded(:final listing) => Center(
              child: ListingDetailView(listing: listing),
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
      ),
    );
  }
}
