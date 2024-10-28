import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'views/home_screen.dart';
import 'views/prediction_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Breast Cancer Prediction',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 248, 52, 189),
        ),
        useMaterial3: true,
      ),
      initialRoute: '/home',
      getPages: [
        GetPage(name: '/home', page: () => HomeScreen()),
        GetPage(name: '/prediction', page: () => const PredictionScreen()),
      ],
      home: HomeScreen(),
    );
  }
}
