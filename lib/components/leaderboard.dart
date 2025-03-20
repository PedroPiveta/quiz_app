import 'package:flutter/material.dart';
import 'package:quiz_flutter/helpers/firebase_realtimedb_helper.dart';

class Leaderboard extends StatefulWidget {
  const Leaderboard({super.key});

  @override
  State<Leaderboard> createState() => _LeaderboardState();
}

class _LeaderboardState extends State<Leaderboard> {
  final FirebaseRealtimedbHelper firebaseHelper = FirebaseRealtimedbHelper();
  late Future<List<Map<String, dynamic>>> scoresFuture =
      firebaseHelper.getScores();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: FutureBuilder<List<Map<String, dynamic>>>(
        future: scoresFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text("Erro: ${snapshot.error}");
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Text("Nenhum score encontrado.");
          } else {
            final scores = snapshot.data!;
            scores.sort((a, b) => b["score"].compareTo(a["score"]));
            return Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 8.0,
                horizontal: 20,
              ),
              child: Column(
                children:
                    scores
                        .map(
                          (score) => ListTile(
                            title: Text(score["name"]),
                            trailing: Text(score["score"].toString()),
                          ),
                        )
                        .toList(),
              ),
            );
          }
        },
      ),
    );
  }
}
