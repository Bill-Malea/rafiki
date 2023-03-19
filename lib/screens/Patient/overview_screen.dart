import 'package:fan_carousel_image_slider/fan_carousel_image_slider.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

import 'Homescreen.dart';

class OverviewScreen extends StatefulWidget {
  const OverviewScreen({Key? key}) : super(key: key);

  @override
  State<OverviewScreen> createState() => _OverviewScreenState();
}

class _OverviewScreenState extends State<OverviewScreen> {
  List<String> images = [
    "https://www.pixelstalk.net/wp-content/uploads/2016/06/Motivation-HD-Wallpaper.png",
    "https://images4.alphacoders.com/168/168908.jpg",
    "https://wallpapers.com/images/featured/de2xz8n4k1m16zm5.jpg",
    "https://m.media-amazon.com/images/I/61qkDFw6hxL._SY679_.jpg"
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          const SizedBox(
            height: 20,
          ),
          FanCarouselImageSlider(
            isClickable: false,
            sliderHeight: 300,
            imagesLink: images,
            imageFitMode: BoxFit.cover,
            isAssets: false,
            autoPlay: true,
          ),
          const SizedBox(
            height: 20,
          ),
          Padding(
              padding: const EdgeInsets.only(
                  left: 30, right: 30, top: 15, bottom: 15),
              child: DefaultTextStyle(
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 38,
                  fontWeight: FontWeight.bold,
                ),
                child: AnimatedTextKit(
                  animatedTexts: [
                    WavyAnimatedText("Congrats!"),
                    WavyAnimatedText('Well Done!'),
                  ],
                  isRepeatingAnimation: false,
                ),
              )),
          const SizedBox(
            height: 10,
          ),
          const Padding(
            padding: EdgeInsets.only(left: 50, right: 50, bottom: 15),
            child: Text(
                "You are in the right place. To get started, follow instructions below.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                )),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 130),
            child: Container(
              padding: const EdgeInsets.only(left: 40, right: 40),
              height: 40.0,
              child: Material(
                borderRadius: BorderRadius.circular(5.0),
                color: Colors.black,
                child: InkWell(
                  onTap: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) =>
                                const Homescreen()));
                  },
                  child: Center(
                    child: DefaultTextStyle(
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                      child: AnimatedTextKit(
                        animatedTexts: [
                          TyperAnimatedText('Get Started'),
                        ],
                        isRepeatingAnimation: false,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
