import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class InfoProductPage extends StatefulWidget {
  final Map<String, dynamic> shoe;
  const InfoProductPage({Key? key, required this.shoe}) : super(key: key);

  @override
  State<InfoProductPage> createState() => _InfoProductPageState();
}

class _InfoProductPageState extends State<InfoProductPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          CarouselSlider(
              items: [
                for (int i = 0; i < widget.shoe['imagenumber']; i++)
                  Image.network(widget.shoe["image"][i])
              ],
              options: CarouselOptions(
                  autoPlay: true,
                  enlargeCenterPage: true,
                  enableInfiniteScroll: true))
        ],
      ),
    );
  }
}
