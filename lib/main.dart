
// ignore_for_file: unused_field, use_key_in_widget_constructors, library_private_types_in_public_api, annotate_overrides, use_super_parameters, prefer_const_constructors

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hotel_aplicacion/dbHelper/mongodb.dart';
import 'package:hotel_aplicacion/pantallas/habitaciones.dart';
import 'package:hotel_aplicacion/pantallas/pantalla1.dart';
import 'package:hotel_aplicacion/pantallas/pantallainicio.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
 
  WidgetsFlutterBinding.ensureInitialized(); 
 /* SharedPreferences prefs = await SharedPreferences.getInstance();
  bool inicio = prefs.getBool('inicio') ?? false;

  Widget initialRoute = inicio ? const MyApp2() : const MyApp();*/
  runApp(MyApp());
   if (kDebugMode) {
     print("APLICACION INICIADA");
   }

   
  

  
}

void guardarValorBoolPref(String key, bool value) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setBool(key, value);
}

/*class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  
  Widget build(BuildContext context) {
    
    guardarValorBoolPref('inicio', false);
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: pantalla1(),
      
    );
  }
}*/

class pruebap1 extends StatefulWidget {
  const pruebap1({super.key});

  @override
  State<pruebap1> createState() => _pruebap1State();
}

class _pruebap1State extends State<pruebap1> {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
            debugShowCheckedModeBanner: false,
            home: pantalla1(), // Redirige al usuario a la pantalla1 si la conexión se establece correctamente
          );
  }
}

class MyApp extends StatefulWidget {
  @override
    _MyAppState createState() => _MyAppState();

}

class _MyAppState extends State<MyApp> {
  Future<bool>? _connectionFuture;
  @override
  void initState() {
    super.initState();
    _connectionFuture = MongoDatabase.connect();
  }
    void _retryConnection() {
    setState(() {
      _connectionFuture = MongoDatabase.connect();
    });
  }
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _connectionFuture, 
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Waiting(), 
          );
        } else if (snapshot.hasError || snapshot.data == false) {
          return MaterialApp
           (
            debugShowCheckedModeBanner: false,
           home : Scaffold(
            appBar: AppBar(
              title: const Text('Error de conexión'),
              
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('No se pudo establecer conexión a la base de datos'), 
                  ElevatedButton(
                    onPressed: _retryConnection,
                    child: const Text('Intentar nuevamente'),
                  ),
                ],
              ),
            ),
          ));
        } else {
          return const MaterialApp(
            debugShowCheckedModeBanner: false,
            home: pantalla1(), // Redirige al usuario a la pantalla1 si la conexión se establece correctamente
          );
        }
      },
    );
  }
}

class Waiting extends StatelessWidget {
  const Waiting({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Esperando conexión'),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(), // Muestra un círculo de progreso
            SizedBox(height: 20),
            Text('Intentando establecer conexión...'), // Muestra un mensaje mientras se intenta la conexión
          ],
        ),
      ),
    );
  }
}