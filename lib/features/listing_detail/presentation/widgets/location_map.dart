import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/geo_location.dart';

class LocationMap extends StatelessWidget {
  const LocationMap({super.key, required this.location});

  final GeoLocation location;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    // Pas hier omzetten naar LatLng: de domain-laag kent latlong2 niet.
    final point = LatLng(location.latitude, location.longitude);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.locationTitle, style: theme.textTheme.titleMedium),
        const SizedBox(height: 8),
        Semantics(
          button: true,
          label: l10n.openInMaps,
          onTap: () => _openInMaps(context),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: SizedBox(
              height: 224,
              child: FlutterMap(
                options: MapOptions(
                  initialCenter: point,
                  initialZoom: 16,
                  // Geen slepen of zoomen: anders blijft de gebruiker in de
                  // kaart "hangen" tijdens het scrollen van de ListView.
                  interactionOptions: const InteractionOptions(
                    flags: InteractiveFlag.none,
                  ),
                  // Tikken werkt wel, ook zonder interactie-flags.
                  onTap: (_, _) => _openInMaps(context),
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    // Verplicht volgens de OSM tile usage policy.
                    userAgentPackageName: 'nl.hendrik.funda_listing',
                  ),
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: point,
                        width: 40,
                        height: 40,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: colorScheme.surface.withValues(alpha: 0.9),
                            shape: BoxShape.circle,
                            boxShadow: const [
                              BoxShadow(color: Colors.black38, blurRadius: 12),
                            ],
                          ),
                          child: Icon(
                            Icons.home_rounded,
                            size: 24,
                            color: colorScheme.primaryContainer,
                          ),
                        ),
                      ),
                    ],
                  ),
                  RichAttributionWidget(
                    attributions: [
                      TextSourceAttribution(
                        'OpenStreetMap contributors',
                        onTap: () => launchUrl(
                          Uri.parse('https://openstreetmap.org/copyright'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _openInMaps(BuildContext context) async {
    final coordinates = '${location.latitude},${location.longitude}';
    // Op iOS opent google.com/maps de browser als Google Maps niet is
    // geïnstalleerd; maps.apple.com opent altijd Apple Kaarten.
    final uri = Theme.of(context).platform == TargetPlatform.iOS
        ? Uri.https('maps.apple.com', '/', {'q': coordinates})
        : Uri.https('www.google.com', '/maps/search/', {
            'api': '1',
            'query': coordinates,
          });
    var opened = false;
    try {
      opened = await launchUrl(uri, mode: LaunchMode.externalApplication);
    } on PlatformException catch (e) {
      debugPrint('launchUrl mislukt: ${e.code} ${e.message}');
    }
    if (!opened && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context).openInMapsFailed)),
      );
    }
  }
}
