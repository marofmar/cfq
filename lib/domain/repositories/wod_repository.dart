import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cfq/data/datasources/wod_data.dart';

class WodRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<WodData>> getWodByDate(String date) async {
    final querySnapshot = await _firestore
        .collection('wods')
        .where('date', isEqualTo: date)
        .get();

    return querySnapshot.docs.map((doc) {
      return WodData(
        date: doc['date'],
        wod: List<String>.from(doc['wod']),
      );
    }).toList();
  }
}
