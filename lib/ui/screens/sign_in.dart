import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:task_manager_project/data/services/auth_service.dart';
import 'package:task_manager_project/ui/screens/email_validation_screen.dart';
import 'package:task_manager_project/ui/screens/main_nav_bar_holder.dart';
import 'package:task_manager_project/ui/screens/sign_up_screen.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  static const String name = '/signIn';

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final TextEditingController _emailController = TextEditingController();
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
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Get Started With',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                    const SizedBox(height: 24),
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(hintText: 'Email'),
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.emailAddress,
                      validator: (String? value) {
                        if (value?.isEmpty ?? true) {
                          return 'Enter valid email';
                        }
                        if (!RegExp(
                          r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                        ).hasMatch(value!)) {
                          return 'Enter valid email format';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _passwordController,
                      decoration: InputDecoration(hintText: 'Password'),
                      obscureText: true,
                      validator: (String? value) {
                        if (value?.isEmpty ?? true) {
                          return 'Enter valid password';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: _isLoading ? null : _onTapSignInButton,
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
                    const SizedBox(height: 58),
                    TextButton(
                      onPressed: _onTapForgotPasswordButton,
                      child: const Text('Forgot password?'),
                    ),
                    RichText(
                      text: TextSpan(
                        text: "Don't have account? ",
                        style: TextStyle(
                          letterSpacing: .4,
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                        ),
                        children: [
                          TextSpan(
                            text: ' Sign up',
                            style: TextStyle(color: Colors.green),
                            recognizer: TapGestureRecognizer()
                              ..onTap = _onTapSignUpButton,
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

  void _onTapSignInButton() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        final response = await AuthService.login(
          _emailController.text.trim(),
          _passwordController.text,
        );

        if (response['status'] == 'success') {
          if (!mounted) return;
          Navigator.pushNamedAndRemoveUntil(
            context,
            MainNavBarHolder.name,
            (predicate) => false,
          );
        } else {
          _showErrorMessage(response['message'] ?? 'Login failed');
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
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  void _onTapForgotPasswordButton() {
    Navigator.pushNamed(context, EmailValidationScreen.name);
  }

  void _onTapSignUpButton() {
    Navigator.pushNamed(context, SignUpScreen.name);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
