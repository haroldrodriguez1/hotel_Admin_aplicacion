// ignore_for_file: use_super_parameters, library_private_types_in_public_api, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:hotel_aplicacion/pantallas/displaynotificaciones.dart';
import 'package:hotel_aplicacion/pantallas/displaytarjetas.dart';
import 'package:hotel_aplicacion/pantallas/habitaciones.dart';
import 'package:hotel_aplicacion/pantallas/pantalla1.dart';
import 'package:hotel_aplicacion/pantallas/perfilview.dart';
import 'package:hotel_aplicacion/pantallas/reportarproblemas.dart';
import 'package:hotel_aplicacion/pantallas/reservaspagadas.dart';
import 'package:hotel_aplicacion/pantallas/reservaspendientes.dart';
import 'package:hotel_aplicacion/pantallas/reservasporpagar.dart';
import 'package:hotel_aplicacion/pantallas/verhistorial.dart';

class PantallaInicio extends StatefulWidget {
  const PantallaInicio({Key? key}) : super(key: key);

  @override
  _PantallaInicioState createState() => _PantallaInicioState();
}

class _PantallaInicioState extends State<PantallaInicio> {
  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (_selectedIndex == 0){
        Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ReservasPagadas()),
      );
      }
      if (_selectedIndex == 1){
        Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => RepoprtarProblema()),
      );
      }
      if (_selectedIndex == 2){
        Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => displayNotificaciones()),
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
              title: const Text('Tarjetas'),
              leading: const Icon(Icons.credit_card),
              onTap: () {
                 routeName ="PantallaInicio";
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => displayTarjetas()),
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
              const Text(
                'Estamos alegres de tenerte por aqui',
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              ClipRRect(
                borderRadius: BorderRadius.circular(20), // Define el radio de la esquina para redondear la imagen
                child: const Image(
                  image: NetworkImage('https://www.emprenomic.com/wp-content/uploads/2016/05/hotel.jpg'),
                ),
              ),

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
                    icon: const Icon(Icons.search, color: Colors.black),
                    label: const Text('Buscar Habitaciones', style: TextStyle(fontSize: 14, color: Colors.black)),
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
                  
                  const Column(
                    children: [
                      SizedBox(height: 20),
                      Text(
                        "Nuestras\nUbicaciones:",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.location_city, color: Colors.black),
                          SizedBox(width: 8),
                          Text(
                            "Danli, El Paraiso",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.location_city, color: Colors.black),
                          SizedBox(width: 8),
                          Text(
                            "El Paraiso,El Paraiso",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const Column(
                    children: [
                      SizedBox(height: 20),
                      Text(
                        "Comunícate con Nosotros:",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.phone_android, color: Colors.black),
                          SizedBox(width: 8),
                          Text(
                            "Cel: 98787777",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.phone, color: Colors.black),
                          SizedBox(width: 8),
                          Text(
                            "Tel: 22078787",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ],
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
            icon: Icon(Icons.home),
            label: 'Habitaciones',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.report_problem),
            label: 'Reportar',
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
