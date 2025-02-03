import 'package:cfq/domain/entities/user_entity.dart';

class UpdateRMParams {
  final String userId;
  final LiftType liftType;
  final String rmType;
  final int weight;

  UpdateRMParams({
    required this.userId,
    required this.liftType,
    required this.rmType,
    required this.weight,
  });
}
