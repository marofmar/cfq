import 'package:cfq/data/dto/wod_dto.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cfq/domain/entities/record_entity.dart';

abstract class WodRemoteDataSource {
  Future<List<WodModel>> getWodByDate(DateTime date);
  Future<WodModel> getWodBySpecificDate(String datePath);
  Future<bool> postRecord(RecordEntity record);
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

  @override
  Future<bool> postRecord(RecordEntity record) async {
    try {
      final recordRef = firestore.collection('records').doc(record.wodId);

      // Check if the document exists
      final docSnapshot = await recordRef.get();
      if (!docSnapshot.exists) {
        // Create the document if it doesn't exist
        await recordRef.set({});
      }

      // Update the document with the user's record
      await recordRef.update({
        record.name: {
          'gender': record.gender,
          'level': record.level,
          'record': record.record,
        }
      });

      return true;
    } catch (e) {
      print('Error posting record: $e');
      return false;
    }
  }
}
