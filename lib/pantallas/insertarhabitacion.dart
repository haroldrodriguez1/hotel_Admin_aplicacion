

// ignore_for_file: unnecessary_import, unused_local_variable, unnecessary_null_comparison, unused_element, camel_case_types, prefer_const_constructors_in_immutables, use_super_parameters, avoid_unnecessary_containers, non_constant_identifier_names, use_build_context_synchronously, use_key_in_widget_constructors, library_private_types_in_public_api

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:hotel_aplicacion/dbHelper/MongoDbModelReserva.dart';
import 'package:hotel_aplicacion/dbHelper/MongoHabitaciones.dart';

import 'package:hotel_aplicacion/dbHelper/mongodb.dart';
import 'package:hotel_aplicacion/pantallas/habitaciones.dart';


import 'package:hotel_aplicacion/pantallas/pantalla1.dart';

import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;



import 'package:mongo_dart/mongo_dart.dart' as m;
int _number=0;
bool checkedValue = false;

// ignore: must_be_immutable
class insertarHabitacion extends StatefulWidget {
  insertarHabitacion({ Key? key}) : super(key: key);
  
  @override
  State<insertarHabitacion> createState() => _insertarHabitacion();
}
class _insertarHabitacion extends State<insertarHabitacion> {
  late m.ObjectId ide;
 
  @override
  Widget build(BuildContext context) {
    MongoHabitaciones data = ModalRoute.of(context)!.settings.arguments as MongoHabitaciones;
    ide = data.id;
      return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: const Text('Habitacion'),
        shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.only(
      bottomLeft: Radius.circular(30), 
      bottomRight: Radius.circular(30), 
    ),
      ),
      ),
      body: Container (
       
    child:  SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          
          child: FutureBuilder(
            future: MongoDatabase.gethabitacion(data.id),
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                if (snapshot.hasData) {
                  var habitacion = MongoHabitaciones.fromJson(snapshot.data);
                  
                  return displayCard(habitacion, context);
                   
                } else {
                  return const Center(child: Text("No hay datos"));
                }
              }
            },
          ),
        ),
      ),
      ),
    );
  }
  Widget displayCard(MongoHabitaciones data, BuildContext context) {
    final ValueNotifier<bool> checkedValueNotifier = ValueNotifier<bool>(false);

  var IDcontroller = TextEditingController();
  var habitacioncontroller = TextEditingController();
  var personascontroller = TextEditingController(text: "1");
  var linkcontroller = TextEditingController();
    var preciocontroller = TextEditingController();

     Future<void> InsertarmiHabitacion() async{
    final data = MongoHabitaciones(id: mongo.ObjectId(),
     habitacion: habitacioncontroller.text,
      capacidad: personascontroller.text,
       disponible: checkedValueNotifier.value,
        linkimagen: linkcontroller.text, 
        precio_por_Persona: preciocontroller.text);
       await MongoDatabase.insertHabitacion(data).whenComplete(() => Navigator.pop(context)
              );
     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("HABITACION INSERTADA")));

  }
  
  initializeDateFormatting('es_ES');
  
  personascontroller.addListener(() {
  if (personascontroller.text.isNotEmpty) {
    int value = int.tryParse(personascontroller.text) ?? 0;
    if (value < 1) {
      personascontroller.text = '1';
    } 
  }
});





  return SingleChildScrollView( 
    child: Card( 
      color: Colors.blue[200],
      child: Padding(
        
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [


            const SizedBox(height: 15,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Personas:"),
        SizedBox(
          height: 50,
          width: 100,
          child: TextFormField(
            textAlign: TextAlign.center,
            
            controller: personascontroller,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
            ),
          ),
        ),
        
      ],
    ),
            TextField(
              controller: habitacioncontroller,
              decoration: const InputDecoration(labelText: "Habitacion Numero: "),
            ),
            TextField(
              controller: preciocontroller,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "Precio por Persona "),
            ),
            TextField(
              controller: linkcontroller,
              keyboardType: TextInputType.url,
              decoration: const InputDecoration(labelText: "Link Imagen"),
            ),
            const SizedBox(height: 15,),
             ValueListenableBuilder<bool>(
                  valueListenable: checkedValueNotifier,
                  builder: (context, isChecked, _) {
                    return CheckboxListTile(
                      title: const Text("¿Disponible?", style: TextStyle(fontSize: 13)),
                      value: isChecked,
                      onChanged: (newValue) {
                        checkedValueNotifier.value = newValue ?? false;
                      },
                      controlAffinity: ListTileControlAffinity.leading,
                    );
                  },
                ),
            const SizedBox(height: 15,),
            
            FloatingActionButton.extended (
              onPressed: () async {
                try {
                  if( habitacioncontroller.text.isNotEmpty){

                  InsertarmiHabitacion();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Rellenar Campos")));
                }
                } catch (e) {
                  if (kDebugMode) {
                    print(e);
                  }
                }
                
              },
              icon: const Icon(Icons.add_box),
              label: const Text("INSERTAR HABITACION"),
              extendedTextStyle: const TextStyle(fontSize: 12),
            ),
          ],
        ),
      ),
    ),
  );
}
}
 