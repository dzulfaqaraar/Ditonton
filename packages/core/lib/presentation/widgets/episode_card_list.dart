import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';

class EpisodeCard extends StatefulWidget {
  final Episode episode;

  const EpisodeCard({super.key, required this.episode});

  @override
  State<EpisodeCard> createState() => _EpisodeCardState();
}

class _EpisodeCardState extends State<EpisodeCard> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _episodeHeader(),
          if (isExpanded) _episodeContent(),
          _episodeButton(),
        ],
      ),
    );
  }

  Widget _episodeHeader() {
    return Row(
      key: const Key('episode_header'),
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          child: CachedNetworkImage(
            imageUrl: '$baseImageUrl${widget.episode.stillPath}',
            width: 140,
            placeholder: (context, url) =>
                const Center(child: CircularProgressIndicator()),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              isExpanded
                  ? Text(
                      '${widget.episode.episodeNumber}. ${widget.episode.name}',
                      style: headlineSmall,
                    )
                  : Text(
                      '${widget.episode.episodeNumber}. ${widget.episode.name}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: headlineSmall,
                    ),
              const SizedBox(height: 8),
              if (!isExpanded)
                Text(
                  widget.episode.overview ?? '-',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: bodyMedium,
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _episodeContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        Text('Overview', style: titleLarge),
        const SizedBox(height: 8),
        Text(widget.episode.overview ?? '-', style: bodyMedium),
        const SizedBox(height: 8),
        if (widget.episode.guestStars.isNotEmpty)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Guest Stars', style: titleLarge),
              const SizedBox(height: 8),
              SizedBox(
                height: 120,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    final guestStars = widget.episode.guestStars[index];

                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Column(
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(8),
                            ),
                            child: CachedNetworkImage(
                              imageUrl:
                                  '$baseImageUrl${guestStars.profilePath}',
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => const Center(
                                child: CircularProgressIndicator(),
                              ),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Expanded(
                            child: SizedBox(
                              width: 80,
                              height: 36,
                              child: Center(
                                child: Text(
                                  guestStars.name ?? '-',
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  itemCount: widget.episode.guestStars.length,
                ),
              ),
            ],
          ),
      ],
    );
  }

  Widget _episodeButton() {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: InkWell(
        key: const Key('episode_card_item'),
        onTap: () {
          setState(() {
            isExpanded = !isExpanded;
          });
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(isExpanded ? Icons.arrow_drop_up : Icons.arrow_drop_down),
            Text(
              isExpanded ? 'Close' : 'Expand',
              style: titleMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
