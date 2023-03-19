import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:provider/provider.dart';

import '../../../Providers/TherapyProvider.dart';
import '../../../models/TherapistModel.dart';

class JournalPage extends StatefulWidget {
  const JournalPage({super.key});

  @override
  State<JournalPage> createState() => _JournalPageState();
}

class _JournalPageState extends State<JournalPage> {
  @override
  Widget build(BuildContext context) {
    Therapist? bookedTherapist =
        Provider.of<TherapyProvider>(context).bookedTherapist;
    return Column(
      children: [
        bookedTherapist != null
            ? Column(
                children: [MoodRow()],
              )
            : const Center(
                child: Text('Please Choose A Therapist To Add journal Notes'),
              ),
      ],
    );
  }
}

class Mood {
  final String name;
  final Color color;
  double rating;
  bool isSelected;

  Mood(
      {required this.name,
      required this.color,
      this.rating = 0.5,
      this.isSelected = false});
}

class MoodRow extends StatefulWidget {
  @override
  _MoodRowState createState() => _MoodRowState();
}

class _MoodRowState extends State<MoodRow> {
  late List<Mood> moods;
  late TextEditingController _feelingController;

  @override
  void initState() {
    super.initState();
    moods = [
      Mood(name: 'Neutral', color: Colors.lightGreen),
      Mood(name: 'Sad', color: Colors.orangeAccent),
      Mood(name: 'Angry', color: Colors.redAccent),
      Mood(name: 'Happy', color: Colors.amber),
    ];
    _feelingController = TextEditingController();
  }

  void _selectMood(int index) {
    setState(() {
      for (var i = 0; i < moods.length; i++) {
        if (i == index) {
          moods[i].isSelected = true;
          _setMoodRating(i);
        } else {
          moods[i].isSelected = false;
        }
      }
    });
  }

  void _setMoodRating(int index) {
    setState(() {
      for (var i = 0; i < moods.length; i++) {
        if (moods[i].name.toLowerCase() == 'neutral') {
          moods[i].rating = 0.5;
        } else if (moods[i].name.toLowerCase() == 'happy') {
          moods[i].rating = 1.0;
        } else if (moods[i].name.toLowerCase() == 'sad') {
          moods[i].rating = 0.3;
        } else if (moods[i].name.toLowerCase() == 'angry') {
          moods[i].rating = 0.15;
        }
      }
    });
  }

  void _uploadMood() {
    // Create an object with the selected mood, its rating, and the feeling text
    Mood selectedMood = moods.firstWhere((mood) => mood.isSelected);
    double moodRating = selectedMood.rating;
    String feelingText = _feelingController.text;

    // Upload the object to the server
    if (kDebugMode) {
      print(
          'Selected mood: ${selectedMood.name}, rating: $moodRating, feeling text: $feelingText');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.all(10),
            child: const Text(
              'Please rate how how you are feeling today',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              for (var i = 0; i < moods.length; i++)
                GestureDetector(
                  onTap: () => _selectMood(i),
                  child: Container(
                    margin: const EdgeInsets.only(
                      top: 10,
                    ),
                    width: 80,
                    height: 40,
                    decoration: BoxDecoration(
                      color: moods[i].isSelected
                          ? moods[i].color
                          : Colors.transparent,
                      border: Border.all(color: moods[i].color),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          moods[i].name,
                          style: TextStyle(
                            color: moods[i].isSelected
                                ? Colors.white
                                : moods[i].color,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(10),
            child: TextField(
              controller: _feelingController,
              decoration: const InputDecoration(
                hintText: 'How are you feeling today?',
                border: OutlineInputBorder(),
              ),
              maxLines: 16,
            ),
          ),
          const SizedBox(height: 20),
          Center(
            child: ElevatedButton(
              onPressed: _uploadMood,
              child: const Text('Upload'),
            ),
          ),
        ],
      ),
    );
  }
}
