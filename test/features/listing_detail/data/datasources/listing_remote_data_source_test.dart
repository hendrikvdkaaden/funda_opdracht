import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:funda_listing/features/listing_detail/data/datasources/listing_remote_data_source.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

void main() {
  final fixture = File('test/fixtures/listing_detail.json').readAsStringSync();

  ListingRemoteDataSource dataSourceWith(MockClient client) =>
      ListingRemoteDataSource(
        client: client,
        baseUrl: 'https://example.com',
        apiKey: 'test-key',
      );

  /// Een 200 met de fixture als bytes en zonder headers. Zonder Content-Type
  /// zou response.body de bytes als Latin-1 lezen.
  http.Response fixtureResponse() =>
      http.Response.bytes(utf8.encode(fixture), 200);

  test('roept de detail-URL aan met de key en het id', () async {
    Uri? requestedUrl;
    final client = MockClient((request) async {
      requestedUrl = request.url;
      return fixtureResponse();
    });

    await dataSourceWith(client).getListing('abc-123');

    expect(
      requestedUrl.toString(),
      'https://example.com/json/detail/test-key/koop/abc-123/',
    );
  });

  test('geeft een DTO terug bij een 200', () async {
    final client = MockClient((_) async => fixtureResponse());

    final dto = await dataSourceWith(client).getListing('abc-123');

    expect(dto.id, '9ddd5cc7-fabd-420a-abb0-3bb447cb169e');
  });

  test(
    'decodeert speciale tekens correct als de Content-Type-header ontbreekt',
    () async {
      final client = MockClient((_) async => fixtureResponse());

      final dto = await dataSourceWith(client).getListing('abc-123');

      expect(dto.description, contains('•'));
      expect(dto.description, isNot(contains('â€¢')));
    },
  );

  test('gooit een TimeoutException als de server te traag is', () async {
    final client = MockClient((_) async {
      await Future<void>.delayed(const Duration(milliseconds: 100));
      return fixtureResponse();
    });
    final dataSource = ListingRemoteDataSource(
      client: client,
      baseUrl: 'https://example.com',
      apiKey: 'test-key',
      timeOut: const Duration(milliseconds: 10),
    );

    await expectLater(
      dataSource.getListing('abc-123'),
      throwsA(isA<TimeoutException>()),
    );
  });

  test('gooit een ApiException met de statuscode bij een 404', () async {
    final client = MockClient((_) async => http.Response('', 404));

    await expectLater(
      dataSourceWith(client).getListing('abc-123'),
      throwsA(
        isA<ApiException>().having((e) => e.statusCode, 'statusCode', 404),
      ),
    );
  });
}
