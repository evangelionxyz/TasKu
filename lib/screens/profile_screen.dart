import 'package:flutter/material.dart';
import 'package:taskuapp/globals/globals.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key, required this.user, required this.onSignOut});

  final User user;
  final VoidCallback onSignOut;

  @override
  Widget build(BuildContext context) {
    final String displayName =
        user.displayName ?? user.email ?? 'Signed in user';
    final String? photoUrl = user.photoURL;
    final bool hasPhoto = photoUrl != null && photoUrl.isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.lightBrown,
        foregroundColor: AppColors.dark,
        elevation: 0,
        titleSpacing: 0,
        title: const AppTitle(),
        actions: [
          IconButton(
            onPressed: onSignOut,
            icon: const Icon(Icons.logout_outlined),
            tooltip: 'Sign out',
          ),
          const SizedBox(width: 8),
        ],
      ),
    );
  }
}
