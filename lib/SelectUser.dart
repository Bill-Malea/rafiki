import 'package:flutter/material.dart';

class SelectUser extends StatelessWidget {
  const SelectUser({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            const Text('Select User'),
            Row(
              children: const [
                Text('Therapist'),
                Text('Patient'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
