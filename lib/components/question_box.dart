import 'package:flutter/material.dart';

class QuestionBox extends StatefulWidget {
  final String question;
  final List<String> options;
  final int answer;
  final void Function(int, int) selectOption;

  QuestionBox({
    super.key,
    required this.question,
    required this.options,
    required this.answer,
    required this.selectOption,
  });

  @override
  State<QuestionBox> createState() => _QuestionBoxState();
}

class _QuestionBoxState extends State<QuestionBox> {
  int? selectedOption;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withAlpha(128),
            spreadRadius: 3,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            widget.question,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 5),
          Row(
            children: [
              for (var i = 0; i < widget.options.length; i++)
                Container(
                  margin: const EdgeInsets.all(5),
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        selectedOption = i;
                      });
                      widget.selectOption(i, widget.answer);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          selectedOption == i ? Colors.blue[300] : Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                    ),
                    child: Text(
                      widget.options[i],
                      style: TextStyle(
                        color:
                            selectedOption == i ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
