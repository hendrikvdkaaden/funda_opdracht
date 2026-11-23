import '../../domain/entities/agent.dart';
import '../../domain/entities/geo_location.dart';
import '../../domain/entities/listing.dart';

class ListingDto {
  const ListingDto({
    required this.id,
    this.address,
    this.postalCode,
    this.city,
    this.price,
    this.priceSuffix,
    this.livingArea,
    this.plotArea,
    this.rooms,
    this.bedrooms,
    this.bathrooms,
    this.buildYear,
    this.energyLabel,
    this.description,
    this.photoUrls = const [],
    this.latitude,
    this.longitude,
    this.agentName,
    this.agentPhone,
  });

  final String id;
  final String? address;
  final String? postalCode;
  final String? city;
  final int? price;
  final String? priceSuffix;
  final int? livingArea;
  final int? plotArea;
  final int? rooms;
  final int? bedrooms;
  final int? bathrooms;
  final String? buildYear;
  final String? energyLabel;
  final String? description;
  final List<String> photoUrls;
  final double? latitude;
  final double? longitude;
  final String? agentName;
  final String? agentPhone;

  factory ListingDto.fromJson(Map<String, dynamic> json) {
    final priceInfo = json['Prijs'] as Map<String, dynamic>?;
    final energyLabel = json['Energielabel'] as Map<String, dynamic>?;

    return ListingDto(
      id: json['InternalId'] as String,
      address: json['Adres'] as String?,
      postalCode: json['Postcode'] as String?,
      city: json['Plaats'] as String?,
      // JSON kent geen verschil tussen 4 en 4.0, dus eerst als num
      // uitlezen en dan omzetten. Een directe `as int` kan crashen.
      price: (json['KoopPrijs'] as num?)?.toInt(),
      priceSuffix: priceInfo?['KoopAbbreviation'] as String?,
      livingArea: (json['WoonOppervlakte'] as num?)?.toInt(),
      plotArea: (json['PerceelOppervlakte'] as num?)?.toInt(),
      rooms: (json['AantalKamers'] as num?)?.toInt(),
      bedrooms: (json['AantalSlaapkamers'] as num?)?.toInt(),
      bathrooms: (json['AantalBadkamers'] as num?)?.toInt(),
      buildYear: json['Bouwjaar'] as String?,
      energyLabel: energyLabel?['Label'] as String?,
      description: json['VolledigeOmschrijving'] as String?,
      photoUrls: _parsePhotoUrls(json['Media']),
      latitude: (json['WGS84_Y'] as num?)?.toDouble(),
      longitude: (json['WGS84_X'] as num?)?.toDouble(),
      agentName: json['Makelaar'] as String?,
      agentPhone: json['MakelaarTelefoon'] as String?,
    );
  }

  /// Zet de ruwe API-data om naar het domain-model.
  Listing toDomain() {
    final lat = latitude;
    final lng = longitude;
    final name = _nonEmpty(agentName);

    return Listing(
      id: id,
      address: address,
      postalCode: postalCode,
      city: city,
      price: price,
      priceSuffix: priceSuffix,
      livingArea: livingArea,
      plotArea: plotArea,
      rooms: rooms,
      bedrooms: bedrooms,
      bathrooms: bathrooms,
      buildYear: buildYear,
      energyLabel: energyLabel,
      description: description,
      photoUrls: photoUrls,
      // Een locatie heeft alleen zin met beide coördinaten.
      location: (lat != null && lng != null)
          ? GeoLocation(latitude: lat, longitude: lng)
          : null,
      agent: name != null
          ? Agent(name: name, phone: _nonEmpty(agentPhone))
          : null,
    );
  }

  /// Haalt de foto-URL's uit de `Media`-lijst.
  ///
  /// Pak alleen Categorie 1 + hoogste breedte
  static List<String> _parsePhotoUrls(Object? media) {
    if (media is! List) return const [];

    return media
        .whereType<Map<String, dynamic>>()
        .where((item) => item['Categorie'] == 1)
        .map(_largestImageUrl)
        .whereType<String>() // filtert de nulls eruit
        .toList();
  }

  static String? _largestImageUrl(Map<String, dynamic> media) {
    final items =
        (media['MediaItems'] as List?)
            ?.whereType<Map<String, dynamic>>()
            .toList() ??
        const [];
    if (items.isEmpty) return null;

    final largest = items.reduce((a, b) => _width(a) >= _width(b) ? a : b);
    final url = (largest['UrlSecure'] ?? largest['Url']) as String?;

    // De API geeft http-URL's terug; Android en iOS blokkeren
    // onversleuteld verkeer standaard.
    return url?.replaceFirst('http://', 'https://');
  }

  /// Maakt van een lege of alleen-spaties string null, zodat de UI alleen
  /// nog op null hoeft te checken.
  static String? _nonEmpty(String? value) {
    final trimmed = value?.trim();
    return (trimmed == null || trimmed.isEmpty) ? null : trimmed;
  }

  static num _width(Map<String, dynamic> item) => (item['Width'] as num?) ?? 0;
}
