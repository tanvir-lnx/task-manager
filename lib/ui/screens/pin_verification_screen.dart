import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:task_manager_project/data/services/auth_service.dart';
import 'package:task_manager_project/ui/screens/main_nav_bar_holder.dart';
import 'package:task_manager_project/ui/screens/set_password_screen.dart';
import 'package:task_manager_project/ui/screens/sign_in.dart';

class PinVerificationScreen extends StatefulWidget {
  const PinVerificationScreen({super.key});
  static const String name = '/pinVerificationScreen';

  @override
  State<PinVerificationScreen> createState() => _PinVerificationScreenState();
}

class _PinVerificationScreenState extends State<PinVerificationScreen> {
  String flow = 'signup';
  String email = '';
  String otp = '';
  bool _isLoading = false;
  
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    flow = args?['flow'] ?? 'signup';
    email = args?['email'] ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(48.0),
              child: Column(
                children: [
                  Text(
                    'Pin Verification',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  Text(
                    'A 6 digit verification code has been sent to your email address',
                  ),
                  const SizedBox(height: 24),
                  PinCodeTextField(
                    backgroundColor: Colors.transparent,
                    appContext: context,
                    length: 6,
                    keyboardType: TextInputType.number,
                    pinTheme: PinTheme(shape: PinCodeFieldShape.box),
                    onChanged: (value) {
                      otp = value;
                    },
                    onCompleted: (value) {
                      otp = value;
                    },
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: _isLoading ? null : _onTapVerifyButton,
                    child: _isLoading
                        ? SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text('Verify'),
                  ),
                  const SizedBox(height: 30),
                  RichText(
                    text: TextSpan(
                      text: 'Have account? ',
                      style: TextStyle(color: Colors.black),
                      children: [
                        TextSpan(
                          text: ' Sign in',
                          style: TextStyle(color: Colors.green),
                          recognizer: TapGestureRecognizer()
                            ..onTap = _backToSignInButton,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _onTapVerifyButton() async {
    if (otp.length != 6) {
      _showErrorMessage('Please enter 6 digit OTP');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      if (flow == 'reset_password') {
        final response = await AuthService.verifyOtp(email, otp);
        if (!mounted) return;
        if (response['status'] == 'success') {
          Navigator.pushNamed(
            context,
            SetPasswordScreen.name,
            arguments: {
              'email': email,
              'otp': otp,
            },
          );
        } else {
          _showErrorMessage(response['data'] ?? 'Invalid OTP');
        }
      } else {
        Navigator.pushNamedAndRemoveUntil(
          context,
          MainNavBarHolder.name,
          (predicate) => false,
        );
      }
    } catch (e) {
      _showErrorMessage('Network error. Please try again.');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _backToSignInButton() {
    Navigator.pushNamedAndRemoveUntil(
      context,
      SignIn.name,
      (predicate) => false,
    );
  }
}