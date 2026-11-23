import 'package:equatable/equatable.dart';

sealed class ListingFailure extends Equatable implements Exception {
  const ListingFailure();

  @override
  List<Object?> get props => [];
}

/// Geen verbinding of de server reageerde niet op tijd.
class NetworkFailure extends ListingFailure {
  const NetworkFailure();
}

/// De woning bestaat niet (meer).
class NotFoundFailure extends ListingFailure {
  const NotFoundFailure();
}

/// Elke andere fout: serverfout of onverwachte data.
class UnexpectedFailure extends ListingFailure {
  const UnexpectedFailure([this.cause]);

  final Object? cause;

  @override
  List<Object?> get props => [cause];
}
