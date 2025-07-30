import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:task_manager_project/data/models/user_model.dart';
import 'package:task_manager_project/data/services/auth_service.dart';
import 'package:task_manager_project/ui/screens/pin_verification_screen.dart';
import 'package:task_manager_project/ui/screens/sign_in.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  static const String name = '/signUpScreen';

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
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
                      'Join With Us',
                      style: Theme.of(context).textTheme.titleLarge,
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
                    TextFormField(
                      controller: _firstNameController,
                      decoration: InputDecoration(hintText: 'First Name'),
                      validator: (value) {
                        if (value?.isEmpty ?? true) return 'First name is required';
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),
                    TextFormField(
                      controller: _lastNameController,
                      decoration: InputDecoration(hintText: 'Last Name'),
                      validator: (value) {
                        if (value?.isEmpty ?? true) return 'Last name is required';
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),
                    TextFormField(
                      controller: _phoneController,
                      decoration: InputDecoration(hintText: 'Mobile No.'),
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value?.isEmpty ?? true) return 'Mobile number is required';
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),
                    TextFormField(
                      controller: _passwordController,
                      decoration: InputDecoration(hintText: 'Password'),
                      obscureText: true,
                      validator: (value) {
                        if (value?.isEmpty ?? true) return 'Password is required';
                        if (value!.length < 6) return 'Password must be at least 6 characters';
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: _isLoading ? null : _onPressedSignUpButton,
                      child: _isLoading
                          ? SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Icon(
                              Icons.arrow_circle_right_outlined,
                              size: 28,
                            ),
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
      ),
    );
  }

  void _backToSignInButton() {
    Navigator.popAndPushNamed(context, SignIn.name);
  }

  void _onPressedSignUpButton() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        final user = User(
          email: _emailController.text.trim(),
          firstName: _firstNameController.text.trim(),
          lastName: _lastNameController.text.trim(),
          mobile: _phoneController.text.trim(),
          password: _passwordController.text,
        );

        final response = await AuthService.register(user);
if (!mounted) return;
        if (response['status'] == 'success') {
          Navigator.pushNamed(
            context,
            PinVerificationScreen.name,
            arguments: {'flow': 'signup', 'email': _emailController.text.trim()},
          );
        } else {
          _showErrorMessage(response['message'] ?? 'Registration failed');
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
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}