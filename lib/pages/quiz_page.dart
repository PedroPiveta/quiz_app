import 'package:flutter/material.dart';
import 'package:quiz_flutter/components/question_box.dart';
import 'package:quiz_flutter/helpers/database_helper.dart';
import 'package:quiz_flutter/helpers/firebase_realtimedb_helper.dart';
import 'package:quiz_flutter/models/question.dart';
import 'package:quiz_flutter/pages/home_page.dart';

class QuizPage extends StatefulWidget {
  const QuizPage({super.key});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  final DatabaseHelper dbHelper = DatabaseHelper.instance;
  final FirebaseRealtimedbHelper firebaseHelper = FirebaseRealtimedbHelper();
  final TextEditingController nameController = TextEditingController();
  List<int> answers = [];
  List<Question> questions = [];
  List<int> correctAnswers = [];

  @override
  void initState() {
    super.initState();
    getQuestions();
  }

  Future<void> getQuestions() async {
    questions = await dbHelper.getQuestions();
    setState(() {
      questions = questions;
      answers = List<int>.filled(questions.length, -1);
      correctAnswers =
          questions
              .map(
                (question) =>
                    question.options.indexOf(question.answer.toString()),
              )
              .toList();
    });
  }

  void updateAnswer(int questionIndex, int selectedOptionIndex) {
    setState(() {
      answers[questionIndex] = selectedOptionIndex;
    });
  }

  Future<void> sendScore() async {
    int score = 0;
    for (var i = 0; i < questions.length; i++) {
      if (answers[i] == correctAnswers[i]) {
        score++;
      }
    }

    await firebaseHelper.addScore(nameController.text, score);
  }

  void _showResultDialog(int score) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Resultado'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Nome'),
              ),
              SizedBox(height: 16),
              Text('Você acertou $score de ${questions.length} questões.'),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () async {
                await sendScore();
                if (mounted) {
                  Navigator.pop(context);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return const HomePage();
                      },
                    ),
                  );
                }
              },
              child: Text('OK', style: TextStyle(color: Colors.black)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz'),
        centerTitle: true,
        backgroundColor: Colors.grey[50],
        surfaceTintColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            for (var i = 0; i < questions.length; i++)
              QuestionBox(
                question: questions[i].question,
                answer: questions[i].answer,
                options: [
                  questions[i].options[0],
                  questions[i].options[1],
                  questions[i].options[2],
                  questions[i].options[3],
                ],
                selectOption: (int index, int answer) {
                  updateAnswer(i, index);
                },
              ),
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 8.0,
                horizontal: 20,
              ),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.all(15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    int score = 0;
                    for (var i = 0; i < questions.length; i++) {
                      if (answers[i] == correctAnswers[i]) {
                        score++;
                      }
                    }
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text('Tem certeza?'),
                          backgroundColor: Colors.white,
                          content: Text(
                            'Não há como voltar atrás após enviar o quiz.',
                            style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          actions: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                    'Cancelar',
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    _showResultDialog(score);
                                  },
                                  child: Text(
                                    "OK",
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: const Text(
                    'Submit Quiz',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
