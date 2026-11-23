import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:funda_listing/features/listing_detail/data/datasources/listing_remote_data_source.dart';
import 'package:funda_listing/features/listing_detail/data/models/listing_dto.dart';
import 'package:funda_listing/features/listing_detail/data/repositories/listing_repository_impl.dart';
import 'package:funda_listing/features/listing_detail/domain/entities/listing.dart';
import 'package:funda_listing/features/listing_detail/domain/failures/listing_failures.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';

class _MockDataSource extends Mock implements ListingRemoteDataSource {}

void main() {
  late _MockDataSource dataSource;
  late ListingRepositoryImpl repository;

  setUp(() {
    dataSource = _MockDataSource();
    repository = ListingRepositoryImpl(remoteDataSource: dataSource);
  });

  /// Laat de data source [error] gooien en geeft de Future van de repository.
  Future<Listing> getListingWhenDataSourceThrows(Object error) {
    when(() => dataSource.getListing(any()))
        .thenAnswer((_) => Future.error(error));
    return repository.getListing('abc-123');
  }

  test('geeft een Listing terug als de data source slaagt', () async {
    final json = jsonDecode(
      File('test/fixtures/listing_detail.json').readAsStringSync(),
    ) as Map<String, dynamic>;

    when(() => dataSource.getListing('abc-123'))
        .thenAnswer((_) async => ListingDto.fromJson(json));

    final listing = await repository.getListing('abc-123');

    // Equatable: vergelijkt alle velden van de Listing in één keer.
    expect(listing, ListingDto.fromJson(json).toDomain());
    verify(() => dataSource.getListing('abc-123')).called(1);
  });

  test('geeft een NotFoundFailure bij een 404', () async {
    await expectLater(
      getListingWhenDataSourceThrows(const ApiException(404)),
      throwsA(isA<NotFoundFailure>()),
    );
  });

  test('geeft een UnexpectedFailure bij een 500', () async {
    await expectLater(
      getListingWhenDataSourceThrows(const ApiException(500)),
      throwsA(
        isA<UnexpectedFailure>().having(
          (f) => f.cause,
          'cause',
          isA<ApiException>().having((e) => e.statusCode, 'statusCode', 500),
        ),
      ),
    );
  });

  test('geeft een NetworkFailure bij een ClientException', () async {
    await expectLater(
      getListingWhenDataSourceThrows(http.ClientException('x')),
      throwsA(isA<NetworkFailure>()),
    );
  });

  test('geeft een NetworkFailure bij een TimeoutException', () async {
    await expectLater(
      getListingWhenDataSourceThrows(TimeoutException('x')),
      throwsA(isA<NetworkFailure>()),
    );
  });

  test('geeft een UnexpectedFailure bij onverwachte data', () async {
    await expectLater(
      getListingWhenDataSourceThrows(const FormatException()),
      throwsA(
        isA<UnexpectedFailure>().having(
          (f) => f.cause,
          'cause',
          isA<FormatException>(),
        ),
      ),
    );
  });

  test('geeft een UnexpectedFailure als InternalId ontbreekt', () async {
    // Zo faalt ListingDto.fromJson zonder id (zie listing_dto_test.dart).
    await expectLater(
      getListingWhenDataSourceThrows(TypeError()),
      throwsA(
        isA<UnexpectedFailure>().having(
          (f) => f.cause,
          'cause',
          isA<TypeError>(),
        ),
      ),
    );
  });
}
