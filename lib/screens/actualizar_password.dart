import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ActualizarPassword extends StatefulWidget {
  final String correo; // Correo del usuario recibido como parámetro

  const ActualizarPassword({Key? key, required this.correo}) : super(key: key);

  @override
  _ActualizarPasswordState createState() => _ActualizarPasswordState();
}

class _ActualizarPasswordState extends State<ActualizarPassword> {
  final TextEditingController nuevaPasswordController = TextEditingController();
  final TextEditingController confirmarPasswordController =
      TextEditingController();
  String mensaje = '';
  bool _isLoading = false;

  Future<void> actualizarPassword() async {
    final String nuevaPassword = nuevaPasswordController.text.trim();
    final String confirmarPassword = confirmarPasswordController.text.trim();

    if (nuevaPassword.isEmpty || confirmarPassword.isEmpty) {
      setState(() {
        mensaje = 'Por favor, completa todos los campos.';
      });
      return;
    }

    if (nuevaPassword != confirmarPassword) {
      setState(() {
        mensaje = 'Las contraseñas no coinciden.';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      mensaje = '';
    });

    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:3000/api/usuarios/actualizar-password'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "correo": widget.correo,
          "nuevaContrasenia": nuevaPassword,
        }),
      );

      if (response.statusCode == 200) {
        setState(() {
          mensaje = 'Contraseña actualizada correctamente.';
        });

        // Redirigir al login
        Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
      } else {
        final data = jsonDecode(response.body);
        setState(() {
          mensaje = data['mensaje'] ?? 'Error al actualizar la contraseña.';
        });
      }
    } catch (e) {
      setState(() {
        mensaje = 'Error de conexión con el servidor.';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Actualizar Contraseña'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Ingresa tu nueva contraseña.',
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            TextField(
              controller: nuevaPasswordController,
              decoration: InputDecoration(
                labelText: 'Nueva Contraseña',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            SizedBox(height: 15),
            TextField(
              controller: confirmarPasswordController,
              decoration: InputDecoration(
                labelText: 'Confirmar Contraseña',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            SizedBox(height: 20),
            _isLoading
                ? Center(child: CircularProgressIndicator())
                : ElevatedButton(
                    onPressed: actualizarPassword,
                    child: Text('Actualizar Contraseña'),
                  ),
            SizedBox(height: 10),
            Text(
              mensaje,
              style: TextStyle(color: Colors.red, fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
