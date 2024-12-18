import 'package:flutter/material.dart';
import 'screens/bienvenida.dart';
import 'package:flutter/services.dart';
import 'screens/login.dart';
import 'screens/home.dart';
import 'screens/opciones.dart';
import 'screens/registro.dart';
import 'screens/recuperar_password.dart';
import 'screens/actualizar_password.dart';
import 'screens/validar_codigo.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized(); // Asegura inicialización de widgets
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp, // Forzar modo vertical hacia arriba
    DeviceOrientation.portraitDown, // Forzar modo vertical hacia abajo (opcional)
  ]).then((_) {
    runApp(AppControlAccesos());
  });
}

class AppControlAccesos extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Control de Accesos',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/', // Ruta inicial
      routes: {
        '/': (context) => PantallaBienvenida(), // Ruta inicial
        '/login': (context) => PantallaLogin(), // Ruta para Login
        '/home': (context) => PantallaHome(), // Ruta para Home
        '/recuperar': (context) => RecuperarPassword(), // Recuperar contraseña
        '/validar-codigo': (context) => ValidarCodigo(correo: ''), // Validar código
        '/actualizar-password': (context) => ActualizarPassword(correo: ''), // Actualizar contraseña
      },
    );
  }
}