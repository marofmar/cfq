import 'package:cfq/data/dto/user_dto.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cfq/domain/entities/update_rm_params.dart';
import 'package:cfq/domain/entities/user_entity.dart';

abstract class UserRemoteDataSource {
  Future<UserDto> getCurrentUser();
  Future<UserDto> updateRM(UpdateRMParams params);
}

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;

  UserRemoteDataSourceImpl(this.firestore, this.auth);

  @override
  Future<UserDto> getCurrentUser() async {
    final currentUser = auth.currentUser;
    if (currentUser == null) {
      throw Exception('No user logged in');
    }

    final docSnapshot =
        await firestore.collection('users').doc(currentUser.uid).get();

    if (!docSnapshot.exists) {
      throw Exception('User data not found');
    }

    return UserDto.fromJson({
      'uid': currentUser.uid,
      ...docSnapshot.data()!,
    });
  }

  @override
  Future<UserDto> updateRM(UpdateRMParams params) async {
    final rmField = params.rmType.toLowerCase() + 'records';
    final liftTypeStr = UserEntity.liftTypeToString(params.liftType);

    final docRef = firestore.collection('users').doc(params.userId);

    await docRef.update({
      '$rmField.$liftTypeStr': params.weight,
    });

    // 업데이트된 사용자 정보 반환
    final docSnapshot = await docRef.get();
    if (!docSnapshot.exists) {
      throw Exception('User not found');
    }

    return UserDto.fromJson({
      'uid': params.userId,
      ...docSnapshot.data()!,
    });
  }
}
