import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart' as flutter_carousel;
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:carousel_slider/carousel_controller.dart' as slider;
import 'package:evo_flix/data/models/pessoa.dart';

class SliderPessoas extends StatefulWidget {
  final List<Pessoa> elenco;

  const SliderPessoas({super.key, required this.elenco});

  @override
  State<SliderPessoas> createState() => _SliderPessoasState();
}

class _SliderPessoasState extends State<SliderPessoas> {
  int activeIndex = 0;
  final controller = slider.CarouselSliderController();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        flutter_carousel.CarouselSlider.builder(
          carouselController: controller,
          itemCount: widget.elenco.length,
          itemBuilder: (context, index, realIndex) {
            final pessoa = widget.elenco[index];
            return buildCastCard(pessoa, screenWidth);
          },
          options: flutter_carousel.CarouselOptions(
            viewportFraction: 0.6,
            height: 200,
            autoPlay: true,
            enableInfiniteScroll: false,
            enlargeCenterPage: true,
            onPageChanged:
                (index, reason) => setState(() => activeIndex = index),
          ),
        ),
        const SizedBox(height: 8),
        buildIndicator(widget.elenco.length),
      ],
    );
  }

  Widget buildIndicator(int count) => AnimatedSmoothIndicator(
    onDotClicked: animateToSlide,
    effect: const ExpandingDotsEffect(
      dotWidth: 8,
      dotHeight: 8,
      activeDotColor: Colors.red,
    ),

    activeIndex: activeIndex,
    count: count,
  );

  void animateToSlide(int index) => controller.animateToPage(index);

  Widget buildCastCard(Pessoa pessoa, double screenWidth) {
    final avatarSize = screenWidth < 600 ? 50.0 : 80.0; // Responsivo

    return Container(
      padding: const EdgeInsets.all(8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(avatarSize / 2),
            child: Image.network(
              pessoa.imagemUrl,
              width: avatarSize,
              height: avatarSize,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => const Icon(
                Icons.person,
                size: 50,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Flexible(
            child: Text(
              pessoa.personagem,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: screenWidth < 600 ? 12 : 16,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              maxLines: 1, // <= Limita para 1 linha
            ),
          ),
          const SizedBox(height: 4),
          Flexible(
            child: Text(
              pessoa.nome,
              style: TextStyle(
                fontWeight: FontWeight.normal,
                fontSize: screenWidth < 600 ? 10 : 14,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
        ],
      ),
    );
  }
}
