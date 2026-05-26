import 'package:flutter/material.dart';
import 'package:taskuapp/globals/globals.dart';
import 'package:firebase_auth/firebase_auth.dart';

class OrganizerPage extends StatelessWidget {
  const OrganizerPage({super.key, this.user});

  final User? user;

  @override
  Widget build(BuildContext context) {
    return SectionScaffold(
      title: 'Organizer',
      subtitle: 'Placeholder for organizer tools and upcoming features.',
      icon: Icons.event_note,
    );
  }
}
