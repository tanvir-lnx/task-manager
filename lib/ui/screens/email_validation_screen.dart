import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:task_manager_project/data/services/auth_service.dart';
import 'package:task_manager_project/ui/screens/pin_verification_screen.dart';
import 'package:task_manager_project/ui/screens/sign_in.dart';

class EmailValidationScreen extends StatefulWidget {
  const EmailValidationScreen({super.key});

  static const String name = '/emailValidationScreen';

  @override
  State<EmailValidationScreen> createState() => _EmailValidationScreenState();
}

class _EmailValidationScreenState extends State<EmailValidationScreen> {
  final TextEditingController _emailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(48.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Text(
                      'Your Email Address',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    Text(
                      'A 6 digit verification code will be sent to your email address',
                    ),
                    const SizedBox(height: 24),
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(hintText: 'Email'),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value?.isEmpty ?? true) return 'Email is required';
                        if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value!)) {
                          return 'Enter valid email format';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: _isLoading ? null : _onTapSendOtpButton,
                      child: _isLoading
                          ? SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : Icon(Icons.arrow_circle_right_outlined, size: 28),
                    ),
                    const SizedBox(height: 28),
                    RichText(
                      text: TextSpan(
                        text: 'Have account? ',
                        style: TextStyle(color: Colors.black),
                        children: [
                          TextSpan(
                            text: ' Sign in',
                            style: TextStyle(color: Colors.green),
                            recognizer: TapGestureRecognizer()
                              ..onTap = onTapBackToSignInButton,
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
      ),
    );
  }

  void onTapBackToSignInButton() {
    Navigator.pushNamedAndRemoveUntil(
      context,
      SignIn.name,
      (Route<dynamic> route) => false,
    );
  }

  void _onTapSendOtpButton() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        final response = await AuthService.verifyEmailForReset(_emailController.text.trim());
        if (!mounted) return;
        if (response['status'] == 'success') {
          Navigator.pushNamed(
            context,
            PinVerificationScreen.name,
            arguments: {
              'flow': 'reset_password',
              'email': _emailController.text.trim(),
            },
          );
        } else {
          _showErrorMessage(response['data'] ?? 'Email verification failed');
        }
      } catch (e) {
        _showErrorMessage('Network error. Please try again.');
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
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

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }
}