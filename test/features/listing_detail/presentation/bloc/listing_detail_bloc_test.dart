import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:funda_listing/features/listing_detail/domain/entities/listing.dart';
import 'package:funda_listing/features/listing_detail/domain/failures/listing_failures.dart';
import 'package:funda_listing/features/listing_detail/domain/repositories/listing_repository.dart';
import 'package:funda_listing/features/listing_detail/presentation/bloc/listing_detail_bloc.dart';
import 'package:funda_listing/features/listing_detail/presentation/bloc/listing_detail_event.dart';
import 'package:funda_listing/features/listing_detail/presentation/bloc/listing_detail_state.dart';
import 'package:mocktail/mocktail.dart';

class _MockRepository extends Mock implements ListingRepository {}

void main() {
  late _MockRepository repository;
  const listing = Listing(id: 'abc-123', address: 'Amstelveenseweg 182-3');

  setUp(() => repository = _MockRepository());

  blocTest<ListingDetailBloc, ListingDetailState>(
    'emit [Loading, Loaded] als het ophalen slaagt',
    setUp: () =>
        when(() => repository.getListing('abc-123'))
            .thenAnswer((_) async => listing),
    build: () => ListingDetailBloc(repository),
    act: (bloc) => bloc.add(const ListingDetailRequested('abc-123')),
    expect: () => const [ListingDetailLoading(), ListingDetailLoaded(listing)],
    verify: (_) => verify(() => repository.getListing('abc-123')).called(1),
  );

  blocTest<ListingDetailBloc, ListingDetailState>(
    'emit [Loading, Error] als de repository een failure gooit',
    setUp: () =>
        when(() => repository.getListing('abc-123'))
            .thenAnswer((_) => Future.error(const NetworkFailure())),
    build: () => ListingDetailBloc(repository),
    act: (bloc) => bloc.add(const ListingDetailRequested('abc-123')),
    expect: () => const [
      ListingDetailLoading(),
      ListingDetailError(NetworkFailure()),
    ],
  );

  blocTest<ListingDetailBloc, ListingDetailState>(
    'negeert een oud antwoord als er al een nieuwer verzoek loopt',
    setUp: () {
      // 'oud' is traag, 'nieuw' is snel: zonder restartable() zou het oude
      // antwoord als laatste binnenkomen en het nieuwe overschrijven.
      when(() => repository.getListing('oud')).thenAnswer(
        (_) => Future.delayed(
          const Duration(milliseconds: 100),
          () => const Listing(id: 'oud'),
        ),
      );
      when(() => repository.getListing('nieuw'))
          .thenAnswer((_) async => const Listing(id: 'nieuw'));
    },
    build: () => ListingDetailBloc(repository),
    act: (bloc) => bloc
      ..add(const ListingDetailRequested('oud'))
      ..add(const ListingDetailRequested('nieuw')),
    // Lang genoeg wachten tot ook het trage antwoord binnen had kunnen komen.
    wait: const Duration(milliseconds: 200),
    // Eén Loading: de tweede is gelijk aan de huidige state en wordt door
    // bloc overgeslagen.
    expect: () => const [
      ListingDetailLoading(),
      ListingDetailLoaded(Listing(id: 'nieuw')),
    ],
  );
}
