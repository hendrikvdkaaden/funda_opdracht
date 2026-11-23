import 'package:flutter/material.dart';

import '../../domain/entities/listing.dart';
import 'agent_card.dart';
import 'description_section.dart';
import 'key_facts.dart';
import 'listing_header.dart';
import 'location_map.dart';
import 'photo_carousel.dart';

class ListingDetailView extends StatelessWidget {
  const ListingDetailView({super.key, required this.listing});

  final Listing listing;

  @override
  Widget build(BuildContext context) {
    final description = listing.description;
    final location = listing.location;
    final agent = listing.agent;

    return ListView(
      children: [
        if (listing.photoUrls.isNotEmpty)
          PhotoCarousel(urls: listing.photoUrls),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListingHeader(listing: listing),
              const SizedBox(height: 24),
              KeyFacts(listing: listing),
              if (description != null) ...[
                const SizedBox(height: 24),
                DescriptionSection(description: description),
              ],
              if (location != null) ...[
                const SizedBox(height: 24),
                LocationMap(location: location),
              ],
              if (agent != null) ...[
                const SizedBox(height: 24),
                AgentCard(agent: agent),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
