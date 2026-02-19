import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/env.dart';
import 'package:flutter_application_1/movies_response.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  MoviesResponse? _movies;
  bool _isLoading = true;
  String? _error;

  final Map<String, String> language = {'language': 'pt-BR'};

  @override
  void initState() {
    super.initState();
    _loadMovies();
  }

  Future<MoviesResponse> _getListagemAPI() async {
    final response = await http.get(
      Uri.https(Env.apiEndpoint, Env.apiParams, language),
      headers: {
        'authorization': 'Bearer ${Env.apiKey}',
        'content-type': 'application/json; charset=utf-8',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data =
          jsonDecode(response.body) as Map<String, dynamic>;

      return MoviesResponse.fromJson(data);
    } else {
      throw Exception('Erro ${response.statusCode}');
    }
  }

  Future<void> _loadMovies() async {
    try {
      final result = await _getListagemAPI();

      setState(() {
        _movies = result;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade900,
      appBar: AppBar(
        title: const Text('App Movies', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
      ),
      body: Center(
        child: _isLoading
            ? const CircularProgressIndicator(color: Colors.white)
            : _error != null
            ? Text(_error!, style: const TextStyle(color: Colors.white))
            : ListView.builder(
                itemCount: _movies?.results?.length ?? 0,
                itemBuilder: (context, index) {
                  final movie = _movies!.results![index];

                  return Padding(
                    padding: EdgeInsets.all(16),
                    child: Card(
                      elevation: 8.0, // Aumenta a sombra
                      shadowColor: Colors.black.withOpacity(0.5),
                      color: Colors.black,
                      margin: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      child: Column(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(8),
                            ),
                            child: Image.network(
                              movie.posterPath != null
                                  ? 'https://image.tmdb.org/t/p/w400${movie.posterPath}'
                                  : 'https://via.placeholder.com/150',
                            ),
                          ),
                          ListTile(
                            title: Text(
                              movie.title ?? '',
                              style: TextStyle(color: Colors.white),
                            ),
                            subtitle: Text(
                              movie.releaseDate ?? 'Sem data',
                              style: TextStyle(color: Colors.grey.shade400),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsetsGeometry.directional(
                              top: 6,
                              start: 20,
                              end: 20,
                              bottom: 30,
                            ),
                            child: Text(
                              movie.overview ?? '',
                              style: TextStyle(color: Colors.grey.shade600),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsetsGeometry.directional(
                              top: 6,
                              // start: 2,
                              end: 20,
                              bottom: 30,
                            ),
                            child: Text(
                              'Popularity: ${movie.popularity} ' 
                              'Rate: ${movie.voteAverage.toString()}',
                              style: TextStyle(color: Colors.grey.shade600),
                              // textAlign: TextAlign.end,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
