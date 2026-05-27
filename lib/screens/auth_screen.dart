import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:taskuapp/navbar/bottom_nav.dart';
import 'package:taskuapp/globals/globals.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});
  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (!mounted || googleUser == null) {
        return;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);
    } catch (error) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Google sign-in failed: $error')));
    }
  }

  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
    await _googleSignIn.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final User? user = snapshot.data;
        if (user != null) {
          return BottomNavShell(user: user, onSignOut: _signOut);
        }

        return Scaffold(
          body: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(color: AppColors.light),
            child: Padding(
              padding: const EdgeInsets.all(64),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  TweenAnimationBuilder<double>(
                    tween: Tween<double>(begin: 0.0, end: 1.0),
                    duration: Duration(milliseconds: 1000),
                    curve: Curves.decelerate,
                    builder:
                        (BuildContext context, double value, Widget? child) {
                          return Opacity(opacity: value, child: child);
                        },
                    child: const AppTitle(),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Sign in to continue',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 28,
                      fontFamily: "Roxborough",
                      fontWeight: FontWeight(700),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Use your Google account\nto access your TasKu profile.',
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: "Roxborough",
                      fontWeight: FontWeight(700),
                    ),
                  ),
                  const SizedBox(height: 16),
                  GestureDetector(
                    onTap: () {
                      _signInWithGoogle();
                    },
                    child: SizedBox(
                      width: double.infinity,
                      height: 64.0,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          TweenAnimationBuilder<Offset>(
                            tween: Tween<Offset>(
                              begin: const Offset(0, 0),
                              end: const Offset(12, 12),
                            ),
                            duration: const Duration(milliseconds: 1000),
                            curve: Curves.easeInOutCubic,
                            builder:
                                (
                                  BuildContext context,
                                  Offset value,
                                  Widget? child,
                                ) {
                                  return Transform.translate(
                                    offset: value,
                                    child: child,
                                  );
                                },
                            child: Container(
                              color: AppColors.dark,
                              width: double.infinity,
                              height: 48,
                            ),
                          ),

                          Transform.translate(
                            key: UniqueKey(),
                            offset: const Offset(0, 0),
                            child: Container(
                              color: AppColors.olive,
                              width: double.infinity,
                              height: 48,
                              padding: EdgeInsets.fromLTRB(12, 8, 12, 8),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  // icon
                                  Container(
                                    width: 24,
                                    height: 24,
                                    decoration: BoxDecoration(
                                      color: Colors.transparent,
                                      borderRadius: BorderRadius.circular(11),
                                    ),
                                    alignment: Alignment.center,
                                    child: const Image(
                                      image: AssetImage("assets/google.png"),
                                    ),
                                  ),
                                  SizedBox(width: 12),
                                  const Text(
                                    'Continue with Google',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontFamily: "Roxborough",
                                      fontWeight: FontWeight(700),
                                      color: AppColors.light,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
