import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../Providers/JournalProvider.dart';
import '../../../Providers/TherapyProvider.dart';
import '../../../models/TherapistModel.dart';

class JournalPage extends StatefulWidget {
  const JournalPage({super.key});

  @override
  State<JournalPage> createState() => _JournalPageState();
}

class _JournalPageState extends State<JournalPage> {
  @override
  void initState() {
    super.initState();
    Provider.of<JournalProvider>(context, listen: false).journalExists();
  }

  @override
  Widget build(BuildContext context) {
    Therapist? bookedTherapist =
        Provider.of<TherapyProvider>(context).bookedTherapist;

    var journalUploaded = Provider.of<JournalProvider>(
      context,
    ).journalUploaded;
    var isLoading = Provider.of<JournalProvider>(
      context,
    ).isLoading;
    return Column(
      children: [
        bookedTherapist != null
            ? Column(
                children: [
                  if (isLoading || journalUploaded)
                    const SizedBox(
                      height: 200,
                    ),
                  if (isLoading)
                    const Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 1,
                      ),
                    ),
                  if (journalUploaded && !isLoading)
                    const Center(
                      child: Text(
                          'Today\'s journal has been uploaded Add More Tommorow'),
                    ),
                  if (!journalUploaded && !isLoading) MoodRow(),
                ],
              )
            : Container(
                margin: const EdgeInsets.only(top: 300),
                child: const Center(
                  child: Text('Please Book A Therapist To Add journal Notes'),
                ),
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
  final patientid = FirebaseAuth.instance.currentUser!.uid;
  late List<Mood> moods;
  late TextEditingController _feelingController;

  @override
  void initState() {
    Provider.of<JournalProvider>(context, listen: false).journalExists();

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
    // Create an object with the selected mood, its rating, and the
    //feeling text
    Mood selectedMood = moods.firstWhere((mood) => mood.isSelected);
    double moodRating = selectedMood.rating;
    String feelingText = _feelingController.text;
    print(selectedMood);
    print(feelingText);
    // Upload the object to the server
    var data = {
      'journal': feelingText,
      'rating': moodRating,
      'mood': selectedMood.name,
    };
    Provider.of<JournalProvider>(context, listen: false)
        .uploadjournal(patientid, data)
        .then((value) async {
      if (mounted) {
        await Provider.of<JournalProvider>(context, listen: false)
            .journalExists();
      }
    });
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
