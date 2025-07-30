import 'package:flutter/material.dart';
import 'package:task_manager_project/data/models/user_model.dart';
import 'package:task_manager_project/data/services/auth_service.dart';
import 'package:task_manager_project/ui/widgets/const_app_bar.dart';

class UpdateProfile extends StatefulWidget {
  const UpdateProfile({super.key});

  static const String name = '/updateProfile';

  @override
  State<UpdateProfile> createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateProfile> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCurrentUser();
  }

  void _loadCurrentUser() async {
    final response = await AuthService.getProfile();
    if (!mounted) return;

    if (response['status'] == 'success' && response['data'] != null) {
      final userData = response['data'];
      if (userData is List && userData.isNotEmpty) {
        final user = User.fromJson(userData.first);
        setState(() {
          _emailController.text = user.email;
          _firstNameController.text = user.firstName;
          _lastNameController.text = user.lastName;
          _phoneController.text = user.mobile;
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _updateProfile() async {
    final updatedUser = User(
      email: _emailController.text.trim(),
      firstName: _firstNameController.text.trim(),
      lastName: _lastNameController.text.trim(),
      mobile: _phoneController.text.trim(),
      password: _passwordController.text.isEmpty
          ? null
          : _passwordController.text,
    );

    setState(() {
      isLoading = true;
    });

    final response = await AuthService.updateProfile(updatedUser);

    if (!mounted) return;

    setState(() {
      isLoading = false;
    });

    if (response['status'] == 'success') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully!')),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update profile: ${response['message']}'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: ConstAppBar(),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Center(
              child: SafeArea(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(48.0),
                    child: Column(
                      children: [
                        Text(
                          'Update Profile',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 24),
                        TextFormField(
                          controller: _emailController,
                          decoration: const InputDecoration(hintText: 'Email'),
                          keyboardType: TextInputType.emailAddress,
                        ),
                        const SizedBox(height: 24),
                        TextFormField(
                          controller: _firstNameController,
                          decoration: const InputDecoration(
                            hintText: 'First Name',
                          ),
                        ),
                        const SizedBox(height: 24),
                        TextFormField(
                          controller: _lastNameController,
                          decoration: const InputDecoration(
                            hintText: 'Last Name',
                          ),
                        ),
                        const SizedBox(height: 24),
                        TextFormField(
                          controller: _phoneController,
                          decoration: const InputDecoration(
                            hintText: 'Mobile No.',
                          ),
                          keyboardType: TextInputType.phone,
                        ),
                        const SizedBox(height: 24),
                        TextFormField(
                          controller: _passwordController,
                          decoration: const InputDecoration(
                            hintText: 'Password',
                          ),
                          obscureText: true,
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: _updateProfile,
                          child: const Icon(
                            Icons.arrow_circle_right_outlined,
                            size: 28,
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
}
