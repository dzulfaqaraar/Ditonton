import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/core.dart';
import 'package:core/presentation/bloc/bloc_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tv_series/tv_series.dart';

class TvSeriesPage extends StatefulWidget {
  const TvSeriesPage({super.key});

  @override
  State<TvSeriesPage> createState() => _TvSeriesPageState();
}

class _TvSeriesPageState extends State<TvSeriesPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (mounted) {
        context.read<AiringTodayTvSeriesBloc>().add(
          const OnFetchingAiringToday(),
        );
        context.read<PopularTvSeriesBloc>().add(const OnFetchingPopular());
        context.read<TopRatedTvSeriesBloc>().add(const OnFetchingTopRated());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SubHeadingView(
            title: 'Airing Today',
            onTap: () => Navigator.pushNamed(context, airingTodayTvSeriesRoute),
          ),
          BlocBuilder<AiringTodayTvSeriesBloc, BlocState>(
            builder: (context, state) {
              if (state is BlocLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is BlocHasData<List<TvSeries>>) {
                return TvSeriesList(tvSeriesList: state.result);
              } else {
                return const Text('Failed');
              }
            },
          ),
          SubHeadingView(
            title: 'Popular',
            onTap: () => Navigator.pushNamed(context, popularTvSeriesRoute),
          ),
          BlocBuilder<PopularTvSeriesBloc, BlocState>(
            builder: (context, state) {
              if (state is BlocLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is BlocHasData<List<TvSeries>>) {
                return TvSeriesList(tvSeriesList: state.result);
              } else {
                return const Text('Failed');
              }
            },
          ),
          SubHeadingView(
            title: 'Top Rated',
            onTap: () => Navigator.pushNamed(context, topRatedTvSeriesRoute),
          ),
          BlocBuilder<TopRatedTvSeriesBloc, BlocState>(
            builder: (context, state) {
              if (state is BlocLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is BlocHasData<List<TvSeries>>) {
                return TvSeriesList(tvSeriesList: state.result);
              } else {
                return const Text('Failed');
              }
            },
          ),
        ],
      ),
    );
  }
}

class TvSeriesList extends StatelessWidget {
  final List<TvSeries> tvSeriesList;

  const TvSeriesList({super.key, required this.tvSeriesList});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.only(left: 16),
        itemBuilder: (context, index) {
          final tvSeries = tvSeriesList[index];
          return Container(
            margin: const EdgeInsets.only(right: 16),
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(16)),
              child: Stack(
                children: [
                  CachedNetworkImage(
                    imageUrl: '$baseImageUrl${tvSeries.posterPath}',
                    placeholder: (context, url) =>
                        const Center(child: CircularProgressIndicator()),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  ),
                  Positioned.fill(
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        key: const Key('card_item_key'),
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            detailTvSeriesRoute,
                            arguments: tvSeries.id,
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        itemCount: tvSeriesList.length,
      ),
    );
  }
}
