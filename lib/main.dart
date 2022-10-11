import 'package:band_names_rt/pages/home_page.dart';
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Musika Taldeak App',
      initialRoute: 'home',
      routes: {
        'home': ( _ ) => HomePage(),
      }
    );
  }
}