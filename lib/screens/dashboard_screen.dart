import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:taskuapp/globals/globals.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key, this.user});

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
