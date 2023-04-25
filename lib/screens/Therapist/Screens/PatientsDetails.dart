import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:rafiki/Providers/JournalProvider.dart';
import 'package:rafiki/models/PatientsModel.dart';

class PatientDetails extends StatefulWidget {
  final Patient patient;
  const PatientDetails({super.key, required this.patient});

  @override
  State<PatientDetails> createState() => _PatientDetailsState();
}

class _PatientDetailsState extends State<PatientDetails>
    with SingleTickerProviderStateMixin {
  late TabController tabController = TabController(length: 4, vsync: this);

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  Color dividercolor(int index) {
    if (index == 0) {
      return Colors.red;
    } else if (index == 1) {
      return Colors.amber;
    } else if (index == 2) {
      return Colors.orange;
    }
    return Colors.green;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Progress',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * 0.2),
              child: CircularPercentIndicator(
                radius: 70.0,
                lineWidth: 7.0,
                percent: 0.30,
                center: const Text(
                  "Critical",
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
                progressColor: Colors.amber,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              widget.patient.name,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Tel: ${widget.patient.phone}',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              'Journals',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            FutureBuilder(
              future: Provider.of<JournalProvider>(context)
                  .fectchjournals(widget.patient.userid),
              builder: (ctx, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else {
                  if (snapshot.hasData) {
                    List<Journal>? journals = snapshot.data;

                    var sad = journals!
                        .where((element) => element.mood.toLowerCase() == 'sad')
                        .toList();
                    var angry = journals
                        .where(
                            (element) => element.mood.toLowerCase() == 'angry')
                        .toList();
                    var neutral = journals
                        .where((element) =>
                            element.mood.toLowerCase() == 'neutral')
                        .toList();
                    var happy = journals
                        .where(
                            (element) => element.mood.toLowerCase() == 'happy')
                        .toList();
                    if (journals.isNotEmpty) {
                      return Column(
                        children: [
                          SizedBox(
                            height: 30,
                            child: TabBar(
                              indicatorColor: dividercolor(tabController.index),
                              controller: tabController,
                              tabs: const [
                                Tab(text: 'Sad'),
                                Tab(text: 'Angry'),
                                Tab(text: 'Neutral'),
                                Tab(text: 'Happy'),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              child: TabBarView(
                                controller: tabController,
                                children: [
                                  journal(ctx, sad),
                                  journal(ctx, angry),
                                  journal(ctx, neutral),
                                  journal(ctx, sad),
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    } else {
                      return const Center(child: Text('No journal'));
                    }
                  } else {
                    return const Center(
                        child: Text('Failed to fetch journals'));
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

Widget journal(BuildContext ctx, List<Journal> journal) {
  return ListView.builder(
      itemCount: journal.length,
      itemBuilder: (ctx, index) {
        return Column(
          children: [
            Text(
              '${index + 1} ). ${journal[index].journal}',
            ),
            const Divider(
              thickness: 1,
            )
          ],
        );
      });
}
