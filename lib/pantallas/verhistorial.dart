// ignore_for_file: avoid_unnecessary_containers

import 'package:flutter/material.dart';
import 'package:hotel_aplicacion/dbHelper/MongoDbModelReserva.dart';
import 'package:hotel_aplicacion/dbHelper/constant.dart';
import 'package:hotel_aplicacion/dbHelper/mongodb.dart';

class VerHistorial extends StatefulWidget {
  const VerHistorial({super.key});

  @override
  State<VerHistorial> createState() => _VerHistorialState();
}

class _VerHistorialState extends State<VerHistorial> {

  @override
  Widget build(BuildContext context) {        
    userCollection = db.collection(USER_COLLECTION3);


    return Scaffold(
      appBar: AppBar (
        title : const Text('Historial'),
        backgroundColor:Colors.blueGrey ,
        centerTitle: true,
        shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.only(
      bottomLeft: Radius.circular(30), 
      bottomRight: Radius.circular(30), 
    ),
      ),
      bottom: const PreferredSize(
      preferredSize: Size.fromHeight(50.0), // Altura del espacio debajo del AppBar
      child: Padding(
        padding: EdgeInsets.all(10.0),
        child: Text(
          'Aqui Podras ver las reservas\nen tu historial',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    ),
      ),
      
      body : Container(
      
      child:SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: FutureBuilder(
                future : MongoDatabase.getDataHistorial(),
                builder: (context, AsyncSnapshot snapshot) {
                 if (snapshot.connectionState==ConnectionState.waiting){
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                 }else{
                  if(snapshot.hasData){
                    var totalData = snapshot.data.length;
                    
                    return ListView.builder(
                      itemCount: totalData,
                      itemBuilder: (context,index){
                        
                          return displayCard(
                            MongoReservaHabitaciones.fromJson(snapshot.data[index]),context );
                      }
                      ); 
                  }else{
                    return const Center(
                      child: Text("No hay datos"),
                    );
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

Widget displayCard(MongoReservaHabitaciones data,BuildContext context){
   
  return Card( color: Colors.blue,
    child: Padding(
      padding: const EdgeInsets.all(15.0),
      child: 
          Column( 
            children: [
              
              
              Text("Habitacion: ${data.habitacion}", style: const TextStyle(fontWeight: FontWeight.bold )),
              const SizedBox(height: 5,),
              Text("Estado :${data.estado}", style: const TextStyle(fontWeight: FontWeight.bold )),
               const SizedBox(height: 5,),
              Text("Fecha Inicio : ${data.fechainicio}", style: const TextStyle(fontWeight: FontWeight.bold )),
              const SizedBox(height: 5,),
             Text("Fecha Final : ${data.fechafinal}", style: const TextStyle(fontWeight: FontWeight.bold )),
            const SizedBox(height: 5,),
             Text("A nombre de: ${data.namereservador}", style: const TextStyle(fontWeight: FontWeight.bold )),
            const SizedBox(height: 5,),
             Text("ID: ${data.idreservador}", style: const TextStyle(fontWeight: FontWeight.bold )),
             const SizedBox(height: 5,),
             Text("Personas: ${data.personas}", style: const TextStyle(fontWeight: FontWeight.bold )),
             const SizedBox(height: 5,),
             Text("Precio HNL: ${data.precio}", style: const TextStyle(fontWeight: FontWeight.bold )),
              
          
            ],
          ),
         
        
      ),
    );
    
}