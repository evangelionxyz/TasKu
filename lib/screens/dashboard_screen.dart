import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taskuapp/services/theme_service.dart';
import 'package:taskuapp/globals/globals.dart';
import 'package:taskuapp/widgets/connectivity_card.dart';
import 'package:taskuapp/widgets/location_card.dart';
import 'package:taskuapp/widgets/security_card.dart';
import 'package:taskuapp/widgets/reminder_banner.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key, this.user});

  final User? user;

  @override
  Widget build(BuildContext context) {
    final theme = context.watch<ThemeService>();
    return Scaffold(
      backgroundColor: theme.colors.bg,
      appBar: AppBar(
        backgroundColor: theme.colors.surface,
        foregroundColor: theme.colors.onCard,
        elevation: 0,
        titleSpacing: 0,
        title: const AppTitle(),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: Text(
              'Dashboard',
              style: TextStyle(
                fontFamily: 'Roxborough',
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: theme.colors.accent,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 120),
        children: const [
          ReminderBanner(),
          StaggeredCardEntrance(
            delay: Duration.zero,
            child: ConnectivityCard(),
          ),
          SizedBox(height: 20),
          StaggeredCardEntrance(
            delay: Duration(milliseconds: 80),
            child: SecurityCard(),
          ),
          SizedBox(height: 20),
          StaggeredCardEntrance(
            delay: Duration(milliseconds: 160),
            child: LocationCard(),
          ),
        ],
      ),
    );
  }
}

class StaggeredCardEntrance extends StatefulWidget {
  const StaggeredCardEntrance({
    super.key,
    required this.child,
    required this.delay,
  });

  final Widget child;
  final Duration delay;

  @override
  State<StaggeredCardEntrance> createState() => _StaggeredCardEntranceState();
}

class _StaggeredCardEntranceState extends State<StaggeredCardEntrance>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeAnimation;
  late final Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.15),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));

    Future.delayed(widget.delay, () {
      if (mounted) {
        _controller.forward();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: widget.child,
      ),
    );
  }
}
