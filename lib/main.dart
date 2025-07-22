import 'package:about/about.dart';
import 'package:core/core.dart';
import 'package:core/environment/environment.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:movies/movies.dart';
import 'package:provider/provider.dart';
import 'package:search/search.dart';
import 'package:tv_series/tv_series.dart';
import 'package:watchlist/watchlist.dart';

import 'home_page.dart';
import 'injection.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Environment.flavorName = const String.fromEnvironment(
    "env",
    defaultValue: "develop",
  );
  await dotenv.load(fileName: Environment.fileName);

  final sslCert = await rootBundle.load('certificates/certificates.pem');
  di.init(sslCert);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        BlocProvider(create: (_) => di.locator<SearchBloc>()),
        BlocProvider(create: (_) => di.locator<WatchlistBloc>()),
        BlocProvider(create: (_) => di.locator<MovieDetailBloc>()),
        BlocProvider(create: (_) => di.locator<MovieRecommendationBloc>()),
        BlocProvider(create: (_) => di.locator<MovieWatchlistBloc>()),
        BlocProvider(create: (_) => di.locator<PopularMoviesBloc>()),
        BlocProvider(create: (_) => di.locator<TopRatedMoviesBloc>()),
        BlocProvider(create: (_) => di.locator<MovieListBloc>()),
        BlocProvider(create: (_) => di.locator<AiringTodayTvSeriesBloc>()),
        BlocProvider(create: (_) => di.locator<PopularTvSeriesBloc>()),
        BlocProvider(create: (_) => di.locator<TopRatedTvSeriesBloc>()),
        BlocProvider(create: (_) => di.locator<TvSeriesDetailBloc>()),
        BlocProvider(create: (_) => di.locator<TvSeriesRecommendationBloc>()),
        BlocProvider(create: (_) => di.locator<TvSeriesWatchlistBloc>()),
        BlocProvider(create: (_) => di.locator<TvSeriesEpisodeBloc>()),
      ],
      child: MaterialApp(
        title: 'Ditonton',
        theme: ThemeData.dark().copyWith(
          colorScheme: kColorScheme,
          primaryColor: kRichBlack,
          scaffoldBackgroundColor: kRichBlack,
          textTheme: TextTheme(
            headlineSmall: headlineSmall,
            titleLarge: titleLarge,
            titleMedium: titleMedium,
            bodyMedium: bodyMedium,
          ),
        ),
        home: HomePage(),
        navigatorObservers: [routeObserver],
        onGenerateRoute: (RouteSettings settings) {
          switch (settings.name) {
            case '/home':
              return MaterialPageRoute(builder: (_) => HomePage());
            case popularMovieRoute:
              return CupertinoPageRoute(builder: (_) => PopularMoviesPage());
            case topRatedMovieRoute:
              return CupertinoPageRoute(builder: (_) => TopRatedMoviesPage());
            case detailMovieRoute:
              final id = settings.arguments as int;
              return MaterialPageRoute(
                builder: (_) => MovieDetailPage(id: id),
                settings: settings,
              );
            case airingTodayTvSeriesRoute:
              return CupertinoPageRoute(
                builder: (_) => AiringTodayTvSeriesPage(),
              );
            case popularTvSeriesRoute:
              return CupertinoPageRoute(builder: (_) => PopularTvSeriesPage());
            case topRatedTvSeriesRoute:
              return CupertinoPageRoute(builder: (_) => TopRatedTvSeriesPage());
            case detailTvSeriesRoute:
              final id = settings.arguments as int;
              return MaterialPageRoute(
                builder: (_) => TvSeriesDetailPage(id: id),
                settings: settings,
              );
            case episodeTvSeriesRoute:
              final request = settings.arguments as EpisodeRequest;
              return MaterialPageRoute(
                builder: (_) => TvSeriesEpisodePage(request: request),
                settings: settings,
              );
            case aboutRoute:
              return MaterialPageRoute(builder: (_) => AboutPage());
            case searchRoute:
              final isMovies = settings.arguments as bool;
              return CupertinoPageRoute(
                builder: (_) => SearchPage(isMovies: isMovies),
                settings: settings,
              );
            case watchlistRoute:
              return MaterialPageRoute(builder: (_) => WatchlistPage());
            default:
              return MaterialPageRoute(
                builder: (_) {
                  return Scaffold(
                    body: Center(child: Text('Page not found :(')),
                  );
                },
              );
          }
        },
      ),
    );
  }
}
