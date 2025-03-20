import 'package:firebase_database/firebase_database.dart';

class FirebaseRealtimedbHelper {
  final DatabaseReference _database = FirebaseDatabase.instance.ref("scores");

  Future<void> addScore(String name, int score) async {
    final newScore = _database.push();

    await newScore.set({"name": name, "score": score});
  }

  Future<List<Map<String, dynamic>>> getScores() async {
    final snapshot = await _database.child("").get();
    if (snapshot.exists) {
      final scores = <Map<String, dynamic>>[];
      (snapshot.value as Map).forEach((key, value) {
        scores.add({"name": value["name"], "score": value["score"]});
      });
      return scores;
    } else {
      return [];
    }
  }
}
