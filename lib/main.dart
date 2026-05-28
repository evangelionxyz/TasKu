import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taskuapp/screens/auth_screen.dart';
import 'package:taskuapp/services/bag_service.dart';
import 'package:taskuapp/services/organizer_service.dart';
import 'package:taskuapp/services/theme_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final prefs = await SharedPreferences.getInstance();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeService(prefs)),
        ChangeNotifierProvider(create: (_) => BagService()),
        // OrganizerService subscribes to Firebase Auth internally
        // and handles uid changes without rebuilding the tree.
        ChangeNotifierProvider(create: (_) => OrganizerService()),
      ],
      child: const App(),
    ),
  );
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.watch<ThemeService>();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Telegraf',
        brightness: theme.isDark ? Brightness.dark : Brightness.light,
        scaffoldBackgroundColor: theme.colors.bg,
      ),
      home: const AuthPage(),
    );
  }
}
