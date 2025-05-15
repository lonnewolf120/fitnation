import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:fitnation/Screens/Auth/Login.dart';
import 'package:fitnation/Screens/Auth/Signup.dart';
// import 'package:fitnation/screens/verify_email_screen.dart';
// import 'package:fitnation';
import 'package:fitnation/providers/theme_provider.dart';

// Define a provider for SharedPreferences
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError();
});

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  runApp(
    ProviderScope(
      overrides: [
        // Override the sharedPreferencesProvider with the initialized instance
        sharedPreferencesProvider.overrideWithValue(prefs),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the theme mode from the provider
    final themeMode = ref.watch(themeNotifierProvider);

    return MaterialApp(
      title: 'Fitness App',
      theme: AppThemes.lightTheme, // Your light theme
      darkTheme: AppThemes.darkTheme, // Your dark theme
      themeMode: themeMode, // Controlled by Riverpod
      debugShowCheckedModeBanner: false,
      home: const LoginScreen(), // Or your AuthWrapper
      routes: {
        '/login': (context) => const LoginScreen(),
        '/create_account': (context) => const CreateAccountScreen(),
        '/verify_email':
            (context) => const VerifyEmailScreen(email: 'sara@cruz.com'),
        // Add a settings screen route if you want to test theme switching
        '/settings': (context) => const SettingsScreen(),
      },
    );
  }
}

// Example Settings Screen to change theme
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentAppThemeMode =
        ref.watch(themeNotifierProvider.notifier).currentAppThemeMode;

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          ListTile(
            title: const Text('Theme'),
            trailing: DropdownButton<AppThemeMode>(
              value: currentAppThemeMode,
              items:
                  AppThemeMode.values.map((AppThemeMode mode) {
                    return DropdownMenuItem<AppThemeMode>(
                      value: mode,
                      child: Text(mode.toString().split('.').last.capitalize()),
                    );
                  }).toList(),
              onChanged: (AppThemeMode? newMode) {
                if (newMode != null) {
                  ref
                      .read(themeNotifierProvider.notifier)
                      .setThemeMode(newMode);
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

// Helper extension for capitalizing strings
extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
}
