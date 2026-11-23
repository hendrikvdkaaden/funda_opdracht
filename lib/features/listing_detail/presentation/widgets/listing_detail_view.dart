import 'package:flutter/material.dart';
import 'package:funda_listing/features/listing_detail/presentation/widgets/agent_card.dart';
import 'package:funda_listing/features/listing_detail/presentation/widgets/description_section.dart';
import 'package:funda_listing/features/listing_detail/presentation/widgets/key_facts.dart';
import 'package:funda_listing/features/listing_detail/presentation/widgets/listing_header.dart';
import 'package:funda_listing/features/listing_detail/presentation/widgets/location_map.dart';
import 'package:funda_listing/features/listing_detail/presentation/widgets/photo_carousel.dart';

import '../../domain/entities/listing.dart';

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
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListingHeader(listing: listing),
              const SizedBox(height: 24),
              KeyFacts(listing: listing),
              if (description != null && description.isNotEmpty) ...[
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
