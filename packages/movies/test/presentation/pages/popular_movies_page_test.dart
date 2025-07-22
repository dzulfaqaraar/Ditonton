import 'package:core/presentation/bloc/bloc_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:movies/movies.dart';

import '../../../../core/test/dummy_data/dummy_objects.dart';
import 'popular_movies_page_test.mocks.dart';

@GenerateMocks([PopularMoviesBloc])
void main() {
  late MockPopularMoviesBloc mockPopularMoviesBloc;

  setUp(() {
    mockPopularMoviesBloc = MockPopularMoviesBloc();
  });

  Widget makeTestableWidget(Widget body) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<PopularMoviesBloc>(
          create: (context) => mockPopularMoviesBloc,
        ),
      ],
      child: MaterialApp(home: body),
    );
  }

  testWidgets('Page should display center progress bar when loading', (
    WidgetTester tester,
  ) async {
    when(mockPopularMoviesBloc.state).thenReturn(BlocLoading());
    when(
      mockPopularMoviesBloc.stream,
    ).thenAnswer((_) => Stream.value(BlocLoading()));

    await tester.pumpWidget(makeTestableWidget(const PopularMoviesPage()));

    final progressBarFinder = find.byType(CircularProgressIndicator);
    final centerFinder = find.byType(Center);

    expect(centerFinder, findsOneWidget);
    expect(progressBarFinder, findsOneWidget);
  });

  testWidgets('Page should display ListView when data is loaded', (
    WidgetTester tester,
  ) async {
    when(mockPopularMoviesBloc.state).thenReturn(BlocHasData(testMovieList));
    when(
      mockPopularMoviesBloc.stream,
    ).thenAnswer((_) => Stream.value(BlocHasData(testMovieList)));

    await tester.pumpWidget(makeTestableWidget(const PopularMoviesPage()));

    final listViewFinder = find.byType(ListView);
    expect(listViewFinder, findsOneWidget);
  });

  testWidgets('Page should display text with message when Error', (
    WidgetTester tester,
  ) async {
    when(
      mockPopularMoviesBloc.state,
    ).thenReturn(const BlocError('Error message'));
    when(
      mockPopularMoviesBloc.stream,
    ).thenAnswer((_) => Stream.value(const BlocError('Error message')));

    await tester.pumpWidget(makeTestableWidget(const PopularMoviesPage()));

    final textFinder = find.byKey(const Key('error_message'));
    expect(textFinder, findsOneWidget);
  });
}
