import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:rafiki/Providers/JournalProvider.dart';

class PatientProgress extends StatefulWidget {
  const PatientProgress({super.key});

  @override
  State<PatientProgress> createState() => _PatientProgressState();
}

class _PatientProgressState extends State<PatientProgress> {
  final auth = FirebaseAuth.instance;
  @override
  void initState() {
    super.initState();
    Provider.of<JournalProvider>(context, listen: false)
        .fectchjournals(auth.currentUser!.uid);
  }

  @override
  Widget build(BuildContext context) {
    var userprogress =
        Provider.of<JournalProvider>(context, listen: false).patientaverage;
    final height = MediaQuery.of(context).size.height;

    String progresstext(double rating) {
      if (rating > 0 && rating < 30.0) {
        return 'Come Champ You Can Do It. \n it takes time and Dedication';
      } else if (rating <= 50.0 && rating >= 30.0) {
        return 'Great Progreess Keep\n Going A Step A day';
      } else if (rating > 50.0 && rating < 70.0) {
        return 'Almost There keep going.\n Youre Doing Great';
      }
      return 'Congratualtions \n You Made It.';
    }

    List<Color> progresscolors(double rating) {
      if (rating < 30.0) {
        return [
          Colors.red,
          Colors.red,
          Colors.red,
          Colors.red,
        ];
      } else if (rating <= 60.0 && rating >= 30.0) {
        return [
          Colors.red,
          Colors.amber,
          Colors.orangeAccent,
          Colors.red,
        ];
      } else if (rating > 60.0 && rating < 70.0) {
        return [
          Colors.amber,
          Colors.green,
          Colors.orangeAccent,
          Colors.red,
        ];
      }
      return [
        Colors.green,
        Colors.greenAccent,
        Colors.green,
        Colors.greenAccent,
      ];
    }

    return Container(
      width: double.infinity,
      height: height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
            colors: progresscolors(userprogress),
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: const [0, 0.2, 0.5, 0.8]),
      ),
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          const Text(
            'Progress Report ',
            style: TextStyle(
              fontSize: 30,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          CircularPercentIndicator(
            radius: 100.0,
            animation: true,
            animationDuration: 1200,
            lineWidth: 15.0,
            percent: userprogress / 100,
            center: Text(
              userprogress.toStringAsFixed(2),
              style:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
            ),
            circularStrokeCap: CircularStrokeCap.butt,
            backgroundColor: Colors.yellow,
            progressColor: Colors.red,
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(15.0, 125.0, 0.0, 0.0),
            child: DefaultTextStyle(
              style: const TextStyle(
                fontSize: 30.0,
                color: Colors.black,
              ),
              child: Text(progresstext(userprogress)),
            ),
          ),
        ],
      ),
    );
  }
}
