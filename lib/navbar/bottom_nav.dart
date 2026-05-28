import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taskuapp/services/theme_service.dart';
import 'package:taskuapp/screens/dashboard_screen.dart';
import 'package:taskuapp/screens/organizer_screen.dart';
import 'package:taskuapp/screens/profile_screen.dart';

class BottomNavShell extends StatefulWidget {
  const BottomNavShell({
    super.key,
    required this.user,
    required this.onSignOut,
  });

  final User user;
  final VoidCallback onSignOut;

  @override
  State<BottomNavShell> createState() => _BottomNavShellState();
}

class _BottomNavShellState extends State<BottomNavShell> {
  int _currentIndex = 0;
  late final PageController _pageController;
  bool _isAnimatingPage = false;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    if (index == _currentIndex) return;
    setState(() {
      _currentIndex = index;
      _isAnimatingPage = true;
    });
    _pageController
        .animateToPage(
          index,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOutCubic,
        )
        .then((_) {
          if (mounted) {
            setState(() {
              _isAnimatingPage = false;
            });
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.watch<ThemeService>();
    final List<Widget> pages = [
      HomePage(user: widget.user),
      OrganizerPage(user: widget.user),
      ProfilePage(user: widget.user, onSignOut: widget.onSignOut),
    ];

    return Scaffold(
      extendBody: true, // Let body extend behind the navigation bar
      body: PageView(
        controller: _pageController,
        physics: const BouncingScrollPhysics(),
        onPageChanged: (index) {
          if (!_isAnimatingPage) {
            setState(() {
              _currentIndex = index;
            });
          }
        },
        children: pages,
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                decoration: BoxDecoration(
                  color: theme.colors.surface,
                  borderRadius: BorderRadius.circular(32),
                  boxShadow: [
                    BoxShadow(
                      color: theme.colors.accent.withOpacity(0.3),
                      blurRadius: 16,
                      offset: const Offset(4, 8),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    // Sliding active item highlight
                    AnimatedPositioned(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOutCubic,
                      left: 6 + _currentIndex * 100.0,
                      top: 0,
                      bottom: 0,
                      width: 88,
                      child: Container(
                        decoration: BoxDecoration(
                          color: theme.colors.accent,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: theme.colors.accent.withOpacity(0.2),
                              blurRadius: 12,
                              offset: const Offset(1, 1),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Interactive nav items row
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _NavBarItem(
                          icon: Icons.dashboard_outlined,
                          activeIcon: Icons.dashboard,
                          isSelected: _currentIndex == 0,
                          onTap: () => _onItemTapped(0),
                        ),
                        _NavBarItem(
                          icon: Icons.event_note_outlined,
                          activeIcon: Icons.event_note,
                          isSelected: _currentIndex == 1,
                          onTap: () => _onItemTapped(1),
                        ),
                        _NavBarItem(
                          icon: Icons.person_outline,
                          activeIcon: Icons.person,
                          isSelected: _currentIndex == 2,
                          onTap: () => _onItemTapped(2),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavBarItem extends StatelessWidget {
  const _NavBarItem({
    required this.icon,
    required this.activeIcon,
    required this.isSelected,
    required this.onTap,
  });

  final IconData icon;
  final IconData activeIcon;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = context.watch<ThemeService>();
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 6),
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
        color: Colors.transparent,
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          transitionBuilder: (child, animation) {
            return FadeTransition(opacity: animation, child: child);
          },
          child: Icon(
            isSelected ? activeIcon : icon,
            key: ValueKey<bool>(isSelected),
            color: isSelected ? theme.colors.onDanger : theme.colors.accentDim,
            size: 24,
          ),
        ),
      ),
    );
  }
}
