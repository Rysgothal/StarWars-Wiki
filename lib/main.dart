import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() {
  runApp( const MyApp()); 
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _selectedIndex = 0;
  List<Map<String, dynamic>> _movies = [];
  final List<Map<String, dynamic>> _favoriteMovies = [];

  @override
  void initState() {
    super.initState();
    _fetchMovies();
  }

  void _fetchMovies() async {
    final response = await http.get(Uri.parse('https://swapi.dev/api/films/'));
    if (response.statusCode == 200) {
      setState(() {
        _movies = List<Map<String, dynamic>>.from(json.decode(response.body)['results']);
      });
    } else {
      throw Exception('Failed to load movies');
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _toggleFavorite(Map<String, dynamic> movie) {
    setState(() {
      if (_favoriteMovies.contains(movie)) {
        _favoriteMovies.remove(movie);
      } else {
        _favoriteMovies.add(movie);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Star Wars Movies'),
          centerTitle: true,
          backgroundColor: Colors.blueGrey[500],
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(25),
              bottomRight: Radius.circular(25),
            ),
          ),
        ),
        body: _selectedIndex == 0 ? _buildMoviesList() : _buildFavoriteMoviesList(),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.movie),
              label: 'Movies',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite),
              label: 'Favorites',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.amber[800],
          onTap: _onItemTapped,
        ),
      ),
    );
  }

  Widget _buildMoviesList() {
    return ListView.builder(
      itemCount: _movies.length,
      itemBuilder: (context, index) {
        final movie = _movies[index];
        final isFavorite = _favoriteMovies.contains(movie);
        return ListTile(
          title: Text(movie['title']),
          subtitle: Text('Release Date: ${movie['release_date']}'),
          trailing: IconButton(
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: isFavorite ? Colors.red : null,
            ),
            onPressed: () => _toggleFavorite(movie),
          ),
        );
      },
    );
  }

  Widget _buildFavoriteMoviesList() {
    return ListView.builder(
      itemCount: _favoriteMovies.length,
      itemBuilder: (context, index) {
        final movie = _favoriteMovies[index];
        return ListTile(
          title: Text(movie['title']),
          subtitle: Text('Release Date: ${movie['release_date']}'),
        );
      },
    );
  }
}
