import 'package:core/core.dart';
import 'package:flutter/material.dart';

class SeasonCard extends StatelessWidget {
  final TvSeriesDetail tvSeries;
  final Season season;

  const SeasonCard({super.key, required this.tvSeries, required this.season});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Stack(
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(8)),
                child: CustomCachedImage(
                  key: const Key('season_image'),
                  imageUrl: '$baseImageUrl${season.posterPath}',
                  height: 150,
                ),
              ),
              Expanded(
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                  child: Container(
                    margin: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 16),
                        Text(
                          season.name ?? '-',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: titleLarge,
                        ),
                        Row(
                          children: [
                            if ((season.airDate?.length ?? 0) > 3)
                              Text(
                                '${season.airDate?.substring(0, 4)}',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: bodyMedium,
                              ),
                            if ((season.airDate?.length ?? 0) > 3)
                              const SizedBox(
                                height: 12,
                                child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 8),
                                  child: VerticalDivider(
                                    thickness: 1,
                                    width: 1,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            Expanded(
                              child: Text(
                                '${season.episodeCount} Episodes',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: bodyMedium,
                              ),
                            ),
                          ],
                        ),
                        if (season.overview != null &&
                            season.overview!.isNotEmpty)
                          const SizedBox(height: 8),
                        if (season.overview != null &&
                            season.overview!.isNotEmpty)
                          Text(
                            season.overview ?? '',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          Positioned.fill(
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(8)),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  key: const Key('season_card_item'),
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      episodeTvSeriesRoute,
                      arguments: EpisodeRequest(
                        title: tvSeries.name,
                        id: tvSeries.id,
                        season: season.seasonNumber ?? -1,
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
