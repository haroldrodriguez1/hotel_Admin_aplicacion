// ignore_for_file: use_super_parameters, library_private_types_in_public_api, prefer_const_constructors

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hotel_aplicacion/dbHelper/ModelCodigoAdmin.dart';
import 'package:hotel_aplicacion/dbHelper/mongodb.dart';
import 'package:hotel_aplicacion/pantallas/displaynotificaciones.dart';
import 'package:hotel_aplicacion/pantallas/displaytarjetas.dart';
import 'package:hotel_aplicacion/pantallas/habitaciones.dart';
import 'package:hotel_aplicacion/pantallas/pantalla1.dart';
import 'package:hotel_aplicacion/pantallas/perfilview.dart';
import 'package:hotel_aplicacion/pantallas/registrousuario.dart';
import 'package:hotel_aplicacion/pantallas/reportarproblemas.dart';
import 'package:hotel_aplicacion/pantallas/reservaspagadas.dart';
import 'package:hotel_aplicacion/pantallas/reservaspendientes.dart';
import 'package:hotel_aplicacion/pantallas/reservasporpagar.dart';
import 'package:hotel_aplicacion/pantallas/usuarios.dart';
import 'package:hotel_aplicacion/pantallas/verhistorial.dart';
import 'package:mongo_dart/mongo_dart.dart' as M;


class PantallaInicio extends StatefulWidget {
  const PantallaInicio({Key? key}) : super(key: key);

  @override
  _PantallaInicioState createState() => _PantallaInicioState();
}

class _PantallaInicioState extends State<PantallaInicio> {
  int _selectedIndex = 0;
     var codigocontroller = new TextEditingController();
  String generateRandomCode(int length) {
  const String chars = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ';
  Random rnd = Random();
  String code = '';
  for (int i = 0; i < length; i++) {
    code += chars[rnd.nextInt(chars.length)];
  }
  return code;
}

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (_selectedIndex == 1){
        Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => displayNotificaciones()),
      );
      }
      if (_selectedIndex == 0){
      showDialog(
    context: context,
    builder: (BuildContext context) {
      String randomCode = '';
      return AlertDialog(
        title: Text("GENERAR CODIGO"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Cuando una persona quiera crear una cuenta de administrador tendra que ingresar este codigo, de esta manera protegemos tus datos, ya que solo una persona con credenciales de administrador podra generar este codigo"),
            TextField(
              textAlign: TextAlign.center,
              controller: codigocontroller,
              readOnly: true,
              decoration: const InputDecoration(labelText: "Codigo"),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  child: const Text("Generar Codigo"),
                  onPressed: () {
                    randomCode = generateRandomCode(6);
                    codigocontroller.text = randomCode;
                    
                  },
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  child: const Text("Copiar"),
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: randomCode));
                   ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Copiado al Portapapeles')),
                    );                  
                  },
                ),
                
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            child: const Text("Cancelar"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: Text("Hacer este codigo valido"),
            onPressed: () async {
              if(codigocontroller.text.isNotEmpty)
             {
              final data = ModelcodigoAdmin(id: M.ObjectId(),
              codigo: codigocontroller.text, 
              usado: false);
              await MongoDatabase.insertCodigo(data);
              ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('CODIGO VALIDADO')));
              Navigator.of(context).pop();
              }else{
               ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('RELLENAR DATOS')));
              }
            },
          ),
        ],
      );
    },
  );
      }
      
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        title: Text(
          'Bienvenido $publicusername ',
          style: const TextStyle(fontWeight: FontWeight.w900),
          
        ),
        backgroundColor: Colors.blueGrey,
        elevation: 0, 
        shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.only(
      bottomLeft: Radius.circular(30), 
      bottomRight: Radius.circular(30), 
    ),
      ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Menú',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              title: const Text('Cerrar Sesion'),
              leading: const Icon(Icons.exit_to_app_outlined),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const pantalla1()),
                );
              },
            ),
            
             ListTile(
              title: const Text('Perfil'),
              leading: const Icon(Icons.person),
              onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => perfilView()),
                      );
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              
              

              const SizedBox(height: 16),
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const habitaciones()),
                      );
                    },
                    icon: const Icon(Icons.slideshow, color: Colors.black),
                    label: const Text('Ver Habitaciones', style: TextStyle(fontSize: 14, color: Colors.black)),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      backgroundColor: Colors.grey, // Cambia el color de fondo del botón
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const ReservasPorPagar()),
                      );
                    },
                    icon: const Icon(Icons.view_agenda, color: Colors.black),
                    label: const Text('Ver\nReservaciones\nPor Pagar', style: TextStyle(fontSize: 13.5, color: Colors.black)),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      backgroundColor: Colors.green, // Cambia el color de fondo del botón
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const Reservasactivas()),
                      );
                    },
                    icon: const Icon(Icons.view_agenda, color: Colors.black),
                    label: const Text('Ver\nReservaciones\nPendientes', style: TextStyle(fontSize: 13.5, color: Colors.black)),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      backgroundColor: Colors.red, // Cambia el color de fondo del botón
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const VerHistorial()),
                      );
                    },
                    icon: const Icon(Icons.history, color: Colors.black),
                    label: const Text('Ver\nHistorial', style: TextStyle(fontSize: 14, color: Colors.black)),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      backgroundColor: Colors.brown, // Cambia el color de fondo del botón
                    ),
                  ),
            ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const ReservasPagadas()),
                      );
                    },
                    icon: const Icon(Icons.history, color: Colors.black),
                    label: const Text('Ver\nReservas\nPagadas', style: TextStyle(fontSize: 14, color: Colors.black)),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      backgroundColor: Colors.blue, // Cambia el color de fondo del botón
                    ),
                  ),
              ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const usuarios()),
                      );
                    },
                    icon: const Icon(Icons.history, color: Colors.black),
                    label: const Text('Usuarios', style: TextStyle(fontSize: 14, color: Colors.black)),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      backgroundColor: Colors.yellow, // Cambia el color de fondo del botón
                    ),
                  ),
                  
  
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar( 
        backgroundColor: Colors.blueGrey,
        
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.person_add_alt_1),
            label: 'Usuario',
          ),
          
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications_active),
            label: 'Notificaciones',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
    
  }
}
