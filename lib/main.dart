import 'package:flutter/material.dart';
import 'package:quiz_flutter/pages/quiz_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter quiz',
      debugShowCheckedModeBanner: false,
      initialRoute: '/quiz',
      routes: {'/quiz': (context) => const QuizPage()},
    );
  }
}
