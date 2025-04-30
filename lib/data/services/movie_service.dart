import "dart:convert";
import "package:evo_flix/data/models/genero.dart";
import "package:flutter_dotenv/flutter_dotenv.dart";
import "package:http/http.dart";
import "../models/filme.dart";

class MovieService {
  final String apiKey = dotenv.env["TMDB_API_KEY"] ?? '';
  final String baseUrl = dotenv.env['BASE_URL'] ?? '';

  Future<List<Filme>> buscarFilmes(String query) async {
    final url = Uri.parse('$baseUrl/search/movie?api_key=$apiKey&query=$query');
    final response = await get(url);
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final List results = json['results'];

      List<Filme> movies = [];

      for (var movieJson in results) {
        final movieId = movieJson['id'];
        final detailUrl = Uri.parse(
          "$baseUrl/movie/$movieId?api_key=$apiKey&append_to_response=keywords,credits",
        );
        final detailResponse = await get(detailUrl);

        if (detailResponse.statusCode == 200) {
          final detailJson = jsonDecode(detailResponse.body);
          movies.add(Filme.fromJson(detailJson));
        } else {
          throw Exception(
            "Erro ao tentar buscar detalhes do filme: ${detailResponse.statusCode}",
          );
        }
      }

      movies.sort((a, b) {
        int yearCompare = (a.anoLancamento ?? 0).compareTo(
          b.anoLancamento ?? 0,
        );
        if (yearCompare != 0) {
          return yearCompare;
        }
        return a.titulo.compareTo(b.titulo);
      });
      return movies;
    } else {
      throw Exception("Erro ao tentar buscar filmes: ${response.statusCode}");
    }
  }

  Future<Filme> buscarDetalhesFilme(int id) async {
    final url = Uri.parse('$baseUrl/movie/$id?api_key=$apiKey');
    final response = await get(url);
    Filme filme;
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      filme = Filme.fromJson(json);
    } else {
      throw Exception(
        'Erro ao buscar detalhes do filme: ${response.statusCode}',
      );
    }
    final detailUrl = Uri.parse(
      "$baseUrl/movie/$id?api_key=$apiKey&append_to_response=keywords,credits",
    );
    final detailResponse = await get(detailUrl);

    if (detailResponse.statusCode == 200) {
      final detailJson = jsonDecode(detailResponse.body);
      filme = Filme.fromJson(detailJson);
    } else {
      throw Exception(
        "Erro ao tentar buscar detalhes do filme: ${detailResponse.statusCode}",
      );
    }
    return filme;
  }

  Future<String?> buscarClassificacaoIndicativa(int filmeId) async {
    final url = '$baseUrl/movie/$filmeId/release_dates?api_key=$apiKey';
    final response = await get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final results = data['results'] as List;

      for (var country in results) {
        if (country['iso_3166_1'] == 'BR') {
          final releaseDates = country['release_dates'] as List;
          if (releaseDates.isNotEmpty) {
            return releaseDates.first['certification'] ?? 'Desconhecida';
          }
        }
      }
      return null;
    } else {
      throw Exception('Erro ao buscar classificação indicativa');
    }
  }

  Future<List<Genero>> buscarGeneros() async {
    final url = Uri.parse(
      '$baseUrl/genre/movie/list?api_key=$apiKey&language=pt-BR',
    );
    final response = await get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final genres =
          (data['genres'] as List)
              .map((genreJson) => Genero.fromJson(genreJson))
              .toList();
      return genres;
    } else {
      throw Exception('Erro ao buscar gêneros');
    }
  }

  Future<List<Filme>> buscarFilmesPorGenero(int genreId) async {
    final url = Uri.parse(
      '$baseUrl/discover/movie?api_key=$apiKey&with_genres=$genreId&language=pt-BR',
    );
    final response = await get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final movies =
          (data['results'] as List)
              .map((movieJson) => Filme.fromJson(movieJson))
              .toList();
      return movies;
    } else {
      throw Exception('Erro ao buscar filmes por gênero');
    }
  }
}
