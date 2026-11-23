import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_nl.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('nl'),
  ];

  /// Titel in de app bar van de detailpagina.
  ///
  /// In nl, this message translates to:
  /// **'Woningdetails'**
  String get listingDetailTitle;

  /// Screenreader-label voor een foto in de carousel.
  ///
  /// In nl, this message translates to:
  /// **'Foto {index} van {total}'**
  String photoLabel(int index, int total);

  /// Getoond als de woning geen adres heeft.
  ///
  /// In nl, this message translates to:
  /// **'Adres onbekend'**
  String get addressUnknown;

  /// Getoond als de woning geen vraagprijs heeft.
  ///
  /// In nl, this message translates to:
  /// **'Prijs op aanvraag'**
  String get priceOnRequest;

  /// Foutmelding bij geen verbinding of een time-out.
  ///
  /// In nl, this message translates to:
  /// **'Geen verbinding. Controleer je internet.'**
  String get errorNetwork;

  /// Foutmelding als de woning niet (meer) bestaat.
  ///
  /// In nl, this message translates to:
  /// **'Deze woning is niet meer beschikbaar.'**
  String get errorNotFound;

  /// Foutmelding bij een onverwachte fout.
  ///
  /// In nl, this message translates to:
  /// **'Er ging iets mis bij het laden.'**
  String get errorUnexpected;

  /// Knop om het laden opnieuw te proberen.
  ///
  /// In nl, this message translates to:
  /// **'Opnieuw proberen'**
  String get retry;

  /// Kop boven de kenmerken van de woning.
  ///
  /// In nl, this message translates to:
  /// **'Kenmerken'**
  String get keyFactsTitle;

  /// Label voor de woonoppervlakte.
  ///
  /// In nl, this message translates to:
  /// **'Woonoppervlakte'**
  String get livingArea;

  /// Label voor de perceeloppervlakte.
  ///
  /// In nl, this message translates to:
  /// **'Perceel'**
  String get plotArea;

  /// Label voor het aantal kamers.
  ///
  /// In nl, this message translates to:
  /// **'Kamers'**
  String get rooms;

  /// Label voor het aantal slaapkamers.
  ///
  /// In nl, this message translates to:
  /// **'Slaapkamers'**
  String get bedrooms;

  /// Label voor het aantal badkamers.
  ///
  /// In nl, this message translates to:
  /// **'Badkamers'**
  String get bathrooms;

  /// Label voor het bouwjaar of de bouwperiode.
  ///
  /// In nl, this message translates to:
  /// **'Bouwjaar'**
  String get buildYear;

  /// Label voor het energielabel.
  ///
  /// In nl, this message translates to:
  /// **'Energielabel'**
  String get energyLabel;

  /// Kop boven de omschrijving van de woning.
  ///
  /// In nl, this message translates to:
  /// **'Omschrijving'**
  String get descriptionTitle;

  /// Knop om de volledige omschrijving te tonen.
  ///
  /// In nl, this message translates to:
  /// **'Lees meer'**
  String get readMore;

  /// Knop om de omschrijving weer in te klappen.
  ///
  /// In nl, this message translates to:
  /// **'Lees minder'**
  String get readLess;

  /// Kop boven de kaart met de ligging van de woning.
  ///
  /// In nl, this message translates to:
  /// **'Locatie'**
  String get locationTitle;

  /// Screenreader-label en actie van de kaart: opent de locatie in Google Maps (Android) of Apple Kaarten (iOS).
  ///
  /// In nl, this message translates to:
  /// **'Open in kaart-app'**
  String get openInMaps;

  /// Melding als de kaart-app niet geopend kan worden.
  ///
  /// In nl, this message translates to:
  /// **'Kon de kaart-app niet openen.'**
  String get openInMapsFailed;

  /// Kop boven de kaart met de makelaar.
  ///
  /// In nl, this message translates to:
  /// **'Makelaar'**
  String get agentTitle;

  /// Knop in de balk onderin om de makelaar te bellen.
  ///
  /// In nl, this message translates to:
  /// **'Bel makelaar'**
  String get callAgent;

  /// Melding als de telefoon-app niet geopend kan worden, bijv. op een simulator.
  ///
  /// In nl, this message translates to:
  /// **'Bellen is niet mogelijk op dit apparaat.'**
  String get callFailed;

  /// Label boven de vraagprijs.
  ///
  /// In nl, this message translates to:
  /// **'Vraagprijs'**
  String get askingPrice;

  /// Label boven de prijs per vierkante meter woonoppervlakte.
  ///
  /// In nl, this message translates to:
  /// **'Prijs per m²'**
  String get pricePerM2;

  /// Prijs per m², bijv. "€ 11.579 / m²".
  ///
  /// In nl, this message translates to:
  /// **'{price} / m²'**
  String pricePerM2Value(String price);

  /// Aantal slaapkamers onder het aantal kamers.
  ///
  /// In nl, this message translates to:
  /// **'{count, plural, =1{1 slaapkamer} other{{count} slaapkamers}}'**
  String bedroomsCount(int count);

  /// Aantal badkamers onder het aantal kamers.
  ///
  /// In nl, this message translates to:
  /// **'{count, plural, =1{1 badkamer} other{{count} badkamers}}'**
  String bathroomsCount(int count);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'nl'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'nl':
      return AppLocalizationsNl();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
