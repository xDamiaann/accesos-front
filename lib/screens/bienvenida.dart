import 'package:flutter/material.dart';
import 'opciones.dart';

class PantallaBienvenida extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '¡Bienvenido a la Aplicación de Control de Accesos!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navegar a la siguiente pantalla
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PantallaOpciones()),
                );
              },
              child: Text('Empezar'),
            ),
          ],
        ),
      ),
    );
  }
}
