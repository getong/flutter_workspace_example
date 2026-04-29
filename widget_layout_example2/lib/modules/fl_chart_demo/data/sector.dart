import 'dart:math';

import 'package:flutter/material.dart';

class Sector {
  const Sector({required this.color, required this.value, required this.title});

  final Color color;
  final double value;
  final String title;
}

List<double> get randomNumbers {
  final Random random = Random();
  return List<double>.generate(7, (_) => random.nextDouble() * 100);
}

List<Sector> get industrySectors {
  final List<double> values = randomNumbers;

  return <Sector>[
    Sector(
      color: Colors.redAccent,
      value: values[0],
      title: 'Information Technology',
    ),
    Sector(color: Colors.blueGrey, value: values[1], title: 'Automobile'),
    Sector(color: Colors.deepPurpleAccent, value: values[2], title: 'Food'),
    Sector(color: Colors.yellow, value: values[3], title: 'Finance'),
    Sector(color: Colors.black, value: values[4], title: 'Energy'),
    Sector(color: Colors.orange, value: values[5], title: 'Agriculture'),
    Sector(color: Colors.teal, value: values[6], title: 'Pharma'),
  ];
}
