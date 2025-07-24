import 'package:core/core.dart';
import 'package:flutter/material.dart';

class TvSeriesCard extends StatelessWidget {
  final TvSeries tvSeries;

  const TvSeriesCard({super.key, required this.tvSeries});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: InkWell(
        key: const Key('tv_series_card_item'),
        onTap: () {
          Navigator.pushNamed(
            context,
            detailTvSeriesRoute,
            arguments: tvSeries.id,
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
                            tvSeries.name ?? '-',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: titleLarge,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            tvSeries.overview ?? '-',
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
                child: CustomCachedImage(
                  imageUrl: '$baseImageUrl${tvSeries.posterPath}',
                  width: 80,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
