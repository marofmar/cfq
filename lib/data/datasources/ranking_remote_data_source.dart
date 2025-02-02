import 'package:cloud_firestore/cloud_firestore.dart';

class RankingRemoteDataSource {
  final FirebaseFirestore firestore;

  RankingRemoteDataSource(this.firestore);

  Future<List<Map<String, dynamic>>> getRankingByDate(String date) async {
    final snapshot = await firestore.collection('ranking').doc(date).get();
    if (snapshot.exists) {
      final data = snapshot.data() as Map<String, dynamic>;
      return data.entries.map((entry) {
        final userData = entry.value as Map<String, dynamic>;
        return {
          'name': entry.key,
          'rank': userData['rank'],
          'record': userData['record'],
          'level': userData['level'],
          'gender': userData['gender'],
        };
      }).toList();
    }
    return [];
  }
}
