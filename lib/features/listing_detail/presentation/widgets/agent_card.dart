import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/agent.dart';

class AgentCard extends StatelessWidget {
  const AgentCard({super.key, required this.agent});

  final Agent agent;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final textTheme = Theme.of(context).textTheme;
    final phone = agent.phone;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.agentTitle, style: textTheme.titleMedium),
        const SizedBox(height: 12),
        Card.outlined(
          margin: EdgeInsets.zero,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const CircleAvatar(child: Icon(Icons.business_outlined)),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(agent.name, style: textTheme.titleSmall),
                      if (phone != null)
                        Text(phone, style: textTheme.bodyMedium),
                    ],
                  ),
                ),
                // Zonder telefoonnummer valt er niets te bellen.
                if (phone != null) ...[
                  const SizedBox(width: 8),
                  FilledButton.icon(
                    onPressed: () => _call(context, phone),
                    icon: const Icon(Icons.phone),
                    label: Text(l10n.callAgent),
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _call(BuildContext context, String phone) async {
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
}
