import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:audio_wave/audio_wave.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Mood {
  final String name;
  final String image;
  final String musicFile;

  Mood({required this.name, required this.image, required this.musicFile});
}

final moods = [
  Mood(
      name: 'Relaxation',
      image: 'assets/images/relaxation.jpg',
      musicFile: 'assets/audios/relaxing.mp3'),
  Mood(
      name: 'Meditation',
      image: 'assets/images/brain.png',
      musicFile: 'assets/audios/relaxing.mp3'),
  Mood(
      name: 'Focus',
      image: 'assets/images/focus.jpg',
      musicFile: 'assets/audios/relaxing.mp3'),
];

class MeditationList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: moods.length,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        MeditationDetails(mood: moods[index])),
              );
            },
            child: Container(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    moods[index].name,
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 20, right: 20, top: 5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
                          child: Image.asset(
                            moods[index].image,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          left: 10,
                          child: Align(
                            alignment: Alignment.center,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const SizedBox(height: 10.0),
                                Container(
                                  padding: const EdgeInsets.all(2),
                                  decoration: BoxDecoration(
                                    color: Colors.redAccent,
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                  child: Row(
                                    children: const [
                                      Icon(
                                        Icons.play_arrow,
                                        size: 18.0,
                                        color: Colors.black,
                                      ),
                                      Text(
                                        'Play',
                                        style: TextStyle(
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const Positioned(
                          right: 10,
                          top: 2,
                          child: Text(
                            '20 Min',
                            style: TextStyle(
                              fontSize: 12,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class MeditationDetails extends StatefulWidget {
  final Mood mood;

  const MeditationDetails({super.key, required this.mood});

  @override
  // ignore: library_private_types_in_public_api
  _MeditationDetailsState createState() => _MeditationDetailsState();
}

class _MeditationDetailsState extends State<MeditationDetails> {
  final assetsAudioPlayer = AssetsAudioPlayer();
  bool _isplaying = true;
  bool _animate = false;
  final AssetsAudioPlayer audioPlayer = AssetsAudioPlayer.newPlayer();

  playMusic() {
    setState(() {
      _isplaying = !_isplaying;
      _animate = true;
    });
    audioPlayer.open(Audio(widget.mood.musicFile));
  }

  void pauseAudio() {
    setState(() {
      _isplaying = !_isplaying;
      _animate = false;
    });

    audioPlayer.pause();
  }

  void rewindAudio() {
    audioPlayer.seek(const Duration(seconds: 10));
  }

  void forwardAudio() async {
    final currentPosition = await audioPlayer.currentPosition.first;
    final forwardPosition = currentPosition + const Duration(seconds: 10);
    audioPlayer.seek(forwardPosition);
  }

  final NumberFormat _twoDigitFormatter = NumberFormat("00");

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);
    return "${_twoDigitFormatter.format(minutes)}:${_twoDigitFormatter.format(seconds)}";
  }

  String _getCurrentPosition() {
    final position = audioPlayer.currentPosition.valueOrNull;
    if (position == null) {
      return "0:00";
    } else {
      return _formatDuration(position);
    }
  }

  String _getRemainingTime() {
    final current = audioPlayer.current.valueOrNull;
    final position = audioPlayer.currentPosition.valueOrNull;
    if (current == null || position == null) {
      return "0:00";
    } else {
      final remaining = current.audio.duration - position;
      return _formatDuration(remaining);
    }
  }

  stop() {
    audioPlayer.stop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            stop();
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.favorite_border,
              color: Colors.white,
            ),
            onPressed: () {
              // Add favorite functionality here
            },
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 100,
            backgroundImage: AssetImage(widget.mood.image),
          ),
          const SizedBox(height: 20),
          Center(
            child: Text(
              widget.mood.name,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ),
          const SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                margin: const EdgeInsets.only(left: 15, right: 5),
                child: Text(
                  _getCurrentPosition(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
              ),
              _isplaying
                  ? AudioWave(
                      animation: false,
                      height: 70,
                      spacing: 4,
                      bars: inactivebars(),
                    )
                  : AudioWave(
                      animation: true,
                      height: 70,
                      spacing: 4,
                      bars: activebars(),
                    ),
              Container(
                margin: const EdgeInsets.only(right: 20),
                child: Text(
                  _getRemainingTime(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 70,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                  onPressed: rewindAudio,
                  icon: const Icon(
                    Icons.replay_10,
                    color: Colors.white,
                    size: 25,
                  )),
              _isplaying
                  ? FloatingActionButton(
                      onPressed: playMusic,
                      backgroundColor: Colors.white,
                      child: const Icon(
                        Icons.play_arrow,
                        color: Colors.black,
                        size: 25,
                      ),
                    )
                  : FloatingActionButton(
                      onPressed: pauseAudio,
                      backgroundColor: Colors.white,
                      child: const Icon(
                        Icons.pause,
                        color: Colors.black,
                        size: 25,
                      ),
                    ),
              IconButton(
                  onPressed: forwardAudio,
                  icon: const Icon(
                    Icons.forward_10,
                    color: Colors.white,
                    size: 25,
                  )),
            ],
          )
        ],
      ),
    );
  }
}

List<AudioWaveBar> activebars() {
  return [
    AudioWaveBar(heightFactor: 0.1, color: Colors.lightBlueAccent),
    AudioWaveBar(heightFactor: 0.2, color: Colors.blue),
    AudioWaveBar(heightFactor: 0.3, color: Colors.black),
    AudioWaveBar(heightFactor: 0.4),
    AudioWaveBar(heightFactor: 0.5, color: Colors.orange),
    AudioWaveBar(heightFactor: 0.6, color: Colors.lightBlueAccent),
    AudioWaveBar(heightFactor: 0.7, color: Colors.blue),
    AudioWaveBar(heightFactor: 0.8, color: Colors.black),
    AudioWaveBar(heightFactor: 0.9),
    AudioWaveBar(heightFactor: 1, color: Colors.orange),
    AudioWaveBar(heightFactor: 0.1, color: Colors.lightBlueAccent),
    AudioWaveBar(heightFactor: 0.2, color: Colors.blue),
    AudioWaveBar(heightFactor: 0.3, color: Colors.black),
    AudioWaveBar(heightFactor: 0.4),
    AudioWaveBar(heightFactor: 0.5, color: Colors.orange),
    AudioWaveBar(heightFactor: 0.6, color: Colors.lightBlueAccent),
    AudioWaveBar(heightFactor: 0.2, color: Colors.blue),
    AudioWaveBar(heightFactor: 0.3, color: Colors.black),
    AudioWaveBar(heightFactor: 0.4),
    AudioWaveBar(heightFactor: 0.5, color: Colors.orange),
    AudioWaveBar(heightFactor: 0.7, color: Colors.blue),
    AudioWaveBar(heightFactor: 0.8, color: Colors.black),
    AudioWaveBar(heightFactor: 0.9),
    AudioWaveBar(heightFactor: 1, color: Colors.orange),
    AudioWaveBar(heightFactor: 0.1, color: Colors.lightBlueAccent),
    AudioWaveBar(heightFactor: 0.2, color: Colors.blue),
    AudioWaveBar(heightFactor: 0.3, color: Colors.black),
    AudioWaveBar(heightFactor: 0.4),
    AudioWaveBar(heightFactor: 0.5, color: Colors.orange),
    AudioWaveBar(heightFactor: 0.6, color: Colors.lightBlueAccent),
    AudioWaveBar(heightFactor: 0.7, color: Colors.blue),
  ];
}

List<AudioWaveBar> inactivebars() {
  return [
    AudioWaveBar(heightFactor: 0.1, color: Colors.white),
    AudioWaveBar(heightFactor: 0.2, color: Colors.white),
    AudioWaveBar(heightFactor: 0.3, color: Colors.white),
    AudioWaveBar(heightFactor: 0.4, color: Colors.white),
    AudioWaveBar(heightFactor: 0.5, color: Colors.white),
    AudioWaveBar(heightFactor: 0.6, color: Colors.white),
    AudioWaveBar(heightFactor: 0.7, color: Colors.white),
    AudioWaveBar(heightFactor: 0.8, color: Colors.white),
    AudioWaveBar(heightFactor: 0.9, color: Colors.white),
    AudioWaveBar(heightFactor: 1, color: Colors.white),
    AudioWaveBar(heightFactor: 0.1, color: Colors.white),
    AudioWaveBar(heightFactor: 0.2, color: Colors.white),
    AudioWaveBar(heightFactor: 0.3, color: Colors.white),
    AudioWaveBar(heightFactor: 0.4, color: Colors.white),
    AudioWaveBar(heightFactor: 0.5, color: Colors.white),
    AudioWaveBar(heightFactor: 0.6, color: Colors.white),
    AudioWaveBar(heightFactor: 0.2, color: Colors.white),
    AudioWaveBar(heightFactor: 0.3, color: Colors.white),
    AudioWaveBar(heightFactor: 0.4, color: Colors.white),
    AudioWaveBar(heightFactor: 0.5, color: Colors.white),
    AudioWaveBar(heightFactor: 0.7, color: Colors.white),
    AudioWaveBar(heightFactor: 0.8, color: Colors.white),
    AudioWaveBar(heightFactor: 0.9, color: Colors.white),
    AudioWaveBar(heightFactor: 1, color: Colors.white),
    AudioWaveBar(heightFactor: 0.1, color: Colors.white),
    AudioWaveBar(heightFactor: 0.2, color: Colors.white),
    AudioWaveBar(heightFactor: 0.3, color: Colors.white),
    AudioWaveBar(heightFactor: 0.4, color: Colors.white),
    AudioWaveBar(heightFactor: 0.5, color: Colors.white),
    AudioWaveBar(heightFactor: 0.6, color: Colors.white),
    AudioWaveBar(heightFactor: 0.7, color: Colors.white),
  ];
}
