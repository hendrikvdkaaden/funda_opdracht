import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';

class PhotoCarousel extends StatefulWidget {
  const PhotoCarousel({super.key, required this.urls});

  final List<String> urls;

  @override
  State<PhotoCarousel> createState() => _PhotoCarouselState();
}

class _PhotoCarouselState extends State<PhotoCarousel> {
  final _controller = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final total = widget.urls.length;

    return AspectRatio(
      aspectRatio: 3 / 2,
      child: Stack(
        fit: StackFit.expand,
        children: [
          PageView.builder(
            controller: _controller,
            itemCount: total,
            onPageChanged: (index) => setState(() => _currentPage = index),
            itemBuilder: (context, index) {
              return Semantics(
                label: AppLocalizations.of(context)
                    .photoLabel(index + 1, total),
                image: true,
                child: CachedNetworkImage(
                  imageUrl: widget.urls[index],
                  fit: BoxFit.cover,
                  placeholder: (context, url) =>
                      const Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) =>
                      const Center(child: Icon(Icons.broken_image_outlined)),
                ),
              );
            },
          ),
          // Vignet, zodat de teller op elke foto leesbaar is.
          IgnorePointer(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    colorScheme.surface.withValues(alpha: 0.7),
                    colorScheme.surface.withValues(alpha: 0),
                    colorScheme.surface.withValues(alpha: 0.3),
                  ],
                  stops: const [0, 0.45, 1],
                ),
              ),
            ),
          ),
          // Het foto-label zegt al welke foto het is.
          Positioned(
            right: 16,
            bottom: 16,
            child: ExcludeSemantics(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerLowest.withValues(
                    alpha: 0.8,
                  ),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.photo_library_outlined,
                      size: 14,
                      color: colorScheme.primary,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '${_currentPage + 1} / $total',
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
