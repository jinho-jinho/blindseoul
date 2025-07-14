import 'package:flutter/material.dart';
import 'screen/blindwalk_map_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BlindSeoul',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: BlindwalkMapScreen(),
    );
  }
}
