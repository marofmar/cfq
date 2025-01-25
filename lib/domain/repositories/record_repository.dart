import 'package:cfq/domain/entities/record_entity.dart';

abstract class RecordRepository {
  Future<bool> postRecord(RecordEntity record);
}
