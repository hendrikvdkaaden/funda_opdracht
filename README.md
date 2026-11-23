# Funda – Listing detail

Een kleine Flutter-app die de details van een woning ophaalt uit de Funda Aanbod-API en toont: foto's, adres en prijs, kenmerken, omschrijving, locatie op de kaart en de makelaar.

## Starten

**Vereist:** Flutter 3.47.9 (Dart 3.13.7). De code gebruikt recente Dart-features (private named parameters, wildcard-variabelen), dus een oudere SDK compileert het project niet.

1. Kopieer `config.example.json` naar `config.json` en vul de API-key in. `config.json` staat in `.gitignore`.
2. Start de app:
   ```bash
   flutter run --dart-define-from-file=config.json
   ```
   Een andere woning tonen kan met `--dart-define=LISTING_ID=<id>`.
3. Tests draaien:
   ```bash
   flutter test
   ```

Zonder key stopt de app direct met een duidelijke melding, in plaats van een onduidelijke 401.

## Architectuur

De feature is opgezet als zelfstandige module met Clean Architecture-lagen:

```
lib/
  core/app_config.dart         → API-key en base-URL via --dart-define
  core/app_theme.dart          → licht en donker thema (kleuren uit het design)
  l10n/                        → vertalingen (ARB, Nederlands en Engels)
  features/listing_detail/
    domain/                    → Listing-entity, repository-interface, failures
    data/                      → DTO + mapping, remote data source, repository-implementatie
    presentation/              → bloc (events/states), page, widgets
  main.dart                    → composition root
```

- **De domain-laag kent geen Flutter, HTTP of JSON.** Hij hangt alleen af van `equatable`.
- **`main.dart` is de enige plek die de concrete implementaties kent.** De rest van de app hangt af van de `ListingRepository`-interface. Dit sluit aan bij de aanpak uit Funda's blog [Scaling Flutter development: UI composition in a multi-team setup](https://blog.funda.nl/scaling-flutter-development-ui-composition-in-a-multi-team-setup/): een feature als eigen eenheid en dependency inversion via een composition root.

## Keuzes en afwegingen

**Data**
- **Aparte DTO naast de entity.** Alle eigenaardigheden van de API worden op één plek in `ListingDto.toDomain()` opgelost. Verandert de API, dan hoeft alleen de mapping aangepast te worden.
- **Bijna alle velden zijn nullable.** De API levert mocked data die zichzelf tegenspreekt: `AantalSlaapkamers` is `null`, de kenmerken noemen 9 slaapkamers en de omschrijving 5. Ik raad niet door strings te parsen. De UI toont alleen wat er is. Alleen de id is verplicht.
- **Opschonen gebeurt in de mapping.** Lege strings worden daar `null`, zodat de UI alleen nog op `null` hoeft te checken.
- **Getypeerde velden in plaats van HTML.** `PrijsGeformatteerd` en `Kenmerken` bevatten HTML (`<span>`, `&nbsp;`). Ik gebruik `KoopPrijs`, `WoonOppervlakte` enzovoort, en formatteer zelf, afhankelijk van de locale.
- **Valkuilen in de data:**
  - `WGS84_X` is de lengtegraad en `WGS84_Y` de breedtegraad.
  - Foto-URL's zijn `http://`. Android en iOS blokkeren dat standaard, dus ze worden herschreven naar `https://`.
  - `Media` bevat ook een video (Categorie 4) en een pdf (Categorie 3). Alleen Categorie 1 (foto's) wordt gebruikt, telkens in het grootste formaat.
  - Getallen worden gelezen als `num` en daarna omgezet, omdat JSON geen verschil maakt tussen `4` en `4.0`.
- **UTF-8 expliciet decoderen.** De data source decodeert `response.bodyBytes` zelf als UTF-8, zodat hij niet afhangt van de headers. Zonder Content-Type valt `response.body` terug op Latin-1 en verminkt dan tekens als `•` en `²`. Een test dekt dit af.

**Foutafhandeling**
- De repository vertaalt technische fouten naar een `sealed class ListingFailure` (`NetworkFailure`, `NotFoundFailure`, `UnexpectedFailure`). De bloc en de UI kennen geen HTTP.
- De UI gebruikt een exhaustive `switch`. Komt er een nieuw fouttype bij, dan geeft de compiler aan waar het nog afgehandeld moet worden. Bij `NotFoundFailure` is er geen retry-knop, omdat opnieuw proberen dan geen zin heeft.

**State management**
- `flutter_bloc` met sealed events en states.
- `restartable()` (bloc_concurrency): een nieuw verzoek annuleert het lopende, zodat een traag oud antwoord nooit een nieuwer antwoord overschrijft.
- State die alleen over de UI gaat (huidige foto, uitgeklapte omschrijving) blijft in de widget en hoort niet in de bloc.

**Packages**
- `http` in plaats van Dio: één GET-request heeft geen interceptors nodig.
- `flutter_map` met OpenStreetMap in plaats van Google Maps: geen API-key en geen platformconfiguratie nodig. Met attributie en user-agent volgens de OSM tile usage policy.
- `cached_network_image` voor de foto's en `url_launcher` om te bellen en om de kaart te openen.

**UI**
- De kaart staat niet-interactief in de scrollende lijst, om gesture-conflicten te voorkomen. Tikken opent de locatie extern: in Apple Maps op iOS, en in Google Maps op andere platformen.
- Localisatie via ARB vanaf het begin, met een Nederlandse en een Engelse vertaling.
- **Toegankelijkheid:**
  - Foto's hebben een label "Foto X van N" en de visuele teller is uitgesloten met `ExcludeSemantics`.
  - De kaart is als knop bereikbaar via `Semantics`.
  - De energielabels hebben zwarte tekst, zodat alle kleuren WCAG AA-contrast halen.
  - De tekstmeting in de omschrijving houdt rekening met `textScaler`.

## Tests

| Laag | Wat er getest wordt |
|---|---|
| DTO | Mapping van de echte API-response (fixture), inclusief edge cases: ontbrekende of lege velden, de volgorde van fotoformaten, double in plaats van int |
| Data source | URL-opbouw, statuscodes, UTF-8 zonder Content-Type-header, timeout (met `MockClient`) |
| Repository | Elke exception → de juiste `ListingFailure` |
| Bloc | Succes, fout, en dat `restartable()` een oud antwoord negeert |
| Widget | `ListingErrorView` met en zonder retry-knop; `ListingDetailView` (adres, prijs, prijs per m², kenmerken, makelaar) en `PriceCallBar` zonder telefoonnummer |

- De mocks laten de data source falen met `Future.error` en niet met `thenThrow`. De echte data source faalt asynchroon, dus zo vangt de test ook een vergeten `await` in de repository.
- Belangrijke tests zijn gecontroleerd met mutaties: een bug inbouwen en controleren dat de test rood wordt. De restartable-test faalt bijvoorbeeld zonder de transformer.

## Gebruik van AI

Ik heb deze opdracht gemaakt met Claude (Anthropic), op twee manieren.

**1. Als mentor en reviewer (chat).** Ik heb de eerste versies van de entity, de DTO, de data source, de repository, de bloc met events en states, de page en `main.dart` zelf geschreven. Claude reviewde ze en legde uit wat er mis was, bijvoorbeeld:
- `fromJson` hoorde niet in de entity.
- Mijn state-klasse `Error` botste met `dart:core`.
  
Waar ik vastliep, kreeg ik een gecorrigeerde versie die ik heb overgenomen. Dat geldt voor de DTO-mapping, de data source, de foutvertaling in de repository en de `ListingErrorView`. Ook de analyse van de API-response, de keuze van packages en de teststrategie heb ik in dit gesprek uitgewerkt.

**2. Als codeschrijver (Claude Code).** Per stap gaf ik aan wat er moest komen en welke eisen erbij hoorden. Claude schreef daarop de code:
- de UI-widgets (header, carousel, kenmerken, omschrijving, kaart, makelaarskaart);
- de localisatie;
- de platformconfiguratie;
- de UTF-8-fix en de opschoning van lege strings;
- de tests.
  Ik heb die code gereviewd, bijgestuurd en me elk onderdeel laten uitleggen, tot ik het zelf kon verdedigen.

**Controle.** AI zat er ook weleens naast. Zo werd gezegd dat `required this._client` niet zou compileren, terwijl mijn analyzer liet zien dat recente Dart-versies private named parameters ondersteunen. Ik heb AI-output daarom gecontroleerd tegen de compiler, de echte API en de tests. Ook de tests zelf heb ik met mutaties gecontroleerd.
