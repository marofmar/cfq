// TODO Implement this library.
import 'package:cfq/domain/entities/wod_entity.dart';

// class WodRepository {
//   Future<WodEntity?> getWodByDate(DateTime date) async {
//     return await remoteDataSource.getWODByDate(date);
//   }
// }

abstract class WodRepository {
  Future<WodEntity?> getWodByDate(DateTime date);
}
