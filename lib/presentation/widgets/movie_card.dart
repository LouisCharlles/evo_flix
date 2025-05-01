import 'package:evo_flix/data/services/movie_service.dart';
import 'package:flutter/material.dart';
import '../pages/movie_detail_page.dart';
import '../../data/models/filme.dart';

class MovieCard extends StatelessWidget {
  final Filme filme;

  const MovieCard({super.key, required this.filme});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white10,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: InkWell(
        onTap: () async {
          try {
            final filmeCompleto = await MovieService().buscarDetalhesFilme(
              filme.id,
            );
            if (context.mounted) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MovieDetailPage(filme: filmeCompleto),
                ),
              );
            }
          } catch (e) {
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Erro ao carregar detalhes do filme: $e'),
                ),
              );
            }
          }
        },
        child: Container(
          padding: const EdgeInsets.all(8),
          child: LayoutBuilder(
            builder: (context, constraints) {
              double imageWidth =
                  constraints.maxWidth * 0.3; // padrão: 30% da largura
              if (constraints.maxWidth > 600) {
                // Se for tablet/desktop
                imageWidth = 150; // máximo fixo de 150px para não ficar gigante
              }
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      filme.imagemPosterUrl,
                      width: imageWidth,
                      height: imageWidth * 1.5, // poster geralmente é 2:3
                      fit: BoxFit.cover,
                      errorBuilder:
                          (context, error, stackTrace) => const Icon(
                            Icons.movie,
                            size: 50,
                            color: Colors.white,
                          ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 8),
                        Text(
                          "${filme.generosNomes}",
                          style: const TextStyle(
                            color: Color.fromRGBO(254, 190, 0, 1),
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const Padding(padding: EdgeInsets.only(bottom: 8)),
                        Text(
                          "${filme.titulo} (${filme.anoLancamento})",
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const Padding(padding: EdgeInsets.only(bottom: 4)),
                        const SizedBox(height: 8),
                        Text(
                          'Sinopse: ${filme.sinopse}',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                          maxLines: 5,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
