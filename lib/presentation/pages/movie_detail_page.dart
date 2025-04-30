import 'package:evo_flix/presentation/widgets/window_button.dart';
import 'package:flutter/material.dart';
import '../../data/models/filme.dart';
import '../widgets/slider.dart';
import '../../data/services/movie_service.dart';

class MovieDetailPage extends StatefulWidget {
  final Filme filme;

  const MovieDetailPage({super.key, required this.filme});

  @override
  State<MovieDetailPage> createState() => _MovieDetailPageState();
}

class _MovieDetailPageState extends State<MovieDetailPage>
    with SingleTickerProviderStateMixin {
  bool showKeywords = false;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    carregarClassificacao();
  }

  Future<void> carregarClassificacao() async {
    final filmeService = MovieService();
    final filmeId = widget.filme.id;
    final classificacao = await filmeService.buscarClassificacaoIndicativa(
      filmeId,
    );

    setState(() {
      widget.filme.classificaoIndicativa = classificacao;
    });
  }

  void toggleKeywords() {
    setState(() {
      showKeywords = !showKeywords;
      if (showKeywords) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filme = widget.filme;

    return Scaffold(
      appBar: AppBar(title: Text(filme.titulo)),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildHeader(filme),
            buildInfoLine(filme),
            const SizedBox(height: 16),
            buildCastAndKeywords(filme),
          ],
        ),
      ),
    );
  }

  Widget buildHeader(Filme filme) {
    final screenWidth = MediaQuery.of(context).size.width;
    final classificacao = filme.classificaoIndicativa ?? 'Desconhecida';

    return Container(
      width: double.infinity,
      color: Colors.black,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.network(
            filme.imagemFundoUrl,
            width: screenWidth * 0.25,
            height: 300,
            fit: BoxFit.cover,
            errorBuilder:
                (context, error, stackTrace) =>
                    const Icon(Icons.movie, size: 100, color: Colors.white),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${filme.titulo} (${filme.anoLancamento ?? ''})',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${filme.duracao} min',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                  const SizedBox(width: 16),
                  for (var membro in filme.equipe)
                    Text(
                      '${membro.cargo}: ${membro.nome}',
                      style: const TextStyle(color: Colors.white70),
                    ),
                  Text(
                    'Classificação: $classificacao',
                    style: const TextStyle(color: Colors.white70),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    filme.sinopse,
                    style: const TextStyle(color: Colors.white70),
                    maxLines: 8,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildInfoLine(Filme filme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: const Color(0xFF1C1C1C),
      child: Wrap(
        runSpacing: 8,
        spacing: 16,
        alignment: WrapAlignment.spaceBetween,
        children: [
          buildInfoItem('Título original', filme.tituloOriginal),
          buildInfoItem('Idioma', filme.idiomaOriginal),
          buildInfoItem('Receita', '\$${filme.receita.toStringAsFixed(0)}'),
          buildInfoItem('Nota', filme.nota.toStringAsFixed(1)),
          buildInfoItem('Duração', '${filme.duracao} min'),
          buildInfoItem('Gêneros', filme.generosNomes.join(', ')),
          buildInfoItem(
            'Data de Lançamento',
            filme.dataLancamento,
          ),
          buildInfoItem('Situação', filme.situacao),
          buildInfoItem('Orçamento', '\$${filme.orcamento.toStringAsFixed(0)}'),
          WindowButton(
            onTap: toggleKeywords,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.grey[800],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AnimatedIcon(
                    icon: AnimatedIcons.menu_close,
                    progress: _animationController,
                    color: Colors.white,
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Palavras-chave',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildInfoItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget buildCastAndKeywords(Filme filme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildCastCarousel(filme),
          const SizedBox(height: 16),
          AnimatedSize(
            duration: const Duration(milliseconds: 300),
            child:
                showKeywords
                    ? buildKeywordsPanel(filme)
                    : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  Widget buildCastCarousel(Filme filme) {
    return SizedBox(height: 240, child: SliderPessoas(elenco: filme.elenco));
  }

  Widget buildKeywordsPanel(Filme filme) {
    final keywords = filme.palavrasChave;
    return Container(
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children:
            keywords.map((kw) {
              return Chip(
                label: Text(kw),
                backgroundColor: Colors.redAccent,
                labelStyle: const TextStyle(color: Colors.white),
              );
            }).toList(),
      ),
    );
  }
}
