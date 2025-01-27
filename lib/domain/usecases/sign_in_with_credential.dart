import 'package:cfq/domain/repositories/auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignInWithCredential {
  final AuthRepository repository;

  SignInWithCredential(this.repository);

  Future<void> call(PhoneAuthCredential credential) {
    return repository.signInWithCredential(credential);
  }
}
