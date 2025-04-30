import 'package:evo_flix/data/models/filme.dart';
import 'package:evo_flix/data/models/genero.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:evo_flix/data/services/movie_service.dart';

final movieServiceProvider = Provider<MovieService>((Ref)=> MovieService());

final genresProvider = FutureProvider<List<Genero>>((ref) async {
  final service = ref.read(movieServiceProvider);
  return service.buscarGeneros();
});

// Provider para Filmes de um Gênero selecionado
final moviesByGenreProvider = FutureProvider.family<List<Filme>, int>((ref, genreId) async {
  final service = ref.read(movieServiceProvider);
  return service.buscarFilmesPorGenero(genreId);
});
