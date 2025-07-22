import 'package:core/core.dart';
import 'package:core/presentation/bloc/bloc_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tv_series/tv_series.dart';

class TvSeriesEpisodePage extends StatefulWidget {
  final EpisodeRequest request;

  const TvSeriesEpisodePage({super.key, required this.request});

  @override
  State<TvSeriesEpisodePage> createState() => _TvSeriesEpisodePageState();
}

class _TvSeriesEpisodePageState extends State<TvSeriesEpisodePage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (mounted) {
        context.read<TvSeriesEpisodeBloc>().add(
          OnFetchingEpisode(widget.request.id, widget.request.season),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.request.title ?? 'Episode')),
      body: BlocBuilder<TvSeriesEpisodeBloc, BlocState>(
        builder: (context, state) {
          if (state is BlocLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is BlocHasData<TvSeriesEpisode?>) {
            final episodes = state.result?.episodes;
            if (episodes != null && episodes.isNotEmpty) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: ListView.builder(
                  itemBuilder: (context, index) {
                    final episode = episodes[index];
                    return EpisodeCard(episode: episode);
                  },
                  itemCount: episodes.length,
                ),
              );
            } else {
              return const SizedBox.shrink();
            }
          } else if (state is BlocError) {
            return Center(
              key: const Key('error_message'),
              child: Text(state.message),
            );
          } else {
            return const SizedBox.shrink();
          }
        },
      ),
    );
  }
}
