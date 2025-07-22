import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:movies/presentation/pages/movie_page.dart';
import 'package:tv_series/presentation/pages/tv_series_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedPage = 0;
  final List<Widget> _listPage = [const MoviePage(), const TvSeriesPage()];

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      key: scaffoldKey,
      drawer: Drawer(
        child: Column(
          children: [
            const UserAccountsDrawerHeader(
              currentAccountPicture: CircleAvatar(
                backgroundImage: AssetImage('assets/circle-g.png'),
              ),
              accountName: Text('Ditonton'),
              accountEmail: Text('ditonton@dicoding.com'),
            ),
            ListTile(
              leading: const Icon(Icons.movie),
              title: const Text('Movies'),
              onTap: () {
                setState(() {
                  _selectedPage = 0;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              key: const Key('menu_tv_series'),
              leading: const Icon(Icons.live_tv),
              title: const Text('TV Series'),
              onTap: () {
                setState(() {
                  _selectedPage = 1;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              key: const Key('menu_watchlist'),
              leading: const Icon(Icons.save_alt),
              title: const Text('Watchlist'),
              onTap: () {
                scaffoldKey.currentState?.closeDrawer();
                Navigator.pushNamed(context, watchlistRoute);
              },
            ),
            ListTile(
              onTap: () {
                scaffoldKey.currentState?.closeDrawer();
                Navigator.pushNamed(context, aboutRoute);
              },
              leading: const Icon(Icons.info_outline),
              title: const Text('About'),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: const Text('Ditonton'),
        leading: IconButton(
          key: const Key('drawer_icon'),
          icon: const Icon(Icons.menu),
          onPressed: () => scaffoldKey.currentState?.openDrawer(),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(
                context,
                searchRoute,
                arguments: _selectedPage == 0,
              );
            },
            icon: const Icon(Icons.search),
          ),
        ],
      ),
      body: _listPage[_selectedPage],
    );
  }
}
