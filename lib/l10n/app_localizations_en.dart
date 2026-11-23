// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get listingDetailTitle => 'Listing details';

  @override
  String photoLabel(int index, int total) {
    return 'Photo $index of $total';
  }

  @override
  String get addressUnknown => 'Address unknown';

  @override
  String get priceOnRequest => 'Price on request';

  @override
  String get errorNetwork => 'No connection. Check your internet.';

  @override
  String get errorNotFound => 'This listing is no longer available.';

  @override
  String get errorUnexpected => 'Something went wrong while loading.';

  @override
  String get retry => 'Try again';

  @override
  String get keyFactsTitle => 'Key facts';

  @override
  String get livingArea => 'Living area';

  @override
  String get plotArea => 'Plot';

  @override
  String get rooms => 'Rooms';

  @override
  String get bedrooms => 'Bedrooms';

  @override
  String get bathrooms => 'Bathrooms';

  @override
  String get buildYear => 'Year built';

  @override
  String get energyLabel => 'Energy label';

  @override
  String get descriptionTitle => 'Description';

  @override
  String get readMore => 'Read more';

  @override
  String get readLess => 'Read less';

  @override
  String get locationTitle => 'Location';

  @override
  String get openInMaps => 'Open in maps app';

  @override
  String get openInMapsFailed => 'Couldn\'t open the maps app.';

  @override
  String get agentTitle => 'Agent';

  @override
  String get callAgent => 'Call agent';

  @override
  String get callFailed => 'Calling isn\'t possible on this device.';

  @override
  String get askingPrice => 'Asking price';

  @override
  String get pricePerM2 => 'Price per m²';

  @override
  String pricePerM2Value(String price) {
    return '$price / m²';
  }

  @override
  String bedroomsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count bedrooms',
      one: '1 bedroom',
    );
    return '$_temp0';
  }

  @override
  String bathroomsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count bathrooms',
      one: '1 bathroom',
    );
    return '$_temp0';
  }
}
