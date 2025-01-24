import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/wod_entity.dart';

abstract class WODRemoteDataSource {
  Future<Wod?> getWODByDate(DateTime date);
}

class WODRemoteDataSourceImpl implements WODRemoteDataSource {
  final FirebaseFirestore firestore;

  WODRemoteDataSourceImpl(this.firestore);

  @override
  Future<WOD?> getWODByDate(DateTime date) async {
    final snapshot =
        await firestore.collection('wods').where('date', isEqualTo: date).get();

    if (snapshot.docs.isNotEmpty) {
      final data = snapshot.docs.first.data();
      return WOD(
        id: snapshot.docs.first.id,
        date: (data['date'] as Timestamp).toDate(),
        description: data['description'] as String,
      );
    }
    return null;
  }
}
