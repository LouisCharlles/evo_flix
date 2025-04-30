import 'package:evo_flix/presentation/widgets/head_title.dart';
import 'package:evo_flix/presentation/widgets/movie_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/utils/providers.dart';

class MenuGenerosPage extends ConsumerStatefulWidget {
  const MenuGenerosPage({super.key});

  @override
  ConsumerState<MenuGenerosPage> createState() => _MenuGenerosPageState();
}

class _MenuGenerosPageState extends ConsumerState<MenuGenerosPage> {
  int? _selectedGenreId; 

  @override
  Widget build(BuildContext context) {
    final genresAsync = ref.watch(genresProvider);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: const HeadTitle(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'Explore por Gênero',
              style: TextStyle(
                color: Colors.white,
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: genresAsync.when(
              data: (genres) {
                return ListView.builder(
                  itemCount: genres.length,
                  itemBuilder: (context, index) {
                    final genre = genres[index];
                    final isExpanded = _selectedGenreId == genre.id;
                    final moviesAsync =
                        isExpanded
                            ? ref.watch(moviesByGenreProvider(genre.id))
                            : null;

                    return Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.white),
                      ),
                      child: Theme(
                        data: Theme.of(context).copyWith(
                          dividerColor: Colors.transparent,
                          unselectedWidgetColor: Colors.white,
                          colorScheme: const ColorScheme.dark(),
                        ),
                        child: ExpansionTile(
                          initiallyExpanded: isExpanded,
                          title: Text(
                            genre.nome.toUpperCase(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          trailing: const Icon(
                            Icons.expand_more,
                            color: Colors.white,
                          ),
                          collapsedBackgroundColor: Colors.black,
                          backgroundColor: const Color.fromRGBO(
                            255,
                            30,
                            30,
                            0.6,
                          ), 
                          onExpansionChanged: (expanded) {
                            setState(() {
                              _selectedGenreId = expanded ? genre.id : null;
                            });
                          },
                          children: [
                            if (moviesAsync != null)
                              moviesAsync.when(
                                data: (movies) {
                                  if (movies.isEmpty) {
                                    return const Padding(
                                      padding: EdgeInsets.all(16),
                                      child: Text(
                                        'Nenhum filme encontrado.',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    );
                                  }
                                  return ListView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: movies.length,
                                    itemBuilder: (context, index) {
                                      final movie = movies[index];
                                      return MovieCard(filme: movie);
                                    },
                                  );
                                },
                                loading:
                                    () => const Padding(
                                      padding: EdgeInsets.all(16),
                                      child: Center(
                                        child: CircularProgressIndicator(
                                          color: Colors.red,
                                        ),
                                      ),
                                    ),
                                error:
                                    (error, _) => Padding(
                                      padding: const EdgeInsets.all(16),
                                      child: Text(
                                        'Erro: $error',
                                        style: const TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
              loading:
                  () => const Center(
                    child: CircularProgressIndicator(color: Colors.red),
                  ),
              error:
                  (error, _) => Center(
                    child: Text(
                      'Erro: $error',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
