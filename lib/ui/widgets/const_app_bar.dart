import 'package:flutter/material.dart';
import 'package:task_manager_project/data/models/user_model.dart';
import 'package:task_manager_project/data/services/auth_service.dart';
import 'package:task_manager_project/ui/screens/sign_in.dart';
import 'package:task_manager_project/ui/screens/update_profile.dart';

class ConstAppBar extends StatefulWidget {
  const ConstAppBar({super.key});

  @override
  State<ConstAppBar> createState() => _ConstAppBarState();
}

class _ConstAppBarState extends State<ConstAppBar> {
  User? currentUser;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  void _loadUserProfile() async {
    try {
      final response = await AuthService.getProfile();

      if (!mounted) return;

      if (response['status'] == 'success' && response['data'] != null) {
        final userData = response['data'];
        if (userData is List && userData.isNotEmpty) {
          if (!mounted) return;
          setState(() {
            currentUser = User.fromJson(userData.first);
            isLoading = false;
          });
        } else {
          if (!mounted) return;
          setState(() {
            isLoading = false;
          });
        }
      } else {
        if (!mounted) return;
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        isLoading = false;
      });
    }
  }

  void _onTapSignOutButton() async {
    await AuthService.logout();
    if (!mounted) return;
    Navigator.pushNamedAndRemoveUntil(context, SignIn.name, (route) => false);
  }

  // <-- Updated method to reload profile on return
  void _onTapProfile() async {
    await Navigator.pushNamed(context, UpdateProfile.name);
    _loadUserProfile();
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.green,
      title: Row(
        children: [
          GestureDetector(
            onTap: _onTapProfile,
            child: CircleAvatar(
              radius: 25,
              backgroundColor: Colors.white,
              child: Text(
                isLoading
                    ? 'U'
                    : (currentUser?.firstName.isNotEmpty == true
                          ? currentUser!.firstName[0].toUpperCase()
                          : 'U'),
                style: const TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isLoading
                      ? 'Loading...'
                      : '${currentUser?.firstName ?? ''} ${currentUser?.lastName ?? ''}',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  isLoading ? 'Loading...' : currentUser?.email ?? '',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          onPressed: _onTapSignOutButton,
          icon: const Icon(Icons.logout_outlined, size: 25),
        ),
      ],
    );
  }
}
