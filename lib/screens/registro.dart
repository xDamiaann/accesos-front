import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PantallaRegistro extends StatefulWidget {
  @override
  _PantallaRegistroState createState() => _PantallaRegistroState();
}

class _PantallaRegistroState extends State<PantallaRegistro> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController nombreController = TextEditingController();
  final TextEditingController correoController = TextEditingController();
  final TextEditingController contrasenaController = TextEditingController();

  // Función para enviar datos al backend
  Future<void> _registrarUsuario() async {
    if (_formKey.currentState!.validate()) {
      // Asegúrate de reemplazar esta IP con tu dirección local
      final url = Uri.parse('http://10.0.2.2:3000/api/usuarios/registro');
      print('Intentando conectar a: $url'); // Debug URL

      final Map<String, dynamic> datos = {
        "nombre": nombreController.text,
        "correo": correoController.text,
        "contraseña": contrasenaController.text,
      };

      try {
        final response = await http.post(
          url,
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(datos),
        );

        print('Código de estado: ${response.statusCode}'); // Debug status code
        print('Respuesta: ${response.body}'); // Debug response body

        if (response.statusCode == 201) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Usuario registrado exitosamente')),
          );
          // Limpiar el formulario
          nombreController.clear();
          correoController.clear();
          contrasenaController.clear();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: ${response.body}')),
          );
        }
      } catch (e) {
        print('Error completo: $e'); // Debug error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al conectar con el servidor: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Registro de Usuario')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: nombreController,
                decoration: InputDecoration(labelText: 'Nombre'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'El nombre es obligatorio' : null,
              ),
              TextFormField(
                controller: correoController,
                decoration: InputDecoration(labelText: 'Correo'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) => !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value!)
                    ? 'Ingresa un correo válido'
                    : null,
              ),
              TextFormField(
                controller: contrasenaController,
                decoration: InputDecoration(labelText: 'Contraseña'),
                obscureText: true,
                validator: (value) => value == null || value.length < 6
                    ? 'La contraseña debe tener al menos 6 caracteres'
                    : null,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _registrarUsuario,
                child: Text('Registrarse'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
