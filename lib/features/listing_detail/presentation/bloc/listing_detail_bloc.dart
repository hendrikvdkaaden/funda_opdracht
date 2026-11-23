import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:funda_listing/features/listing_detail/domain/failures/listing_failures.dart';
import 'package:funda_listing/features/listing_detail/domain/repositories/listing_repository.dart';

import 'listing_detail_event.dart';
import 'listing_detail_state.dart';

class ListingDetailBloc extends Bloc<ListingDetailEvent, ListingDetailState> {
  ListingDetailBloc(this._repository) : super(const ListingDetailLoading()) {
    on<ListingDetailRequested>(_onRequested, transformer: restartable());
  }

  final ListingRepository _repository;

  Future<void> _onRequested(
    ListingDetailRequested event,
    Emitter<ListingDetailState> emit,
  ) async {
    emit(const ListingDetailLoading());
    try {
      final listing = await _repository.getListing(event.id);
      emit(ListingDetailLoaded(listing));
    } on ListingFailure catch (failure) {
      emit(ListingDetailError(failure));
    }
  }
}
