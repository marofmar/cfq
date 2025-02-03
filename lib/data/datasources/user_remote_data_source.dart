import 'package:cfq/data/dto/user_dto.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class UserRemoteDataSource {
  Future<UserDto> getCurrentUser();
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
}
