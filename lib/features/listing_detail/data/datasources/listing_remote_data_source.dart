import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../../core/app_config.dart';
import '../models/listing_dto.dart';

/// Wordt gegooid als de API een andere status dan 200 teruggeeft.
class ApiException implements Exception {
  const ApiException(this.statusCode);
  final int statusCode;

  @override
  String toString() => 'ApiException($statusCode)';
}

class ListingRemoteDataSource {
  ListingRemoteDataSource({
    required this._client,
    this.baseUrl = AppConfig.baseUrl,
    this.apiKey = AppConfig.apiKey,
    this.timeOut = const Duration(seconds: 10),
  });

  final http.Client _client;
  final String baseUrl;
  final String apiKey;
  final Duration timeOut;

  Future<ListingDto> getListing(String id) async {
    final uri = Uri.parse('$baseUrl/json/detail/$apiKey/koop/$id/');

    final response = await _client.get(uri).timeout(timeOut);

    if (response.statusCode != 200) {
      throw ApiException(response.statusCode);
    }

    // De API is UTF-8. response.body leidt de encoding af uit de headers en
    // valt zonder Content-Type terug op Latin-1, wat tekens als • en ²
    // verminkt. Daarom de bytes zelf als UTF-8 decoderen.
    final listing =
        jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
    return ListingDto.fromJson(listing);
  }
}
