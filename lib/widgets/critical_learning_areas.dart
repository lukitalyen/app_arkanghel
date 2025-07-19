import 'package:flutter/material.dart';

class CriticalLearningAreas extends StatelessWidget {
  const CriticalLearningAreas({super.key});

  @override
  Widget build(BuildContext context) {
    // Sample data
    final areas = [
      'Financial Literacy',
      'Digital Transformation',
      'Agile Methodologies',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: areas.map((area) => 
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Chip(
            label: Text(area),
            backgroundColor: Colors.red[100],
            labelStyle: TextStyle(color: Colors.red[800]),
          ),
        )
      ).toList(),
    );
  }
}
