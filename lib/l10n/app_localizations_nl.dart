// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Dutch Flemish (`nl`).
class AppLocalizationsNl extends AppLocalizations {
  AppLocalizationsNl([String locale = 'nl']) : super(locale);

  @override
  String get listingDetailTitle => 'Woningdetails';

  @override
  String photoLabel(int index, int total) {
    return 'Foto $index van $total';
  }

  @override
  String get addressUnknown => 'Adres onbekend';

  @override
  String get priceOnRequest => 'Prijs op aanvraag';

  @override
  String get errorNetwork => 'Geen verbinding. Controleer je internet.';

  @override
  String get errorNotFound => 'Deze woning is niet meer beschikbaar.';

  @override
  String get errorUnexpected => 'Er ging iets mis bij het laden.';

  @override
  String get retry => 'Opnieuw proberen';

  @override
  String get keyFactsTitle => 'Kenmerken';

  @override
  String get livingArea => 'Woonoppervlakte';

  @override
  String get plotArea => 'Perceel';

  @override
  String get rooms => 'Kamers';

  @override
  String get bedrooms => 'Slaapkamers';

  @override
  String get bathrooms => 'Badkamers';

  @override
  String get buildYear => 'Bouwjaar';

  @override
  String get energyLabel => 'Energielabel';

  @override
  String get descriptionTitle => 'Omschrijving';

  @override
  String get readMore => 'Lees meer';

  @override
  String get readLess => 'Lees minder';

  @override
  String get locationTitle => 'Locatie';

  @override
  String get openInMaps => 'Open in kaart-app';

  @override
  String get openInMapsFailed => 'Kon de kaart-app niet openen.';

  @override
  String get agentTitle => 'Makelaar';

  @override
  String get callAgent => 'Bellen';

  @override
  String get callFailed => 'Bellen is niet mogelijk op dit apparaat.';
}
