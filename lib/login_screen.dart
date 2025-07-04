import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'api_service.dart';
import 'register_screen.dart';
import 'home_screen.dart';
import 'user_model.dart';           // <-- ¡import necesario!

class LoginScreen extends StatefulWidget {
  final VoidCallback toggleTheme;
  final bool isDarkMode;

  const LoginScreen({
    super.key,
    required this.toggleTheme,
    required this.isDarkMode,
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _email = TextEditingController();
  final _pass  = TextEditingController();
  bool  _obscure = true;
  String _msg = '';

  bool _validEmail(String e) =>
      RegExp(r'^[\w\-.]+@([\w-]+\.)+[\w-]{2,10}$').hasMatch(e);

  Future<void> _login() async {
    final email = _email.text.trim();
    final pass  = _pass.text.trim();

    if (!_validEmail(email)) {
      setState(() => _msg = 'Correo inválido');
      return;
    }

    final users = await ApiService.getUsers();
    final user  = users.firstWhere(
      (u) => u.username == email && u.password == pass,
      orElse: () => UserModel(username: '', password: '', id: ''),
    );

    if (user.username.isNotEmpty) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('session', email);

      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => HomeScreen(
            username: email,
            toggleTheme: widget.toggleTheme,
            isDarkMode: widget.isDarkMode,
          ),
        ),
      );
    } else {
      setState(() => _msg = 'Credenciales incorrectas');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Iniciar sesión'),
        actions: [
          IconButton(
            icon: Icon(widget.isDarkMode ? Icons.light_mode : Icons.dark_mode),
            onPressed: widget.toggleTheme,
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _email,
              decoration: const InputDecoration(labelText: 'Correo'),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _pass,
              obscureText: _obscure,
              decoration: InputDecoration(
                labelText: 'Contraseña',
                suffixIcon: IconButton(
                  icon: Icon(_obscure ? Icons.visibility_off : Icons.visibility),
                  onPressed: () => setState(() => _obscure = !_obscure),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: _login, child: const Text('Ingresar')),
            TextButton(
              onPressed: () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => RegisterScreen(
                    toggleTheme: widget.toggleTheme,
                    isDarkMode: widget.isDarkMode,
                  ),
                ),
              ),
              child: const Text('¿No tienes cuenta? Regístrate'),
            ),
            if (_msg.isNotEmpty)
              Text(_msg, style: const TextStyle(color: Colors.red)),
          ],
        ),
      ),
    );
  }
}
