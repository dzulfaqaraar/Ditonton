import 'package:core/core.dart';
import 'package:flutter/material.dart';

class MovieCard extends StatelessWidget {
  final Movie movie;

  const MovieCard({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: InkWell(
        key: const Key('movie_card_item'),
        onTap: () {
          Navigator.pushNamed(context, detailMovieRoute, arguments: movie.id);
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
                            movie.title ?? '-',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: titleLarge,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            movie.overview ?? '-',
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
                  imageUrl: '$baseImageUrl${movie.posterPath}',
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
