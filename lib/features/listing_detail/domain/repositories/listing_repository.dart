import '../entities/listing.dart';

abstract interface class ListingRepository {
  Future<Listing> getListing(String id);
}
