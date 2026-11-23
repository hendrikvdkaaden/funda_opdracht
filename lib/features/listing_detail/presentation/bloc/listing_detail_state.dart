import 'package:equatable/equatable.dart';
import 'package:funda_listing/features/listing_detail/domain/failures/listing_failures.dart';

import '../../domain/entities/listing.dart';

sealed class ListingDetailState extends Equatable {
  const ListingDetailState();

  @override
  List<Object?> get props => [];
}

class ListingDetailLoading extends ListingDetailState {
  const ListingDetailLoading();
}

class ListingDetailLoaded extends ListingDetailState {
  const ListingDetailLoaded(this.listing);

  final Listing listing;

  @override
  List<Object?> get props => [listing];
}

class ListingDetailError extends ListingDetailState {
  const ListingDetailError(this.failure);

  final ListingFailure failure;

  @override
  List<Object?> get props => [failure];
}
