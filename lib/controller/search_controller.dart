import 'dart:convert';
import 'dart:developer';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';

import 'package:http/http.dart' as http;
import 'package:movie_app/model/all_movies_model_class.dart';

class MovieSearchController extends GetxController {
  List<AllMovies> searchList = [];
  Future<void> searchMovie(String searchQuery) async {
    final apiKey = dotenv.env['API_KEY'];
    log('in search');
    final uri = Uri.https(
      'api.themoviedb.org',
      '/3/search/movie',
      {
        'api_key': apiKey,
        'query': searchQuery,
        'include_adult': 'false',
        'language': 'en-US',
        'page': '1',
      },
    );

    try {
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        log('success');
        final data = jsonDecode(response.body);
        searchList = (data['results'] as List)
            .map((movieJson) => AllMovies.fromJson(movieJson))
            .toList();
        log(searchList.toString());
      } else {
        log('Failed to fetch movies: ${response.statusCode}');
      }
    } catch (error) {
      log('Error fetching movies: $error');
    }
    update();
  }
}
