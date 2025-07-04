import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'api_service.dart';
import 'user_model.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  final VoidCallback toggleTheme;
  final bool isDarkMode;

  const RegisterScreen({
    super.key,
    required this.toggleTheme,
    required this.isDarkMode,
  });

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  bool _obscure = true;
  String _msg = '';

  final _emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

  Future<void> _register() async {
    final email = _emailController.text.trim();
    final pass = _passController.text.trim();

    if (!_emailRegex.hasMatch(email)) {
      setState(() => _msg = 'Correo inválido');
      return;
    }
    if (pass.length < 4) {
      setState(() => _msg = 'Contraseña muy corta (mín. 4)');
      return;
    }

    final users = await ApiService.getUsers();
    final exists = users.any((u) => u.username == email);
    if (exists) {
      setState(() => _msg = 'Correo ya registrado');
      return;
    }

    final newUser = UserModel(username: email, password: pass, id: '');
    await ApiService.postUser(newUser);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('session', email);

    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => LoginScreen(
          toggleTheme: widget.toggleTheme,
          isDarkMode: widget.isDarkMode,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registrarse'),
        actions: [
          IconButton(
            icon: Icon(widget.isDarkMode ? Icons.light_mode : Icons.dark_mode),
            onPressed: widget.toggleTheme,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Correo electrónico'),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _passController,
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
            ElevatedButton(
              onPressed: _register,
              child: const Text('Registrar'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('¿Ya tienes cuenta? Inicia sesión'),
            ),
            if (_msg.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(_msg, style: const TextStyle(color: Colors.red)),
              ),
          ],
        ),
      ),
    );
  }
}
