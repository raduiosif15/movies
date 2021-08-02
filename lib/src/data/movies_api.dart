import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:movies/src/models/index.dart';

class MoviesApi {
  const MoviesApi({required String apiUrl, required Client client})
      : _apiUrl = apiUrl,
        _client = client;

  final String _apiUrl;
  final Client _client;

  Future<List<Movie>> getMovies(int page) async {
    final Uri uri = Uri.parse('$_apiUrl/list_movies.json?page=$page');
    final Response response = await _client.get(uri);

    final String body = response.body;
    if (response.statusCode >= 300) {
      throw StateError(body);
    }

    final Map<String, dynamic> _body = jsonDecode(body) as Map<String, dynamic>;
    final Map<String, dynamic> data = _body['data'] as Map<String, dynamic>;
    final List<dynamic> movies = data['movies'] as List<dynamic>;

    return movies //
        .map((dynamic json) => Movie.fromJson(json))
        .toList();
  }
}
