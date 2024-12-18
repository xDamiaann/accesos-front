import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'validar_codigo.dart'; // Importar la pantalla de validación de código

class RecuperarPassword extends StatefulWidget {
  @override
  _RecuperarPasswordState createState() => _RecuperarPasswordState();
}

class _RecuperarPasswordState extends State<RecuperarPassword> {
  final TextEditingController correoController = TextEditingController();
  String mensaje = '';

  Future<void> enviarCodigoRecuperacion() async {
    final String correo = correoController.text.trim();

    if (correo.isEmpty) {
      setState(() {
        mensaje = 'Por favor, ingresa tu correo electrónico.';
      });
      return;
    }

    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:3000/api/usuarios/recuperar'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"correo": correo}),
      );

      if (response.statusCode == 200) {
        setState(() {
          mensaje = 'Código de verificación enviado a tu correo.';
        });

        // Navegar a la pantalla de validación de código
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ValidarCodigo(correo: correo)),
        );
      } else {
        final data = jsonDecode(response.body);
        setState(() {
          mensaje = data['mensaje'] ?? 'Error al enviar el código.';
        });
      }
    } catch (e) {
      setState(() {
        mensaje = 'Error de conexión con el servidor.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recuperar Contraseña'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Ingresa tu correo electrónico para recuperar tu contraseña.',
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            TextField(
              controller: correoController,
              decoration: InputDecoration(
                labelText: 'Correo Electrónico',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: enviarCodigoRecuperacion,
              child: Text('Enviar Código'),
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
