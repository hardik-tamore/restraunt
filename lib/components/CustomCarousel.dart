import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:chandrhas/theme/variables.dart';

class CustomCarousel extends StatefulWidget {
  final List<String> imgList;

  CustomCarousel({Key key, this.imgList}) : super(key: key);

  @override
  _CustomCarouselState createState() => _CustomCarouselState();
}

class _CustomCarouselState extends State<CustomCarousel> {
  int _current = 0;
  List<Widget> imageSliders;

  void callImages() {
    setState(() {
      // callNetwork();

      loadImages();
    });
  }

  void loadImages() {
    imageSliders = widget.imgList
        .map((item) => Container(
              child: Container(
                decoration: BoxDecoration(
                  // border: Border.all(width: 5.0, color: Colors.black),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.white,
                      spreadRadius: 5.0,
                      blurRadius: 20.0,
                    ),
                  ],
                ),
                // margin: EdgeInsets.all(5.0),
                child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    child: Stack(
                      children: <Widget>[
                        Image.network(
                          item,
                          fit: BoxFit.cover,
                          width: double.maxFinite,
                        ),
                      ],
                    )),
              ),
            ))
        .toList();
  }

  @override
  void initState() {
    super.initState();
    callImages();
    // To Do
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        CarouselSlider(
          items: imageSliders,
          options: CarouselOptions(
              autoPlay: true,
              enlargeCenterPage: true,
              height: 230.0,
              
              // aspectRatio: 2.4,
              viewportFraction: 1.0,
              onPageChanged: (index, reason) {
                setState(() {
                  _current = index;
                });
              }),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: widget.imgList.map((url) {
            int index = widget.imgList.indexOf(url);
            return Container(
              width: 8.0,
              height: 8.0,
              margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),

              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _current == index
                    ? Color.fromRGBO(0, 0, 0, 0.9)
                    : Color.fromRGBO(0, 0, 0, 0.4),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
