import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:tv_series/tv_series.dart';

class TvSeriesDetailPage extends StatefulWidget {
  final int id;
  const TvSeriesDetailPage({
    Key? key,
    required this.id,
  }) : super(key: key);

  @override
  State<TvSeriesDetailPage> createState() => _TvSeriesDetailPageState();
}

class _TvSeriesDetailPageState extends State<TvSeriesDetailPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<TvSeriesDetailBloc>().add(OnFetchingDetail(widget.id));
      context
          .read<TvSeriesRecommendationBloc>()
          .add(OnFetchingRecommendation(widget.id));
      context.read<TvSeriesWatchlistBloc>().add(OnLoadingWatchlist(widget.id));
    });
  }

  @override
  Widget build(BuildContext context) {
    final watchlistBloc = BlocProvider.of<TvSeriesWatchlistBloc>(context);
    return Scaffold(
      body: BlocListener(
        bloc: watchlistBloc,
        listener: (BuildContext context, TvSeriesWatchlistState state) {
          if (state is TvSeriesWatchlistHasMessage) {
            if (state.message != null) {
              if (state.message == watchlistAddSuccessMessage ||
                  state.message == watchlistRemoveSuccessMessage) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.message!)),
                );
              } else {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      content: Text(state.message!),
                    );
                  },
                );
              }
            }
          }
        },
        child: BlocBuilder<TvSeriesDetailBloc, TvSeriesDetailState>(
          builder: (context, state) {
            if (state is TvSeriesDetailLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is TvSeriesDetailHasData) {
              final tvSeries = state.result;
              return SafeArea(
                child: DetailContent(
                  id: widget.id,
                  tvSeries: tvSeries,
                ),
              );
            } else if (state is TvSeriesDetailError) {
              return Center(
                key: const Key('error_message'),
                child: Text(state.message),
              );
            } else {
              return const SizedBox.shrink();
            }
          },
        ),
      ),
    );
  }
}

class DetailContent extends StatefulWidget {
  final int id;
  final TvSeriesDetail tvSeries;

  const DetailContent({
    Key? key,
    required this.id,
    required this.tvSeries,
  }) : super(key: key);

  @override
  State<DetailContent> createState() => _DetailContentState();
}

class _DetailContentState extends State<DetailContent> {
  bool isAllSeasonShowing = false;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        CachedNetworkImage(
          key: const Key('image_poster'),
          imageUrl:
              'https://image.tmdb.org/t/p/w500${widget.tvSeries.posterPath}',
          width: screenWidth,
          placeholder: (context, url) => const Center(
            child: CircularProgressIndicator(),
          ),
          errorWidget: (context, url, error) => const Icon(Icons.error),
        ),
        Container(
          margin: const EdgeInsets.only(top: 48 + 8),
          child: DraggableScrollableSheet(
            builder: (context, scrollController) {
              return Container(
                decoration: const BoxDecoration(
                  color: kRichBlack,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                padding: const EdgeInsets.only(
                  left: 16,
                  top: 16,
                  right: 16,
                ),
                child: Stack(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 16),
                      child: CustomScrollView(
                        controller: scrollController,
                        slivers: [
                          SliverToBoxAdapter(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.tvSeries.name ?? '',
                                  style: titleLarge,
                                ),
                                _watchlistView(),
                                Text(
                                  _showGenres(widget.tvSeries.genres ?? []),
                                ),
                                if (widget
                                        .tvSeries.episodeRunTime?.isNotEmpty ??
                                    false)
                                  Text(
                                    _showDuration(
                                        widget.tvSeries.episodeRunTime?.first ??
                                            0),
                                  ),
                                Row(
                                  children: [
                                    RatingBarIndicator(
                                      rating:
                                          (widget.tvSeries.voteAverage ?? 0) /
                                              2,
                                      itemCount: 5,
                                      itemBuilder: (context, index) =>
                                          const Icon(
                                        Icons.star,
                                        color: kMikadoYellow,
                                      ),
                                      itemSize: 24,
                                    ),
                                    Text('${widget.tvSeries.voteAverage}')
                                  ],
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'Overview',
                                  style: titleMedium,
                                ),
                                Text(
                                  widget.tvSeries.overview ?? '',
                                ),
                                const SizedBox(height: 16),
                              ],
                            ),
                          ),
                          _seasonHeaderView(),
                          _seasonListView(widget.tvSeries),
                          _recommendationView(),
                        ],
                      ),
                    ),
                    Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        color: Colors.white,
                        height: 4,
                        width: 48,
                      ),
                    ),
                  ],
                ),
              );
            },
            minChildSize: 0.25,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: kRichBlack,
            foregroundColor: Colors.white,
            child: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        )
      ],
    );
  }

  Widget _watchlistView() {
    return BlocBuilder<TvSeriesWatchlistBloc, TvSeriesWatchlistState>(
        builder: (context, state) {
      if (state is TvSeriesWatchlistEmpty) {
        return const ElevatedButton(
          onPressed: null,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.add),
              Text('Watchlist'),
            ],
          ),
        );
      } else if (state is TvSeriesWatchlistHasMessage) {
        final isAddedWatchlist = state.isAdded;

        return ElevatedButton(
          onPressed: () async {
            if (isAddedWatchlist == false) {
              context
                  .read<TvSeriesWatchlistBloc>()
                  .add(OnAddingWatchlist(widget.tvSeries));
            } else if (isAddedWatchlist == true) {
              context
                  .read<TvSeriesWatchlistBloc>()
                  .add(OnRemovingWatchlist(widget.tvSeries));
            }
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              isAddedWatchlist == true
                  ? const Icon(Icons.check)
                  : const Icon(Icons.add),
              const Text(
                'Watchlist',
                key: Key('watchlist_text'),
              ),
            ],
          ),
        );
      } else {
        return const SizedBox.shrink();
      }
    });
  }

  Widget _seasonHeaderView() {
    return BlocBuilder<TvSeriesDetailBloc, TvSeriesDetailState>(
      builder: (context, state) {
        final detailBloc = context.read<TvSeriesDetailBloc>();
        final seasonsLength = widget.tvSeries.seasons?.length ?? 0;

        return SliverToBoxAdapter(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (seasonsLength > 0)
                Text(
                  isAllSeasonShowing || seasonsLength == 1
                      ? 'All Season'
                      : 'Last Season',
                  style: titleMedium,
                ),
              if (seasonsLength > 1)
                InkWell(
                  key: const Key('season_button_toggle'),
                  onTap: () {
                    setState(() {
                      isAllSeasonShowing = !isAllSeasonShowing;
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Text(
                          isAllSeasonShowing ? 'Hide Other' : 'View All',
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _seasonListView(TvSeriesDetail tvSeries) {
    return BlocBuilder<TvSeriesDetailBloc, TvSeriesDetailState>(
      builder: (context, state) {
        if (tvSeries.seasons != null && tvSeries.seasons!.isNotEmpty) {
          final listSeason =
              isAllSeasonShowing ? tvSeries.seasons! : [tvSeries.seasons!.last];

          return SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final season = listSeason[index];
                return SeasonCard(
                  tvSeries: tvSeries,
                  season: season,
                );
              },
              childCount: listSeason.length,
            ),
          );
        } else {
          return const SliverToBoxAdapter(
            child: SizedBox.shrink(),
          );
        }
      },
    );
  }

  Widget _recommendationView() {
    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Recommendations',
            style: titleMedium,
          ),
          BlocBuilder<TvSeriesRecommendationBloc, TvSeriesRecommendationState>(
            builder: (context, state) {
              if (state is TvSeriesRecommendationLoading) {
                return const Center(
                  child: CircularProgressIndicator(
                    key: Key('recommendations_progress'),
                  ),
                );
              } else if (state is TvSeriesRecommendationHasData) {
                return SizedBox(
                  height: 150,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      final tvSeries = state.result[index];
                      return Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: InkWell(
                          onTap: () {
                            Navigator.pushReplacementNamed(
                              context,
                              detailTvSeriesRoute,
                              arguments: tvSeries.id,
                            );
                          },
                          child: ClipRRect(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(8),
                            ),
                            child: CachedNetworkImage(
                              key: const Key('recommendations_image'),
                              imageUrl:
                                  'https://image.tmdb.org/t/p/w500${tvSeries.posterPath}',
                              placeholder: (context, url) => const Center(
                                child: CircularProgressIndicator(),
                              ),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                            ),
                          ),
                        ),
                      );
                    },
                    itemCount: state.result.length,
                  ),
                );
              } else if (state is TvSeriesRecommendationError) {
                return Center(
                  key: const Key('error_message'),
                  child: Text(state.message),
                );
              } else {
                return const SizedBox.shrink();
              }
            },
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  String _showGenres(List<Genre> genres) {
    String result = '';
    for (var genre in genres) {
      result += '${genre.name}, ';
    }

    if (result.isEmpty) {
      return result;
    }

    return result.substring(0, result.length - 2);
  }

  String _showDuration(int runtime) {
    final int hours = runtime ~/ 60;
    final int minutes = runtime % 60;

    if (hours > 0) {
      return '${hours}h ${minutes}m';
    } else {
      return '${minutes}m';
    }
  }
}
