import 'package:core/presentation/bloc/bloc_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:movies/movies.dart';

import '../../../../core/test/dummy_data/dummy_objects.dart';
import 'top_rated_movies_page_test.mocks.dart';

@GenerateMocks([TopRatedMoviesBloc])
void main() {
  late MockTopRatedMoviesBloc mockTopRatedMoviesBloc;

  setUp(() {
    mockTopRatedMoviesBloc = MockTopRatedMoviesBloc();
  });

  Widget makeTestableWidget(Widget body) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<TopRatedMoviesBloc>(
          create: (context) => mockTopRatedMoviesBloc,
        ),
      ],
      child: MaterialApp(home: body),
    );
  }

  testWidgets('Page should display progress bar when loading', (
    WidgetTester tester,
  ) async {
    when(mockTopRatedMoviesBloc.state).thenReturn(BlocLoading());
    when(
      mockTopRatedMoviesBloc.stream,
    ).thenAnswer((_) => Stream.value(BlocLoading()));

    await tester.pumpWidget(makeTestableWidget(const TopRatedMoviesPage()));

    final progressFinder = find.byType(CircularProgressIndicator);
    final centerFinder = find.byType(Center);

    expect(centerFinder, findsOneWidget);
    expect(progressFinder, findsOneWidget);
  });

  testWidgets('Page should display when data is loaded', (
    WidgetTester tester,
  ) async {
    when(mockTopRatedMoviesBloc.state).thenReturn(BlocHasData(testMovieList));
    when(
      mockTopRatedMoviesBloc.stream,
    ).thenAnswer((_) => Stream.value(BlocHasData(testMovieList)));

    await tester.pumpWidget(makeTestableWidget(const TopRatedMoviesPage()));

    final listViewFinder = find.byType(ListView);
    expect(listViewFinder, findsOneWidget);
  });

  testWidgets('Page should display text with message when Error', (
    WidgetTester tester,
  ) async {
    when(
      mockTopRatedMoviesBloc.state,
    ).thenReturn(const BlocError('Error message'));
    when(
      mockTopRatedMoviesBloc.stream,
    ).thenAnswer((_) => Stream.value(const BlocError('Error message')));

    await tester.pumpWidget(makeTestableWidget(const TopRatedMoviesPage()));

    final textFinder = find.byKey(const Key('error_message'));
    expect(textFinder, findsOneWidget);
  });
}
