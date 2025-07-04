import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_screen.dart';
import 'home_screen.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isDark = false;

  Future<String?> _session() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('session');
  }

  void _toggle() => setState(() => _isDark = !_isDark);

  @override
  Widget build(BuildContext context) {
    final theme = _isDark
        ? ThemeData.dark(useMaterial3: true)
        : ThemeData.light(useMaterial3: true).copyWith(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          );

    return MaterialApp(
      title: 'App Tareas',
      debugShowCheckedModeBanner: false,
      theme: theme,
      home: FutureBuilder<String?>(
        future: _session(),
        builder: (context, snap) {
          if (snap.connectionState != ConnectionState.done) {
            return const Scaffold(body: Center(child: CircularProgressIndicator()));
          }
          return snap.data == null
              ? LoginScreen(toggleTheme: _toggle, isDarkMode: _isDark)
              : HomeScreen(username: snap.data!, toggleTheme: _toggle, isDarkMode: _isDark);
        },
      ),
    );
  }
}