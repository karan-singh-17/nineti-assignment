import 'package:flutter/material.dart';
import 'package:nineti_test/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Nineti Test(Karan Singh)',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Color.fromRGBO(241, 239, 229, 1)),
        useMaterial3: true,
      ),
      home: home_screen(),
    );
  }
}
