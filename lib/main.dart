import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:permission_handler/permission_handler.dart';

import 'screens/about_page.dart';
import 'screens/covid_tracker_page.dart';
import 'screens/emsi_chatbot_page.dart';
import 'screens/history_page.dart';
import 'screens/home_page.dart';
import 'screens/ingredient_recognition.dart';
import 'screens/login_page.dart';
import 'screens/profile_page.dart';
import 'screens/register_page.dart';
import 'screens/settings_page.dart';
import 'screens/fruit_classifier.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await requestCameraPermission(); // Request camera permission
  runApp(const MyApp());
}

// Function to request camera permissions
Future<void> requestCameraPermission() async {
  var status = await Permission.camera.request();
  if (status.isDenied || status.isPermanentlyDenied) {
    // Handle denied permissions here
    print("Camera permission denied.");
  } else {
    print("Camera permission granted.");
  }
}

class ThemeProvider with ChangeNotifier {
  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Flutter Rachouady',
            theme: ThemeData(
              brightness:
                  themeProvider.isDarkMode ? Brightness.dark : Brightness.light,
              colorScheme: themeProvider.isDarkMode
                  ? ColorScheme.dark(
                      primary: Colors.green[700] ?? Colors.green,
                    )
                  : const ColorScheme.light(
                      primary: Colors.green,
                    ),
              useMaterial3: true,
            ),
            routes: {
              '/login': (context) => const LoginPage(),
              '/register': (context) => const RegisterPage(),
              '/home': (context) => const HomePage(),
              '/emsi_chatbot': (context) => const EmsiChatbotPage(),
              '/covid_tracker': (context) => const CovidTrackerPage(),
              '/settings': (context) => const SettingsPage(),
              '/about': (context) => const AboutPage(),
              '/profile': (context) => const ProfilePage(),
              '/fruit_classifier': (context) => const ImageClassifier(),
              '/history': (context) => const HistoryPage(),
              '/ingredient_recognition': (context) =>
                  const IngredientRecognitionScreen(),
            },
            initialRoute: '/login',
          );
        },
      ),
    );
  }
}
