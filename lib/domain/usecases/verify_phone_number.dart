import 'package:cfq/domain/repositories/auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';

class VerifyPhoneNumber {
  final AuthRepository repository;

  VerifyPhoneNumber(this.repository);

  Future<void> call({
    required String phoneNumber,
    required PhoneVerificationCompleted verificationCompleted,
    required PhoneVerificationFailed verificationFailed,
    required PhoneCodeSent codeSent,
    required PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout,
  }) {
    return repository.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: verificationCompleted,
      verificationFailed: verificationFailed,
      codeSent: codeSent,
      codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
    );
  }
}
