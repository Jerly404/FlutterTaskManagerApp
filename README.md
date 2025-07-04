# 📱 FlutterTaskManagerApp

**FlutterTaskManagerApp** es una aplicación móvil desarrollada en Flutter que permite a los usuarios gestionar sus tareas personales de manera eficiente. Ofrece autenticación por correo electrónico, alternancia entre temas claro y oscuro, y funcionalidades completas de CRUD (Crear, Leer, Actualizar, Eliminar) para tareas.

## 🚀 Funcionalidades principales

- 🔐 Autenticación de usuarios (inicio de sesión y registro con correo electrónico)
- ✅ Gestión de tareas (crear, editar, eliminar tareas)
- 🌓 Modo claro / modo oscuro con botón dinámico 🌙 / ☀️
- 💾 Persistencia de sesión mediante `SharedPreferences`
- 🔗 Integración con API REST (utilizando MockAPI.io como backend simulado)

## 🧾 Estructura del proyecto

```plaintext
lib/
├── api_service.dart        -> Maneja la conexión con la API para usuarios y tareas
├── home_screen.dart        -> Pantalla principal donde se gestionan las tareas
├── login_screen.dart       -> Pantalla de inicio de sesión
├── main.dart               -> Punto de entrada de la aplicación y configuración del tema
├── register_screen.dart    -> Pantalla de registro de nuevos usuarios
├── task_model.dart         -> Modelo de datos para las tareas
├── user_model.dart         -> Modelo de datos para los usuarios

⚙️ Requisitos
plaintext
Copiar
Editar
- Flutter SDK instalado (versión estable recomendada)
- Conexión a internet para interactuar con la API (MockAPI.io)
- Editor de código recomendado: Visual Studio Code o Android Studio

👨‍💻 Autor
plaintext
Copiar
Editar
Desarrollado por Jerly  
Estudiante de Ingeniería de Sistemas  
Universidad Privada del Norte

📌 Notas
plaintext
Copiar
Editar
- Este proyecto puede usarse como base para apps de gestión personal o productiva.
- El backend (MockAPI) puede reemplazarse por uno real como Firebase, Supabase o Node.js.
- Se recomienda aplicar buenas prácticas de seguridad si se piensa usar en producción.
