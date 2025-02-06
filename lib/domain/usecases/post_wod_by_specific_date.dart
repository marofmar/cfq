import 'package:cfq/domain/entities/wod_entity.dart';
import 'package:cfq/domain/repositories/wod_repository.dart';

class PostWodBySpecificDate {
  final WodRepository repository;

  PostWodBySpecificDate(this.repository);

  Future<void> call(WodEntity wod) async {
    return await repository.postWodBySpecificDate(wod);
  }
}
