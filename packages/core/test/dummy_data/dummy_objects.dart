import 'package:core/data/models/genre_model.dart';
import 'package:core/data/models/movie_detail_model.dart';
import 'package:core/data/models/movie_model.dart';
import 'package:core/data/models/tv_series_episode_response.dart';
import 'package:core/data/models/watchlist_table.dart';
import 'package:core/data/models/tv_series_detail_response.dart';
import 'package:core/data/models/tv_series_model.dart';
import 'package:core/domain/entities/genre.dart';
import 'package:core/domain/entities/movie.dart';
import 'package:core/domain/entities/movie_detail.dart';
import 'package:core/domain/entities/tv_series.dart';
import 'package:core/domain/entities/tv_series_detail.dart';
import 'package:core/domain/entities/tv_series_episode.dart';
import 'package:core/domain/entities/watchlist.dart';

// Movies

const testMovieQuery = 'spiderman';

const tMovieModel = MovieModel(
  adult: false,
  backdropPath: '/muth4OYamXf41G2evdrLEg8d3om.jpg',
  genreIds: [14, 28],
  id: 557,
  originalTitle: 'Spider-Man',
  overview:
      'After being bitten by a genetically altered spider, nerdy high school student Peter Parker is endowed with amazing powers to become the Amazing superhero known as Spider-Man.',
  popularity: 60.441,
  posterPath: '/rweIrveL43TaxUN0akQEaAXL6x0.jpg',
  releaseDate: '2002-05-01',
  title: 'Spider-Man',
  video: false,
  voteAverage: 7.2,
  voteCount: 13507,
);

const tMovie = Movie(
  adult: false,
  backdropPath: '/muth4OYamXf41G2evdrLEg8d3om.jpg',
  genreIds: [14, 28],
  id: 557,
  originalTitle: 'Spider-Man',
  overview:
      'After being bitten by a genetically altered spider, nerdy high school student Peter Parker is endowed with amazing powers to become the Amazing superhero known as Spider-Man.',
  popularity: 60.441,
  posterPath: '/rweIrveL43TaxUN0akQEaAXL6x0.jpg',
  releaseDate: '2002-05-01',
  title: 'Spider-Man',
  video: false,
  voteAverage: 7.2,
  voteCount: 13507,
);

final tMovieModelList = <MovieModel>[tMovieModel];
final tMovieList = <Movie>[tMovie];
const testMovie = Movie(
  adult: false,
  backdropPath: '/muth4OYamXf41G2evdrLEg8d3om.jpg',
  genreIds: [14, 28],
  id: 557,
  originalTitle: 'Spider-Man',
  overview:
      'After being bitten by a genetically altered spider, nerdy high school student Peter Parker is endowed with amazing powers to become the Amazing superhero known as Spider-Man.',
  popularity: 60.441,
  posterPath: '/rweIrveL43TaxUN0akQEaAXL6x0.jpg',
  releaseDate: '2002-05-01',
  title: 'Spider-Man',
  video: false,
  voteAverage: 7.2,
  voteCount: 13507,
);

final testMovieList = [testMovie];

const testMovieId = 1;

const testMovieDetailResponse = MovieDetailResponse(
  adult: false,
  backdropPath: '/path.jpg',
  genres: [GenreModel(id: 1, name: 'Action')],
  id: 1,
  originalTitle: 'Original Title',
  overview: 'Overview',
  posterPath: '/path.jpg',
  releaseDate: '2020-05-05',
  runtime: 120,
  title: 'Title',
  voteAverage: 1.0,
  voteCount: 1,
  budget: 100,
  homepage: "https://google.com",
  imdbId: 'imdb1',
  originalLanguage: 'en',
  popularity: 1.0,
  revenue: 12000,
  status: 'Status',
  tagline: 'Tagline',
  video: false,
);

const testMovieDetail = MovieDetail(
  adult: false,
  backdropPath: '/path.jpg',
  genres: [Genre(id: 1, name: 'Action')],
  id: 1,
  originalTitle: 'Original Title',
  overview: 'Overview',
  posterPath: '/path.jpg',
  releaseDate: '2020-05-05',
  runtime: 120,
  title: 'Title',
  voteAverage: 1.0,
  voteCount: 1,
);

// Watchlist

const testWatchlistTableMovies = WatchlistTable(
  id: 1,
  title: 'Title',
  posterPath: '/path.jpg',
  overview: 'Overview',
  isMovies: 1,
);
const testWatchlistTableTvSeries = WatchlistTable(
  id: 1,
  title: 'Night Court',
  posterPath: '/nazkESnCZVpCjZ3WPs265DFjW0V.jpg',
  overview: 'Night Court is an American television',
  isMovies: 0,
);
final testListOfWatchlistTable = [
  testWatchlistTableMovies,
  testWatchlistTableTvSeries,
];

const testWatchlistMovies = Watchlist(
  id: 1,
  title: 'Title',
  posterPath: '/path.jpg',
  overview: 'Overview',
  isMovies: 1,
);
const testWatchlistTvSeries = Watchlist(
  id: 1,
  title: 'Night Court',
  posterPath: '/nazkESnCZVpCjZ3WPs265DFjW0V.jpg',
  overview: 'Night Court is an American television',
  isMovies: 0,
);
final testListOfWatchlist = [testWatchlistMovies, testWatchlistTvSeries];

final testWatchlistMapMovies = {
  'id': 1,
  'overview': 'Overview',
  'posterPath': '/path.jpg',
  'title': 'Title',
  'isMovies': 1,
};
final testWatchlistMapTvSeries = {
  'id': 1,
  'overview': 'Night Court is an American television',
  'posterPath': '/nazkESnCZVpCjZ3WPs265DFjW0V.jpg',
  'title': 'Night Court',
  'isMovies': 0,
};

// TV Series

const testTvSeriesId = 1;
const testTvSeriesQuery = 'hospital';

const testTvSeriesDetailResponse = TvSeriesDetailResponse(
  id: 1,
  name: 'Night Court',
  overview: 'Night Court is an American television',
  posterPath: '/nazkESnCZVpCjZ3WPs265DFjW0V.jpg',
  genres: [GenreModel(id: 35, name: 'Comedy')],
  voteAverage: 7.4,
  episodeRunTime: [24],
  seasons: [
    SeasonResponse(
      id: 531,
      name: 'Specials',
      airDate: null,
      overview: '',
      posterPath: '/3T19XSr6yqaLNK8uJWFImPgRax0.png',
      episodeCount: 1,
      seasonNumber: 0,
    ),
    SeasonResponse(
      id: 531,
      name: 'Specials',
      airDate: null,
      overview: '',
      posterPath: '/3T19XSr6yqaLNK8uJWFImPgRax0.png',
      episodeCount: 2,
      seasonNumber: 0,
    ),
  ],
);

const testTvSeriesDetail = TvSeriesDetail(
  id: 1,
  name: 'Night Court',
  overview: 'Night Court is an American television',
  posterPath: '/nazkESnCZVpCjZ3WPs265DFjW0V.jpg',
  genres: [Genre(id: 35, name: 'Comedy')],
  voteAverage: 7.4,
  episodeRunTime: [24],
  seasons: [
    Season(
      id: 531,
      name: 'Specials',
      airDate: null,
      overview: '',
      posterPath: '/3T19XSr6yqaLNK8uJWFImPgRax0.png',
      episodeCount: 1,
      seasonNumber: 0,
    ),
    Season(
      id: 531,
      name: 'Specials',
      airDate: null,
      overview: '',
      posterPath: '/3T19XSr6yqaLNK8uJWFImPgRax0.png',
      episodeCount: 2,
      seasonNumber: 0,
    ),
  ],
);

const testTvSeriesModel = TvSeriesModel(
  id: 135647,
  name: '2 Good 2 Be True',
  overview:
      'Car mechanic Eloy makes a terrible first impression on Ali, who works for a real estate magnate. But both of them are hiding their true personas.',
  posterPath: '/2Wf5ySCPcnp8lRhbSD7jt0YLz5A.jpg',
);

final testTvSeriesModelList = <TvSeriesModel>[testTvSeriesModel];

final testTvSeries = testTvSeriesModel.toEntity();

final testTvSeriesList = <TvSeries>[testTvSeries];

const testTvSeriesEpisodeResponse = TvSeriesEpisodeResponse(
  id: 168159,
  name: 'Season 1',
  overview: '',
  posterPath: '/s7ChVSINrNLbw1pNLz0dUWR5x2L.jpg',
  airDate: '2022-06-24',
  episodes: [
    EpisodeResponse(
      id: 2501960,
      name: 'Episode 1',
      overview:
          'Recruited by the Professor for a job of unprecedented proportions, eight thieves storm the Unified Korea Mint. Police pull together a task force.',
      episodeNumber: 1,
      stillPath: '/fABG8ubGumTnYVCkK63zo1wwCq4.jpg',
      guestStars: [
        CrewResponse(
          id: 1005920,
          name: 'Irene Keng',
          character: 'Elle McLean',
          profilePath: '/xElpxbxNFNtBdeccxSqbnAeaul2.jpg',
        ),
      ],
    ),
    EpisodeResponse(
      id: 2501960,
      name: 'Episode 2',
      overview:
          'Recruited by the Professor for a job of unprecedented proportions, eight thieves storm the Unified Korea Mint. Police pull together a task force.',
      episodeNumber: 2,
      stillPath: '/fABG8ubGumTnYVCkK63zo1wwCq4.jpg',
      guestStars: [
        CrewResponse(
          id: 1005920,
          name: 'Irene Keng',
          character: 'Elle McLean',
          profilePath: '/xElpxbxNFNtBdeccxSqbnAeaul2.jpg',
        ),
      ],
    ),
  ],
  seasonNumber: 1,
);

const testTvSeriesEpisode = TvSeriesEpisode(
  id: 168159,
  name: 'Season 1',
  overview: '',
  posterPath: '/s7ChVSINrNLbw1pNLz0dUWR5x2L.jpg',
  airDate: '2022-06-24',
  episodes: [
    Episode(
      id: 2501960,
      name: 'Episode 1',
      overview:
          'Recruited by the Professor for a job of unprecedented proportions, eight thieves storm the Unified Korea Mint. Police pull together a task force.',
      episodeNumber: 1,
      stillPath: '/fABG8ubGumTnYVCkK63zo1wwCq4.jpg',
      guestStars: [
        Crew(
          id: 1005920,
          name: 'Irene Keng',
          character: 'Elle McLean',
          profilePath: '/xElpxbxNFNtBdeccxSqbnAeaul2.jpg',
        ),
      ],
    ),
    Episode(
      id: 2501960,
      name: 'Episode 2',
      overview:
          'Recruited by the Professor for a job of unprecedented proportions, eight thieves storm the Unified Korea Mint. Police pull together a task force.',
      episodeNumber: 2,
      stillPath: '/fABG8ubGumTnYVCkK63zo1wwCq4.jpg',
      guestStars: [
        Crew(
          id: 1005920,
          name: 'Irene Keng',
          character: 'Elle McLean',
          profilePath: '/xElpxbxNFNtBdeccxSqbnAeaul2.jpg',
        ),
      ],
    ),
  ],
  seasonNumber: 1,
);

const testMovieWatchlist = Movie.watchlist(
  id: 1,
  title: 'Title',
  posterPath: '/path.jpg',
  overview: 'Overview',
);
const testTvSeriesWatchlist = TvSeries(
  id: 1,
  name: 'Night Court',
  posterPath: '/nazkESnCZVpCjZ3WPs265DFjW0V.jpg',
  overview: 'Night Court is an American television',
);
