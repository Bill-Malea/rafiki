import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../../models/JournalModel.dart';
import '../../../models/PatientsModel.dart';

class Patientreport extends StatefulWidget {
  final Patient patient;
  final List<Journal> journals;
  const Patientreport(
      {super.key, required this.patient, required this.journals});

  @override
  State<Patientreport> createState() => _PatientreportState();
}

class _PatientreportState extends State<Patientreport> {
  @override
  Widget build(BuildContext context) {
    pw.Widget journalSection(
        pw.Context ctx, List<Journal> journal, String mood) {
      if (journal.isEmpty) {
        return pw.SizedBox.shrink();
      }

      return pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            mood,
            style: pw.TextStyle(
              fontSize: 16,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.SizedBox(height: 10),
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: journal.map((j) {
              return pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    j.journal,
                  ),
                  pw.Divider(thickness: 1),
                ],
              );
            }).toList(),
          ),
        ],
      );
    }

    Future<pw.Document> generatePdf(
        Patient patient, List<Journal> journals) async {
      // Create a new PDF document
      final pdf = pw.Document();

      // Add a new page to the PDF document
      pdf.addPage(pw.Page(
        build: (pw.Context context) {
          // Build the contents of the PDF page
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'Patient Name: ${patient.name}',
                style: pw.TextStyle(
                  fontSize: 18,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 10),
              pw.Text(
                'Phone Number: ${patient.phone}',
                style: pw.TextStyle(
                  fontSize: 16,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 20),
              pw.Text(
                'Journals',
                style: pw.TextStyle(
                  fontSize: 18,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 10),
              if (journals.isNotEmpty)
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    journalSection(
                        context,
                        journals
                            .where((element) =>
                                element.mood.toLowerCase() == 'sad')
                            .toList(),
                        'Sad'),
                    journalSection(
                        context,
                        journals
                            .where((element) =>
                                element.mood.toLowerCase() == 'angry')
                            .toList(),
                        'Angry'),
                    journalSection(
                        context,
                        journals
                            .where((element) =>
                                element.mood.toLowerCase() == 'neutral')
                            .toList(),
                        'Neutral'),
                    journalSection(
                        context,
                        journals
                            .where((element) =>
                                element.mood.toLowerCase() == 'happy')
                            .toList(),
                        'Happy'),
                  ],
                )
            ],
          );
        },
      ));

      return pdf;
    }

    return Scaffold(
      appBar: AppBar(),
      body: Center(
          child: InkWell(
        onTap: () async {
          final pdf = generatePdf(widget.patient, widget.journals);

          // final bytes = await pdf.save();
          // final dir = await getApplicationDocumentsDirectory();
          // final file = File('${dir.path}/patient_${patient.userid}.pdf');
          // await file.writeAsBytes(bytes);
        },
        child: Container(
            padding: const EdgeInsets.all(10),
            color: Colors.black,
            child: const Text(
              'Patient Report',
              style: TextStyle(color: Colors.white),
            )),
      )),
    );
  }
}
