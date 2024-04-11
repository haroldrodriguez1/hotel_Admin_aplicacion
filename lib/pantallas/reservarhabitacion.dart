

// ignore_for_file: unnecessary_import, unused_local_variable, unnecessary_null_comparison, unused_element, camel_case_types, prefer_const_constructors_in_immutables, use_super_parameters, avoid_unnecessary_containers, non_constant_identifier_names, use_build_context_synchronously, use_key_in_widget_constructors, library_private_types_in_public_api

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:hotel_aplicacion/dbHelper/MongoDbModelReserva.dart';
import 'package:hotel_aplicacion/dbHelper/MongoHabitaciones.dart';

import 'package:hotel_aplicacion/dbHelper/mongodb.dart';


import 'package:hotel_aplicacion/pantallas/pantalla1.dart';

import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;



import 'package:mongo_dart/mongo_dart.dart' as m;
int _number=0;

// ignore: must_be_immutable
class reservhabitaciones extends StatefulWidget {
  reservhabitaciones({ Key? key}) : super(key: key);
  
  @override
  State<reservhabitaciones> createState() => _reservhabitacionesState();
}
class _reservhabitacionesState extends State<reservhabitaciones> {
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
}
  DateTime formattedStartDate = DateTime.now();
  DateTime formattedEndDate = DateTime(formattedStartDate.year, formattedStartDate.month + 3, formattedStartDate.day) ;
Widget displayCard(MongoHabitaciones data, BuildContext context) {
  
  var IDcontroller = TextEditingController();
  var namecontroller = TextEditingController();
  var personascontroller = TextEditingController(text: "1");
  var costocontroller = TextEditingController(text: "HNL 0");
  
  
  initializeDateFormatting('es_ES');
  
  personascontroller.addListener(() {
  if (personascontroller.text.isNotEmpty) {
    int value = int.tryParse(personascontroller.text) ?? 0;
    if (value < 1) {
      personascontroller.text = '1';
    } else if (value > int.parse(data.capacidad)) {
      personascontroller.text = data.capacidad;
    }
  }
});


  DateFormat formatter = DateFormat('yyyy-MM-dd');
  String date = formatter.format(formattedStartDate);

  DateFormat formatter2 = DateFormat('yyyy-MM-dd');
  String date2 = formatter2.format(formattedEndDate);
int calculateDaysDifference(DateTime from, DateTime to) {
  final difference = to.difference(from);
  return difference.inDays;
}
 Future<void> insertReserva(DateTime formattedStartDates, DateTime formattedEndDates) async {
  if (_startDate != null && _endDate != null) {
    int precioTotalPorDia = int.parse(personascontroller.text)*int.parse(data.precio_por_Persona);
    int dias = calculateDaysDifference(formattedStartDates, formattedEndDates);
    int preciototal = precioTotalPorDia*dias;
    String preciofinal = preciototal.toString();
    final datas = MongoReservaHabitaciones(
      habitacion: data.habitacion,
      usuario: publicusername,
      fechainicio: date= formatter.format(formattedStartDates),
      fechafinal: date2= formatter.format(formattedEndDates),
      namereservador: namecontroller.text,
      idreservador: IDcontroller.text,
      estado: 'Pendiente',
       personas: personascontroller.text, 
       precio: preciofinal,
        id: mongo.ObjectId(), 
      
    );

    await MongoDatabase.insertReserva(datas);

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("RESERVA ENVIADA, PENDIENTE")));

    Navigator.of(context).pop();
  } else {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Selecciona un rango de fechas")));
  }
}


  return SingleChildScrollView( // Envuelve tu widget con SingleChildScrollView
    child: Card( 
      color: Colors.blue[200],
      child: Padding(
        
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            Text("Habitacion: ${data.habitacion}", style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 5,),
            Text("Capacidad :${data.capacidad}", style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 5,),
            Text("Disponible : ${data.disponible}", style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 5,),
            Image(image: NetworkImage (data.linkimagen)),
            const SizedBox(height: 15,),
            ElevatedButton(
              onPressed: () {
if (_startDate != null && _endDate != null ) {
    int precioTotalPorDia = int.parse(personascontroller.text)*int.parse(data.precio_por_Persona);
    int dias = calculateDaysDifference(formattedStartDate, formattedEndDate);
    int preciototal = precioTotalPorDia*dias;
    String preciofinal = preciototal.toString();
    

    

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Precio HNL $preciofinal")));

    
  } else {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Datos Insuficientes")));
  }
              },
              child: const Text('Calcular Costo'),
              
            ),
            const SizedBox(height: 15,),

            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => CustomDateRangePickerDialog(
                    firstDate: DateTime.now(),
                    lastDate: DateTime(formattedStartDate.year, formattedStartDate.month + 3, formattedStartDate.day),
                    onSave: (startDate, endDate) {
                      if (startDate != null && endDate != null) {
                        formattedStartDate = startDate;
                        formattedEndDate = endDate;
                      
                      } else {
                        const Text('No se seleccionaron fechas');
                      }
                    },
                  ),
                );
              },
              child: const Text('Seleccionar Rango de Fechas'),
            ),
            const SizedBox(height: 15,),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blueAccent, width: 2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text('Fecha de inicio: ${formattedStartDate != null ? DateFormat('yyyy-MM-dd').format(formattedStartDate) : ''}\nFecha de fin: ${formattedEndDate != null ? DateFormat('yyyy-MM-dd').format(formattedEndDate) : ''}'),
            ),

            
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
              controller: namecontroller,
              decoration: const InputDecoration(labelText: "Reserva a nombre de:"),
            ),
            const SizedBox(height: 15,),
            TextField(
              controller: IDcontroller,
              decoration: const InputDecoration(labelText: "Identidad del Responsable:"),
            ),
            const SizedBox(height: 15,),
            
            FloatingActionButton.extended (
              onPressed: () async {
                try {
                  if(IDcontroller.text.isNotEmpty && namecontroller.text.isNotEmpty){
                  
                  insertReserva(formattedStartDate, formattedEndDate);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Rellenar Campos")));
                }
                } catch (e) {
                  if (kDebugMode) {
                    print(e);
                  }
                }
                
              },
              icon: const Icon(Icons.send),
              label: const Text("ENVIAR SOLICITUD DE RESERVA"),
              extendedTextStyle: const TextStyle(fontSize: 12),
            ),
          ],
        ),
      ),
    ),
  );
}



 

DateTime? _startDate;
  DateTime? _endDate;
class CustomDateRangePickerDialog extends StatefulWidget {
  final DateTime firstDate;
  final DateTime lastDate;
  final Function(DateTime?, DateTime?) onSave;

  const CustomDateRangePickerDialog({
    required this.firstDate,
    required this.lastDate,
    required this.onSave,
  });

  @override
  _CustomDateRangePickerDialogState createState() => _CustomDateRangePickerDialogState();
}

class _CustomDateRangePickerDialogState extends State<CustomDateRangePickerDialog> {
  

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Seleccionar Rango de Fechas'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // DateRangePicker
          ListTile(
            title: const Text('Desde'),
            subtitle: _startDate != null ? Text(_formatDate(_startDate!)) : const Text('Seleccionar fecha'),
            onTap: () async {
              final selectedDate = await showDatePicker(
                context: context,
                initialDate: _startDate ?? widget.firstDate,
                firstDate: widget.firstDate,
                lastDate: widget.lastDate,
              );
              if (selectedDate != null) {
                setState(() {
                  _startDate = selectedDate;
                });
              }
            },
          ),
          ListTile(
            title: const Text('Hasta'),
            subtitle: _endDate != null ? Text(_formatDate(_endDate!)) : const Text('Seleccionar fecha'),
            onTap: () async {
              final selectedDate = await showDatePicker(
                context: context,
                initialDate: _endDate ?? widget.lastDate,
                firstDate: _startDate ?? widget.firstDate,
                lastDate: widget.lastDate,
              );
              if (selectedDate != null) {
                setState(() {
                  _endDate = selectedDate;
                });
              }
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: () {
            // Llamar a la función onSave y pasar las fechas sin la hora
            widget.onSave(_startDate, _endDate);
            setState(() {});
            Navigator.of(context).pop();
          },
          child: const Text('Guardar'),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}

