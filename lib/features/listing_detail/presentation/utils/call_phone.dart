import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../l10n/app_localizations.dart';

/// Opent de telefoon-app met [phone]. Lukt dat niet, dan volgt een SnackBar.
Future<void> callPhone(BuildContext context, String phone) async {
  // "020-1805189" → "0201805189": een tel:-URI mag alleen cijfers en +.
  final uri = Uri(
    scheme: 'tel',
    path: phone.replaceAll(RegExp(r'[^0-9+]'), ''),
  );
  // Geeft false terug als er niet gebeld kan worden
  var opened = false;
  try {
    opened = await launchUrl(uri);
  } on PlatformException {
    // Bijv. geen app beschikbaar die tel:-links kan openen.
  }
  if (!opened && context.mounted) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(AppLocalizations.of(context).callFailed)),
    );
  }
}
