import 'package:flutter/material.dart';
import 'package:weather_forecast/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather Forecast',
      theme: ThemeData.dark(),
      home: const HomePage(),
    );
  }
}
