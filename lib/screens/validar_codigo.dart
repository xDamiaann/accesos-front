import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'actualizar_password.dart';

class ValidarCodigo extends StatefulWidget {
  final String correo; // Recibimos el correo del usuario desde la pantalla anterior

  const ValidarCodigo({Key? key, required this.correo}) : super(key: key);

  @override
  _ValidarCodigoState createState() => _ValidarCodigoState();
}

class _ValidarCodigoState extends State<ValidarCodigo> {
  final TextEditingController codigoController = TextEditingController();
  String mensaje = '';
  bool _isLoading = false;

  Future<void> validarCodigo() async {
    final String codigo = codigoController.text.trim();

    if (codigo.isEmpty) {
      setState(() {
        mensaje = 'Por favor, ingresa el código de verificación.';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      mensaje = '';
    });

    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:3000/api/usuarios/validar-codigo'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "correo": widget.correo,
          "codigo": codigo,
        }),
      );

      if (response.statusCode == 200) {
        setState(() {
          mensaje = 'Código validado correctamente.';
        });

        // Navegar a la pantalla de actualización de contraseña
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ActualizarPassword(correo: widget.correo),
          ),
        );
      } else {
        final data = jsonDecode(response.body);
        setState(() {
          mensaje = data['mensaje'] ?? 'Error al validar el código.';
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
        title: Text('Validar Código'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Ingresa el código de verificación enviado a tu correo.',
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            TextField(
              controller: codigoController,
              decoration: InputDecoration(
                labelText: 'Código de Verificación',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            _isLoading
                ? Center(child: CircularProgressIndicator())
                : ElevatedButton(
                    onPressed: validarCodigo,
                    child: Text('Validar Código'),
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
