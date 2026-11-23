import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:funda_listing/features/listing_detail/data/models/listing_dto.dart';

void main() {
  late Map<String, dynamic> json;

  setUp(() {
    json = jsonDecode(
      File('test/fixtures/listing_detail.json').readAsStringSync(),
    ) as Map<String, dynamic>;
  });

  /// De MediaItems van de eerste foto (Categorie 1) in de fixture.
  List<dynamic> firstPhotoItems() =>
      ((json['Media'] as List).first as Map<String, dynamic>)['MediaItems']
          as List<dynamic>;

  group('ListingDto.fromJson', () {
    // Alleen de id is verplicht: zonder id is er geen woning. De repository
    // maakt van deze fout een UnexpectedFailure.
    test('gooit een fout als InternalId ontbreekt', () {
      json.remove('InternalId');

      expect(() => ListingDto.fromJson(json), throwsA(isA<TypeError>()));
    });
  });

  group('ListingDto.toDomain', () {
    group('locatie', () {
      test('zet WGS84_Y om naar latitude en WGS84_X naar longitude', () {
        final listing = ListingDto.fromJson(json).toDomain();

        expect(listing.location?.latitude, 52.350456);
        expect(listing.location?.longitude, 4.865066);
      });

      test('geeft geen locatie als een coördinaat ontbreekt', () {
        json.remove('WGS84_X');

        final listing = ListingDto.fromJson(json).toDomain();

        expect(listing.location, isNull);
      });
    });

    group('foto\'s', () {
      test('neemt alleen foto\'s uit Categorie 1 mee', () {
        // De fixture heeft 10 media-items, waarvan 8 in Categorie 1.
        final listing = ListingDto.fromJson(json).toDomain();

        expect(listing.photoUrls, hasLength(8));
      });

      test('zet elke foto-URL om naar https', () {
        // In de fixture begint ook UrlSecure met http://.
        final listing = ListingDto.fromJson(json).toDomain();

        expect(listing.photoUrls, everyElement(startsWith('https://')));
      });

      test('kiest per foto het grootste formaat', () {
        final listing = ListingDto.fromJson(json).toDomain();

        expect(listing.photoUrls, everyElement(endsWith('_grotere.jpg')));
      });

      test('kiest het grootste formaat ook als dat niet als laatste staat', () {
        final items = firstPhotoItems();
        final reversed = items.reversed.toList();
        items
          ..clear()
          ..addAll(reversed);

        final listing = ListingDto.fromJson(json).toDomain();

        expect(listing.photoUrls.first, endsWith('_grotere.jpg'));
      });

      test('valt terug op Url als UrlSecure ontbreekt', () {
        for (final item in firstPhotoItems()) {
          (item as Map<String, dynamic>).remove('UrlSecure');
        }

        final listing = ListingDto.fromJson(json).toDomain();

        expect(
          listing.photoUrls.first,
          'https://cloud.funda.nl/valentina_media/223/522/328_grotere.jpg',
        );
      });

      test('slaat een foto zonder MediaItems over', () {
        firstPhotoItems().clear();

        final listing = ListingDto.fromJson(json).toDomain();

        expect(listing.photoUrls, hasLength(7));
      });

      test('geeft een lege lijst als Media ontbreekt', () {
        json.remove('Media');

        final listing = ListingDto.fromJson(json).toDomain();

        expect(listing.photoUrls, isEmpty);
      });
    });

    group('prijs', () {
      test('leest de vraagprijs als hele euro\'s', () {
        final listing = ListingDto.fromJson(json).toDomain();

        expect(listing.price, 4400000);
      });

      test('crasht niet als de prijs als double binnenkomt', () {
        // JSON kent geen verschil tussen 4400000 en 4400000.0.
        json['KoopPrijs'] = 4400000.0;

        final listing = ListingDto.fromJson(json).toDomain();

        expect(listing.price, 4400000);
      });

      test('haalt het prijsachtervoegsel uit Prijs.KoopAbbreviation', () {
        final listing = ListingDto.fromJson(json).toDomain();

        expect(listing.priceSuffix, 'k.k.');
      });

      test('geeft geen prijsachtervoegsel als Prijs ontbreekt', () {
        json.remove('Prijs');

        final listing = ListingDto.fromJson(json).toDomain();

        expect(listing.priceSuffix, isNull);
      });
    });

    group('kenmerken', () {
      test('laat bedrooms null als AantalSlaapkamers null is', () {
        final listing = ListingDto.fromJson(json).toDomain();

        expect(listing.bedrooms, isNull);
      });

      test('leest de overige kenmerken uit de JSON', () {
        final listing = ListingDto.fromJson(json).toDomain();

        expect(listing.livingArea, 380);
        expect(listing.plotArea, 130);
        expect(listing.rooms, 10);
        expect(listing.bathrooms, 1);
        expect(listing.buildYear, '1930');
      });

      test('haalt het energielabel uit Energielabel.Label', () {
        final listing = ListingDto.fromJson(json).toDomain();

        expect(listing.energyLabel, 'E');
      });
    });

    test('maakt lege of alleen-spaties strings null', () {
      json
        ..['Adres'] = ''
        ..['Postcode'] = ' '
        ..['Plaats'] = ''
        ..['Bouwjaar'] = ''
        ..['VolledigeOmschrijving'] = '  '
        ..['Energielabel'] = {'Label': ''};
      (json['Prijs'] as Map<String, dynamic>)['KoopAbbreviation'] = '';

      final listing = ListingDto.fromJson(json).toDomain();

      expect(listing.address, isNull);
      expect(listing.postalCode, isNull);
      expect(listing.city, isNull);
      expect(listing.buildYear, isNull);
      expect(listing.description, isNull);
      expect(listing.energyLabel, isNull);
      expect(listing.priceSuffix, isNull);
    });

    group('makelaar', () {
      test('maakt een makelaar met naam en telefoonnummer', () {
        final listing = ListingDto.fromJson(json).toDomain();

        expect(listing.agent?.name, 'DAMSTAD');
        expect(listing.agent?.phone, '020-1805189');
      });

      test('geeft geen makelaar als de naam leeg is', () {
        json['Makelaar'] = '   ';

        final listing = ListingDto.fromJson(json).toDomain();

        expect(listing.agent, isNull);
      });

      test('maakt het telefoonnummer null als het leeg is', () {
        json['MakelaarTelefoon'] = '';

        final listing = ListingDto.fromJson(json).toDomain();

        expect(listing.agent, isNotNull);
        expect(listing.agent?.phone, isNull);
      });

      test('verwijdert spaties rond het telefoonnummer', () {
        json['MakelaarTelefoon'] = ' 020-1805189 ';

        final listing = ListingDto.fromJson(json).toDomain();

        expect(listing.agent?.phone, '020-1805189');
      });
    });
  });
}
