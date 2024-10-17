import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class Carousals extends StatefulWidget {
  const Carousals({Key? key}) : super(key: key);

  @override
  State<Carousals> createState() => _CarousalsState();
}

class _CarousalsState extends State<Carousals> {
  int currentPage = 0;
  final List<String> images = [
    'lib/images/goodvibes.jpg',
    'lib/images/Carousal images/cs6.webp',
    'lib/images/Carousal images/cs3.jpg',
    'lib/images/Carousal images/new.jpg',
    'lib/images/Carousal images/cs7.webp',
    'lib/images/Carousal images/cs8.webp',
    'lib/images/Carousal images/CS.jpg',
    'lib/images/Carousal images/cs2.jpg',
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CarouselSlider(
          items: images.map((image) {
            return GestureDetector(
              child: Container(
                height: 250,
                width: 400,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                    image: AssetImage(image),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              onTap: () {
              //  Navigator.push(context,MaterialPageRoute(builder: (context)=>CDrop()));
              },
            );
          }).toList(),
          options: CarouselOptions(
            height: 200,
            autoPlay: true,
            enableInfiniteScroll: true,
            viewportFraction: 1,
            onPageChanged: (index, reason) {
              setState(() {
                currentPage = index;
              });
            },
          ),
        ),
        buildIndicator(),
      ],
    );
  }

  Widget buildIndicator() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: images.map((url) {
          int index = images.indexOf(url);
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: Container(
              width: 8.0,
              height: 8.0,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: currentPage == index ? Colors.black : Colors.grey,
              ),
            ),
          );
        }).toList()
      ),
    );
  }
}
