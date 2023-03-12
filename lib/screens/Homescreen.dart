import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:fan_carousel_image_slider/fan_carousel_image_slider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rafiki/Providers/BottomNavProvider.dart';

import 'Bottomnav/BottomNav.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  final List<Widget> _pages = <Widget>[
    const Home(),
    const TherapyPage(
      pgname: 'Therapy',
    ),
    const TherapyPage(
      pgname: 'Meditate',
    ),
    const TherapyPage(
      pgname: 'Community',
    ),
    const TherapyPage(
      pgname: 'Journal',
    ),
  ];
  @override
  Widget build(BuildContext context) {
    var selectedIndex = Provider.of<BottomNavProvider>(context).selectetab;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Rafiki'),
        centerTitle: true,
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Center(
          child: _pages.elementAt(selectedIndex),
        ),
      ),
      bottomNavigationBar: const NavigationTabs(),
    );
  }
}

class TherapyPage extends StatefulWidget {
  final String pgname;
  const TherapyPage({super.key, required this.pgname});

  @override
  State<TherapyPage> createState() => _TherapyPageState();
}

class _TherapyPageState extends State<TherapyPage> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(widget.pgname),
    );
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<String> images = [
    "https://www.pixelstalk.net/wp-content/uploads/2016/06/Motivation-HD-Wallpaper.png",
    "https://images4.alphacoders.com/168/168908.jpg",
    "https://wallpapers.com/images/featured/de2xz8n4k1m16zm5.jpg",
    "https://m.media-amazon.com/images/I/61qkDFw6hxL._SY679_.jpg"
  ];
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 10,
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
            padding:
                const EdgeInsets.only(left: 30, right: 30, top: 15, bottom: 15),
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
      ],
    );
    ;
  }
}
