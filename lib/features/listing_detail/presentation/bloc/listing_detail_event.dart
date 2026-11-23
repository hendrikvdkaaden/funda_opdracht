import 'package:equatable/equatable.dart';

sealed class ListingDetailEvent extends Equatable {
  const ListingDetailEvent();

  @override
  List<Object?> get props => [];
}

class ListingDetailRequested extends ListingDetailEvent {
  const ListingDetailRequested(this.id);

  final String id;

  @override
  List<Object?> get props => [id];
}
