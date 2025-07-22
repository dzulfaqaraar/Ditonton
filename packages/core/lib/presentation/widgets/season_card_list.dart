import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';

class SeasonCard extends StatelessWidget {
  final TvSeriesDetail tvSeries;
  final Season season;

  const SeasonCard({super.key, required this.tvSeries, required this.season});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
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
        child: Stack(
          alignment: Alignment.bottomLeft,
          children: [
            Card(
              child: Container(
                margin: const EdgeInsets.only(
                  left: 16 + 80 + 16,
                  bottom: 8,
                  right: 8,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            season.name ?? '-',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: titleLarge,
                          ),
                          Row(
                            children: [
                              Text(
                                '${(season.airDate?.length ?? 0) > 3 ? season.airDate?.substring(0, 4) : ''}',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: bodyMedium,
                              ),
                              if ((season.airDate?.length ?? 0) > 3)
                                const SizedBox(
                                  height: 12,
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 8,
                                    ),
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
                          const SizedBox(height: 8),
                          Text(
                            season.overview ?? '-',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 16, bottom: 16),
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(8)),
                child: CachedNetworkImage(
                  key: const Key('season_image'),
                  imageUrl: '$baseImageUrl${season.posterPath}',
                  width: 80,
                  placeholder: (context, url) =>
                      const Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
