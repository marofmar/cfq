import 'package:cfq/data/models/wod_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class WodRemoteDataSource {
  Future<List<WodModel>> getWodByDate(DateTime date);
  Future<WodModel> getWodBySpecificDate(String datePath);
}

class WodRemoteDataSourceImpl implements WodRemoteDataSource {
  final FirebaseFirestore firestore;

  WodRemoteDataSourceImpl(this.firestore);

  @override
  Future<List<WodModel>> getWodByDate(DateTime date) async {
    final snapshot =
        await firestore.collection('wods').where('date', isEqualTo: date).get();

    return snapshot.docs.map((doc) {
      final data = doc.data();
      return WodModel(
        id: doc.id,
        exercises: List<String>.from(data['exercises']),
        level: Map<String, dynamic>.from(data['level']),
        description: data['description'] as String,
      );
    }).toList();
  }

  @override
  Future<WodModel> getWodBySpecificDate(String datePath) async {
    final docRef = firestore.doc('wods/$datePath');
    final docSnapshot = await docRef.get();

    if (docSnapshot.exists) {
      final data = docSnapshot.data()!;
      return WodModel(
        id: docSnapshot.id,
        exercises: List<String>.from(data['exercises']),
        level: Map<String, dynamic>.from(data['level']),
        description: data['description'] as String,
      );
    } else {
      throw Exception('Document does not exist');
    }
  }
}
