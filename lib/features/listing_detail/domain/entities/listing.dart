import 'package:equatable/equatable.dart';

import 'agent.dart';
import 'geo_location.dart';

class Listing extends Equatable {
  const Listing({
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
    this.location,
    this.agent,
  });

  final String id;
  final String? address;
  final String? postalCode;
  final String? city;

  /// Vraagprijs in hele euro's.
  final int? price;

  /// Bijv. "k.k." (kosten koper) of "v.o.n." (vrij op naam).
  final String? priceSuffix;

  /// Woonoppervlakte in m².
  final int? livingArea;

  /// Perceeloppervlakte in m².
  final int? plotArea;
  final int? rooms;
  final int? bedrooms;
  final int? bathrooms;

  /// String, omdat de API ook periodes kan geven, zoals "1906-1930".
  final String? buildYear;
  final String? energyLabel;
  final String? description;

  /// Leeg als er geen foto's zijn.
  final List<String> photoUrls;
  final GeoLocation? location;
  final Agent? agent;

  @override
  List<Object?> get props => [
    id,
    address,
    postalCode,
    city,
    price,
    priceSuffix,
    livingArea,
    plotArea,
    rooms,
    bedrooms,
    bathrooms,
    buildYear,
    energyLabel,
    description,
    photoUrls,
    location,
    agent,
  ];
}
