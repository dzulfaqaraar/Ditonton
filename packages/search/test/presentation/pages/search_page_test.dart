import 'package:core/core.dart';
import 'package:core/presentation/bloc/bloc_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:search/presentation/bloc/search_bloc.dart';
import 'package:search/presentation/pages/search_page.dart';

import '../../../../core/test/dummy_data/dummy_objects.dart';
import 'search_page_test.mocks.dart';

@GenerateMocks([SearchBloc])
void main() {
  late MockSearchBloc mockSearchBloc;

  setUp(() {
    mockSearchBloc = MockSearchBloc();
  });

  Widget makeTestableWidget(Widget body) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<SearchBloc>(create: (context) => mockSearchBloc),
      ],
      child: MaterialApp(home: body),
    );
  }

  group('Search Movies', () {
    testWidgets('Page should display title', (WidgetTester tester) async {
      when(mockSearchBloc.state).thenReturn(BlocEmpty());
      when(mockSearchBloc.stream).thenAnswer((_) => Stream.value(BlocEmpty()));

      await tester.pumpWidget(
        makeTestableWidget(const SearchPage(isMovies: true)),
      );

      final appBarFinder = find.byType(AppBar);
      expect(appBarFinder, findsOneWidget);

      final titleFinder = find.text('Search Movies');
      expect(titleFinder, findsOneWidget);
    });

    testWidgets('Page should display form', (WidgetTester tester) async {
      when(mockSearchBloc.state).thenReturn(BlocEmpty());
      when(mockSearchBloc.stream).thenAnswer((_) => Stream.value(BlocEmpty()));

      await tester.pumpWidget(
        makeTestableWidget(const SearchPage(isMovies: true)),
      );

      final textFieldFinder = find.byType(TextField);
      expect(textFieldFinder, findsOneWidget);

      TextField textField = tester.widget(textFieldFinder);
      expect(textField.textInputAction, TextInputAction.search);
      expect(textField.decoration?.hintText, 'Search title');
    });

    testWidgets('Page should display center progress bar when loading', (
      WidgetTester tester,
    ) async {
      when(mockSearchBloc.state).thenReturn(BlocLoading());
      when(
        mockSearchBloc.stream,
      ).thenAnswer((_) => Stream.value(BlocLoading()));

      await tester.pumpWidget(
        makeTestableWidget(const SearchPage(isMovies: true)),
      );

      final textFieldFinder = find.byType(TextField);
      expect(textFieldFinder, findsOneWidget);

      await tester.enterText(textFieldFinder, 'spiderman');
      await tester.pump(const Duration(milliseconds: 500));

      final progressBarFinder = find.byType(CircularProgressIndicator);
      expect(progressBarFinder, findsOneWidget);
    });

    testWidgets('Page should display ListView when data is loaded', (
      WidgetTester tester,
    ) async {
      when(
        mockSearchBloc.state,
      ).thenReturn(BlocHasData<List<Movie>>(testMovieList));
      when(mockSearchBloc.stream).thenAnswer(
        (_) => Stream.value(BlocHasData<List<Movie>>(testMovieList)),
      );

      await tester.pumpWidget(
        makeTestableWidget(const SearchPage(isMovies: true)),
      );

      final textFieldFinder = find.byType(TextField);
      expect(textFieldFinder, findsOneWidget);

      await tester.enterText(textFieldFinder, 'spiderman');
      await tester.pump(const Duration(milliseconds: 500));

      final progressBarFinder = find.byType(CircularProgressIndicator);
      expect(progressBarFinder, findsOneWidget);

      final listViewFinder = find.byType(ListView);
      expect(listViewFinder, findsOneWidget);
    });

    testWidgets('Page should display Text when data is empty', (
      WidgetTester tester,
    ) async {
      when(mockSearchBloc.state).thenReturn(const BlocHasData<List<Movie>>([]));
      when(
        mockSearchBloc.stream,
      ).thenAnswer((_) => Stream.value(const BlocHasData<List<Movie>>([])));

      await tester.pumpWidget(
        makeTestableWidget(const SearchPage(isMovies: true)),
      );

      final textFieldFinder = find.byType(TextField);
      expect(textFieldFinder, findsOneWidget);

      await tester.enterText(textFieldFinder, 'spiderman');
      await tester.pump(const Duration(milliseconds: 500));

      final emptyTextFinder = find.text('No data');
      expect(emptyTextFinder, findsOneWidget);
    });

    testWidgets('Page should display text with message when Error', (
      WidgetTester tester,
    ) async {
      when(mockSearchBloc.state).thenReturn(const BlocError('Error message'));
      when(
        mockSearchBloc.stream,
      ).thenAnswer((_) => Stream.value(const BlocError('Error message')));

      await tester.pumpWidget(
        makeTestableWidget(const SearchPage(isMovies: true)),
      );

      final textFieldFinder = find.byType(TextField);
      expect(textFieldFinder, findsOneWidget);

      await tester.enterText(textFieldFinder, 'spiderman');
      await tester.pump(const Duration(milliseconds: 500));

      final textFinder = find.byKey(const Key('error_message'));
      expect(textFinder, findsOneWidget);
    });
  });

  group('Search TV Series', () {
    testWidgets('Page should display title', (WidgetTester tester) async {
      when(mockSearchBloc.state).thenReturn(BlocEmpty());
      when(mockSearchBloc.stream).thenAnswer((_) => Stream.value(BlocEmpty()));

      await tester.pumpWidget(
        makeTestableWidget(const SearchPage(isMovies: false)),
      );

      final appBarFinder = find.byType(AppBar);
      expect(appBarFinder, findsOneWidget);

      final titleFinder = find.text('Search TV Series');
      expect(titleFinder, findsOneWidget);
    });

    testWidgets('Page should display form', (WidgetTester tester) async {
      when(mockSearchBloc.state).thenReturn(BlocEmpty());
      when(mockSearchBloc.stream).thenAnswer((_) => Stream.value(BlocEmpty()));

      await tester.pumpWidget(
        makeTestableWidget(const SearchPage(isMovies: false)),
      );

      final textFieldFinder = find.byType(TextField);
      expect(textFieldFinder, findsOneWidget);

      TextField textField = tester.widget(textFieldFinder);
      expect(textField.textInputAction, TextInputAction.search);
      expect(textField.decoration?.hintText, 'Search title');
    });

    testWidgets('Page should display center progress bar when loading', (
      WidgetTester tester,
    ) async {
      when(mockSearchBloc.state).thenReturn(BlocLoading());
      when(
        mockSearchBloc.stream,
      ).thenAnswer((_) => Stream.value(BlocLoading()));

      await tester.pumpWidget(
        makeTestableWidget(const SearchPage(isMovies: false)),
      );

      final textFieldFinder = find.byType(TextField);
      expect(textFieldFinder, findsOneWidget);

      await tester.enterText(textFieldFinder, 'hospital');
      await tester.pump(const Duration(milliseconds: 500));

      final progressBarFinder = find.byType(CircularProgressIndicator);
      expect(progressBarFinder, findsOneWidget);
    });

    testWidgets('Page should display ListView when data is loaded', (
      WidgetTester tester,
    ) async {
      when(
        mockSearchBloc.state,
      ).thenReturn(BlocHasData<List<TvSeries>>(testTvSeriesList));
      when(mockSearchBloc.stream).thenAnswer(
        (_) => Stream.value(BlocHasData<List<TvSeries>>(testTvSeriesList)),
      );

      await tester.pumpWidget(
        makeTestableWidget(const SearchPage(isMovies: false)),
      );

      final textFieldFinder = find.byType(TextField);
      expect(textFieldFinder, findsOneWidget);

      await tester.enterText(textFieldFinder, 'hospital');
      await tester.pump(const Duration(milliseconds: 500));

      final progressBarFinder = find.byType(CircularProgressIndicator);
      expect(progressBarFinder, findsOneWidget);

      final listViewFinder = find.byType(ListView);
      expect(listViewFinder, findsOneWidget);
    });

    testWidgets('Page should display Text when data is empty', (
      WidgetTester tester,
    ) async {
      when(
        mockSearchBloc.state,
      ).thenReturn(const BlocHasData<List<TvSeries>>([]));
      when(
        mockSearchBloc.stream,
      ).thenAnswer((_) => Stream.value(const BlocHasData<List<TvSeries>>([])));

      await tester.pumpWidget(
        makeTestableWidget(const SearchPage(isMovies: false)),
      );

      final textFieldFinder = find.byType(TextField);
      expect(textFieldFinder, findsOneWidget);

      await tester.enterText(textFieldFinder, 'hospital');
      await tester.pump(const Duration(milliseconds: 500));

      final emptyTextFinder = find.text('No data');
      expect(emptyTextFinder, findsOneWidget);
    });

    testWidgets('Page should display text with message when Error', (
      WidgetTester tester,
    ) async {
      when(mockSearchBloc.state).thenReturn(const BlocError('Error message'));
      when(
        mockSearchBloc.stream,
      ).thenAnswer((_) => Stream.value(const BlocError('Error message')));

      await tester.pumpWidget(
        makeTestableWidget(const SearchPage(isMovies: false)),
      );

      final textFieldFinder = find.byType(TextField);
      expect(textFieldFinder, findsOneWidget);

      await tester.enterText(textFieldFinder, 'hospital');
      await tester.pump(const Duration(milliseconds: 500));

      final textFinder = find.byKey(const Key('error_message'));
      expect(textFinder, findsOneWidget);
    });
  });
}
