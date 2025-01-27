import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthRepository {
  Future<void> verifyPhoneNumber({
    required String phoneNumber,
    required PhoneVerificationCompleted verificationCompleted,
    required PhoneVerificationFailed verificationFailed,
    required PhoneCodeSent codeSent,
    required PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout,
  });

  Future<void> signInWithCredential(PhoneAuthCredential credential);
}
