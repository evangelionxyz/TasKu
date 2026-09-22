import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:taskuapp/globals/globals.dart';
import 'package:taskuapp/services/theme_service.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key, required this.user, required this.onSignOut});

  final User user;
  final VoidCallback onSignOut;

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late String _displayName;

  @override
  void initState() {
    super.initState();
    _displayName =
        widget.user.displayName ??
        widget.user.email?.split('@').first ??
        'User';
  }

  Future<void> _updateDisplayName(String newName) async {
    if (newName.trim().isEmpty) return;
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await user.updateDisplayName(newName);
        await user.reload();
        setState(() {
          _displayName =
              FirebaseAuth.instance.currentUser?.displayName ?? newName;
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Display name updated successfully!'),
              behavior: SnackBarBehavior.floating,
              margin: EdgeInsets.only(bottom: 100, left: 20, right: 20),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update display name: $e'),
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.only(bottom: 100, left: 20, right: 20),
          ),
        );
      }
    }
  }

  void _showEditNameSheet(ThemeService theme) {
    final controller = TextEditingController(text: _displayName);
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Dismiss',
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (ctx, anim1, anim2) {
        return Align(
          alignment: Alignment.bottomCenter,
          child: Material(
            type: MaterialType.transparency,
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                20,
                24,
                20,
                MediaQuery.of(ctx).viewInsets.bottom + 24,
              ),
              child: Container(
                color: theme.colors.card,
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Edit Name',
                      style: TextStyle(
                        fontFamily: 'Roxborough',
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: theme.colors.onCard,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: controller,
                      autofocus: true,
                      style: TextStyle(
                        color: theme.colors.onCard,
                        fontFamily: 'Telegraf',
                      ),
                      decoration: InputDecoration(
                        labelText: 'Display Name',
                        labelStyle: TextStyle(color: theme.colors.accent),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.zero,
                          borderSide: BorderSide(
                            color: theme.colors.accent,
                            width: 2,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.zero,
                          borderSide: BorderSide(
                            color: theme.colors.onCard,
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () => Navigator.pop(ctx),
                          child: Text(
                            'CANCEL',
                            style: TextStyle(
                              color: theme.colors.accent,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        ElevatedButton(
                          onPressed: () {
                            _updateDisplayName(controller.text);
                            Navigator.pop(ctx);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: theme.colors.accent,
                            foregroundColor: theme.colors.onDanger,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.zero,
                            ),
                          ),
                          child: const Text('SAVE'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
      transitionBuilder: (ctx, anim1, anim2, child) {
        final curve = CurvedAnimation(
          parent: anim1,
          curve: Curves.easeOutCubic,
        );
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 1),
            end: Offset.zero,
          ).animate(curve),
          child: child,
        );
      },
    );
  }

  void _showHelpCenter(ThemeService theme) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Dismiss',
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (ctx, anim1, anim2) {
        final screenHeight = MediaQuery.of(ctx).size.height;
        return Align(
          alignment: Alignment.bottomCenter,
          child: Material(
            type: MaterialType.transparency,
            child: Container(
              height: screenHeight * 0.7,
              color: theme.colors.card,
              child: Column(
                children: [
                  AppBar(
                    title: Text(
                      'Help Center',
                      style: TextStyle(
                        fontFamily: 'Roxborough',
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: theme.colors.onCard,
                      ),
                    ),
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    automaticallyImplyLeading: false,
                    actions: [
                      IconButton(
                        icon: Icon(Icons.close, color: theme.colors.onCard),
                        onPressed: () => Navigator.pop(ctx),
                      ),
                    ],
                  ),
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      children: [
                        _buildFaqItem(
                          theme,
                          'How do I sync my bag checklist?',
                          'Tap the Cloud Sync row under the Connectivity section on the Dashboard. It will force a re-fetch of your tasks from Firestore.',
                        ),
                        _buildFaqItem(
                          theme,
                          'My Bluetooth connection is lost. What should I do?',
                          'Make sure the bag is powered on and within Bluetooth range of your phone. Connection will automatically restore once the bag is nearby.',
                        ),
                        _buildFaqItem(
                          theme,
                          'How does the compartment map work?',
                          'The Organizer screen contains a Compartment tab showing an overview map. It highlights active compartment status to let you know if you have placed items correctly.',
                        ),
                        _buildFaqItem(
                          theme,
                          'Is my bag locked or unlocked?',
                          'You can view and control the security status directly in the Security & Motion card on the Dashboard.',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
      transitionBuilder: (ctx, anim1, anim2, child) {
        final curve = CurvedAnimation(
          parent: anim1,
          curve: Curves.easeOutCubic,
        );
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 1),
            end: Offset.zero,
          ).animate(curve),
          child: child,
        );
      },
    );
  }

  Widget _buildFaqItem(ThemeService theme, String question, String answer) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            question,
            style: TextStyle(
              fontFamily: 'Telegraf',
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: theme.colors.accent,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            answer,
            style: TextStyle(
              fontFamily: 'Telegraf',
              fontSize: 14,
              color: theme.colors.onCard.withValues(alpha: 0.85),
              height: 1.4,
            ),
          ),
          const SizedBox(height: 12),
          Divider(color: theme.colors.accent.withValues(alpha: 0.2)),
        ],
      ),
    );
  }

  Future<void> _deleteAccount(ThemeService theme) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: theme.colors.card,
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
          title: Text(
            'Delete Account',
            style: TextStyle(
              fontFamily: 'Roxborough',
              color: theme.colors.onCard,
            ),
          ),
          content: Text(
            'Are you sure you want to permanently delete your account? This action cannot be undone.',
            style: TextStyle(
              fontFamily: 'Telegraf',
              color: theme.colors.onCard,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(
                'CANCEL',
                style: TextStyle(color: theme.colors.accent),
              ),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colors.danger,
                foregroundColor: theme.colors.onDanger,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero,
                ),
              ),
              child: const Text('DELETE'),
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      try {
        final user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          await user.delete();
        }
      } on FirebaseAuthException catch (e) {
        if (e.code == 'requires-recent-login') {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text(
                  'Please sign out and sign in again before deleting your account for security reasons.',
                ),
                backgroundColor: theme.colors.danger,
                behavior: SnackBarBehavior.floating,
                margin: const EdgeInsets.only(bottom: 100, left: 20, right: 20),
                duration: const Duration(seconds: 5),
              ),
            );
          }
        } else {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Failed to delete account: ${e.message}'),
                backgroundColor: theme.colors.danger,
                behavior: SnackBarBehavior.floating,
                margin: const EdgeInsets.only(bottom: 100, left: 20, right: 20),
              ),
            );
          }
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error deleting account: $e'),
              backgroundColor: theme.colors.danger,
              behavior: SnackBarBehavior.floating,
              margin: const EdgeInsets.only(bottom: 100, left: 20, right: 20),
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.watch<ThemeService>();
    final String? photoUrl = widget.user.photoURL;
    final bool hasPhoto = photoUrl != null && photoUrl.isNotEmpty;

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
              'Profile',
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
        children: [
          // ── Profile Info Card ──────────────────────────────────────────────
          Stack(
            children: [
              Positioned(
                left: 5,
                top: 5,
                right: 0,
                bottom: 0,
                child: Container(color: theme.colors.onCard),
              ),
              Container(
                color: theme.colors.card,
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 36,
                      backgroundColor: theme.colors.accentDim,
                      backgroundImage: hasPhoto ? NetworkImage(photoUrl) : null,
                      child: !hasPhoto
                          ? Text(
                              _displayName.isNotEmpty
                                  ? _displayName[0].toUpperCase()
                                  : 'U',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: theme.colors.onDanger,
                                fontFamily: 'Roxborough',
                              ),
                            )
                          : null,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  _displayName,
                                  style: TextStyle(
                                    fontFamily: 'Roxborough',
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    color: theme.colors.onCard,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.edit_note,
                                  color: theme.colors.accent,
                                  size: 22,
                                ),
                                onPressed: () => _showEditNameSheet(theme),
                              ),
                            ],
                          ),
                          Text(
                            widget.user.email ?? 'No email associated',
                            style: TextStyle(
                              fontFamily: 'Telegraf',
                              fontSize: 13,
                              color: theme.colors.onCard.withValues(alpha: 0.6),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // ── Settings Rows ──────────────────────────────────────────────────
          _buildSettingsHeader(theme, 'Preferences'),
          _buildSettingsCard(
            theme,
            children: [
              _buildSwitchRow(
                theme: theme,
                icon: Icons.dark_mode_outlined,
                title: 'Dark Mode',
                value: theme.isDark,
                onChanged: (val) => theme.toggleTheme(),
              ),
            ],
          ),
          const SizedBox(height: 24),

          _buildSettingsHeader(theme, 'Support & Account'),
          _buildSettingsCard(
            theme,
            children: [
              _buildTappableRow(
                theme: theme,
                icon: Icons.help_outline,
                title: 'Help Center',
                onTap: () => _showHelpCenter(theme),
              ),
              Divider(
                height: 1,
                color: theme.colors.accent.withValues(alpha: 0.2),
              ),
              _buildTappableRow(
                theme: theme,
                icon: Icons.delete_outline,
                title: 'Delete Account',
                titleColor: theme.colors.danger,
                onTap: () => _deleteAccount(theme),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // ── Sign Out Row ───────────────────────────────────────────────────
          GestureDetector(
            onTap: widget.onSignOut,
            child: SizedBox(
              width: double.infinity,
              child: Stack(
                children: [
                  Positioned(
                    left: 5,
                    top: 5,
                    right: 0,
                    bottom: 0,
                    child: Container(color: theme.colors.onCard),
                  ),
                  Container(
                    color: theme.colors.accent,
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.logout,
                          color: theme.colors.onDanger,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'SIGN OUT',
                          style: TextStyle(
                            fontFamily: 'Telegraf',
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: theme.colors.onDanger,
                            letterSpacing: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsHeader(ThemeService theme, String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          fontFamily: 'Roxborough',
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: theme.colors.accent,
          letterSpacing: 1,
        ),
      ),
    );
  }

  Widget _buildSettingsCard(
    ThemeService theme, {
    required List<Widget> children,
  }) {
    return Stack(
      children: [
        Positioned(
          left: 5,
          top: 5,
          right: 0,
          bottom: 0,
          child: Container(color: theme.colors.onCard),
        ),
        Material(
          color: theme.colors.card,
          child: Column(children: children),
        ),
      ],
    );
  }

  Widget _buildSwitchRow({
    required ThemeService theme,
    required IconData icon,
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Icon(icon, color: theme.colors.accent, size: 22),
          const SizedBox(width: 12),
          Text(
            title,
            style: TextStyle(
              fontFamily: 'Telegraf',
              fontSize: 15,
              color: theme.colors.onCard,
            ),
          ),
          const Spacer(),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: theme.colors.accent,
            activeTrackColor: theme.colors.accentDim,
            inactiveThumbColor: theme.colors.accentDim,
            inactiveTrackColor: theme.colors.surface,
          ),
        ],
      ),
    );
  }

  Widget _buildTappableRow({
    required ThemeService theme,
    required IconData icon,
    required String title,
    Color? titleColor,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: titleColor ?? theme.colors.accent, size: 22),
      title: Text(
        title,
        style: TextStyle(
          fontFamily: 'Telegraf',
          fontSize: 15,
          color: titleColor ?? theme.colors.onCard,
        ),
      ),
      trailing: Icon(
        Icons.chevron_right,
        color: titleColor ?? theme.colors.accent,
        size: 20,
      ),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
    );
  }
}
