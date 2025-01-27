import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cfq/domain/usecases/verify_phone_number.dart';
import 'package:cfq/domain/usecases/sign_in_with_credential.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:get_it/get_it.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  EnterPhoneNumberPageState createState() => EnterPhoneNumberPageState();
}

class EnterPhoneNumberPageState extends State<LoginPage> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();
  final VerifyPhoneNumber _verifyPhoneNumber =
      GetIt.instance<VerifyPhoneNumber>();
  final SignInWithCredential _signInWithCredential =
      GetIt.instance<SignInWithCredential>();
  String _phoneNumber = '';
  String _verificationId = '';

  void _submitPhoneNumber() async {
    if (_phoneNumber.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('전화번호를 정확히 입력해주세요.')),
      );
      return;
    }

    try {
      await _verifyPhoneNumber.call(
        phoneNumber: _phoneNumber,
        verificationCompleted: (credential) async {
          // Handle successful login
          print("인증 완료");
        },
        verificationFailed: (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Verification failed. Code: ${e.code}')),
          );
        },
        codeSent: (verificationId, resendToken) async {
          setState(() {
            _verificationId = verificationId;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Verification code sent.')),
          );
        },
        codeAutoRetrievalTimeout: (verificationId) {
          // Handle timeout
        },
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  void _verifyCode() async {
    final String smsCode = _codeController.text.trim();

    if (_verificationId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Verification ID is missing.')),
      );
      return;
    }

    if (smsCode.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter the verification code.')),
      );
      return;
    }

    try {
      final PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId,
        smsCode: smsCode,
      );

      await _signInWithCredential.call(credential);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Phone number verified successfully.')),
      );
      // Navigate to the next page or home screen
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Phone Number Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            InternationalPhoneNumberInput(
              onInputChanged: (PhoneNumber number) {
                _phoneNumber = number.phoneNumber ?? '';
                print("입력된 번호: $_phoneNumber");
              },
              selectorConfig: const SelectorConfig(
                selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
              ),
              initialValue: PhoneNumber(isoCode: 'KR'),
              textFieldController: _phoneController,
              formatInput: false,
              keyboardType: const TextInputType.numberWithOptions(
                signed: true,
                decimal: true,
              ),
              inputDecoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Phone Number',
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _submitPhoneNumber,
              child: const Text('Submit Phone Number'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _codeController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Verification Code',
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _verifyCode,
              child: const Text('Verify Code'),
            ),
          ],
        ),
      ),
    );
  }
}
