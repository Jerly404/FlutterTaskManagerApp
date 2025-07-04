import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'api_service.dart';
import 'login_screen.dart';
import 'task_model.dart';
import 'user_model.dart';

class HomeScreen extends StatefulWidget {
  final String username;
  final VoidCallback toggleTheme;
  final bool isDarkMode;

  const HomeScreen({
    super.key,
    required this.username,
    required this.toggleTheme,
    required this.isDarkMode,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? _userId;
  List<TaskModel> _tareas = [];

  final _titulo      = TextEditingController();
  final _descripcion = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initUserAndTasks();
  }

  Future<void> _initUserAndTasks() async {
    // 1) Obtener id del usuario por su correo
    final users = await ApiService.getUsers();
    final user  = users.firstWhere((u) => u.username == widget.username,
        orElse: () => UserModel(id: '', username: '', password: ''));
    _userId = user.id;

    // 2) Cargar tareas
    await _cargarTareas();
  }

  Future<void> _cargarTareas() async {
    if (_userId == null || _userId!.isEmpty) return;
    final data = await ApiService.getTasks(_userId!);
    setState(() => _tareas = data);
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('session');
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

  Future<void> _crearEditarTarea({TaskModel? tarea}) async {
    _titulo.text      = tarea?.titulo      ?? '';
    _descripcion.text = tarea?.descripcion ?? '';

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(tarea == null ? 'Nueva tarea' : 'Editar tarea'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: _titulo,      decoration: const InputDecoration(labelText: 'Título')),
            TextField(controller: _descripcion, decoration: const InputDecoration(labelText: 'Descripción')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
          ElevatedButton(
            onPressed: () async {
              final nueva = TaskModel(
                id: tarea?.id ?? '',
                titulo: _titulo.text.trim(),
                descripcion: _descripcion.text.trim(),
                userId: _userId!,
              );

              if (tarea == null) {
                await ApiService.postTask(nueva);
              } else {
                await ApiService.putTask(nueva);
              }

              if (!mounted) return;
              Navigator.pop(context);
              _cargarTareas();
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }

  Future<void> _eliminarTarea(String id) async {
    await ApiService.deleteTask(id);
    _cargarTareas();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hola, ${widget.username.split('@').first}'),
        actions: [
          IconButton(
            icon: Icon(widget.isDarkMode ? Icons.light_mode : Icons.dark_mode),
            onPressed: widget.toggleTheme,
          ),
          IconButton(icon: const Icon(Icons.logout), onPressed: _logout),
        ],
      ),
      body: _tareas.isEmpty
          ? const Center(child: Text('No hay tareas aún'))
          : ListView.builder(
              itemCount: _tareas.length,
              itemBuilder: (_, i) {
                final t = _tareas[i];
                return ListTile(
                  title: Text(t.titulo),
                  subtitle: Text(t.descripcion),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () => _crearEditarTarea(tarea: t),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => _eliminarTarea(t.id),
                      ),
                    ],
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _crearEditarTarea(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
