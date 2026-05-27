import 'package:flutter/material.dart';
import 'package:taskuapp/globals/globals.dart';
import 'package:firebase_auth/firebase_auth.dart';

class OrganizerPage extends StatelessWidget {
  const OrganizerPage({super.key, this.user});

  final User? user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.lightBrown,
        foregroundColor: AppColors.dark,
        elevation: 0,
        titleSpacing: 0,
        title: const AppTitle(),
      ),
    );
  }
}
