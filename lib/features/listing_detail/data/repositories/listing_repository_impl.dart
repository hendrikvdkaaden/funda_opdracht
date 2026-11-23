import 'dart:async';

import 'package:http/http.dart' as http;

import '../datasources/listing_remote_data_source.dart';
import '../../domain/entities/listing.dart';
import '../../domain/failures/listing_failures.dart';
import '../../domain/repositories/listing_repository.dart';

class ListingRepositoryImpl implements ListingRepository {
  const ListingRepositoryImpl({required this._remoteDataSource});

  final ListingRemoteDataSource _remoteDataSource;

  @override
  Future<Listing> getListing(String id) async {
    try {
      final dto = await _remoteDataSource.getListing(id);
      return dto.toDomain();
    } on ApiException catch (e) {
      if (e.statusCode == 404) throw const NotFoundFailure();
      throw UnexpectedFailure(e);
    } on http.ClientException {
      throw const NetworkFailure();
    } on TimeoutException {
      throw const NetworkFailure();
    } catch (e) {
      throw UnexpectedFailure(e);
    }
  }
}
