
// ignore_for_file: unnecessary_import, camel_case_types, avoid_unnecessary_containers

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hotel_aplicacion/dbHelper/MongoHabitaciones.dart';
import 'package:hotel_aplicacion/dbHelper/constant.dart';
import 'package:hotel_aplicacion/dbHelper/mongodb.dart';
import 'package:hotel_aplicacion/pantallas/insertarhabitacion.dart';
import 'package:hotel_aplicacion/pantallas/reservarhabitacion.dart';
class habitaciones extends StatefulWidget {
  const habitaciones({super.key});

  @override
  State<habitaciones> createState() => _habitacionesState();
}

class _habitacionesState extends State<habitaciones> {
  
  @override
  
  Widget build(BuildContext context) {
      userCollection = db.collection(USER_COLLECTION2);
    return Scaffold(
      appBar: AppBar (
        title : const Text('Habitaciones'),
        backgroundColor:Colors.blueGrey ,
        shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.only(
      bottomLeft: Radius.circular(30), 
      bottomRight: Radius.circular(30), 
    ),
      ),
      ),
      body : Container(
        
      child:SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: FutureBuilder(
                
                future : MongoDatabase.getData(),
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
                            MongoHabitaciones.fromJson(snapshot.data[index]),context );
                      }
                      ); 
                  }else{
                    return const Center(child: Text("No hay datos"),);
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

Widget displayCard(MongoHabitaciones data,BuildContext context){
   
  return Card( color: Colors.blue,
    child: Padding(
      padding: const EdgeInsets.all(15.0),
      child: 
          Column( 
            children: [
               
              
              Text("Habitacion: ${data.habitacion}", style: const TextStyle(fontWeight: FontWeight.bold )),
              const SizedBox(height: 5,),
              Text("Capacidad :${data.capacidad}", style: const TextStyle(fontWeight: FontWeight.bold )),
               const SizedBox(height: 5,),
              Text("Disponible : ${data.disponible}", style: const TextStyle(fontWeight: FontWeight.bold )),
              const SizedBox(height: 5,),
              Text("Precio Por Persona HNL: ${data.precio_por_Persona}", style: const TextStyle(fontWeight: FontWeight.bold )),
              const SizedBox(height: 5,),
              Image(image: NetworkImage (data.linkimagen)) ,
              const SizedBox(height: 5,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                   const Text("Editar: ",style: TextStyle(fontWeight: FontWeight.bold),),
              IconButton(onPressed: (){
                Navigator.push(
                     context,
                    MaterialPageRoute(
                    builder: (BuildContext context){
                      return insertarHabitacion();
                    },
                    settings: RouteSettings(arguments: data)
                    ));
              }, icon: const Icon(Icons.edit),
                  iconSize: 50,
                  color: Colors.yellow,                
                  highlightColor: Colors.black,
                  
              ),
              const Text("Eliminar",style: TextStyle(fontWeight: FontWeight.bold),),
              IconButton(onPressed: (){
                Navigator.push(
                     context,
                    MaterialPageRoute(
                    builder: (BuildContext context){
                      return reservhabitaciones();
                    },
                    settings: RouteSettings(arguments: data)
                    ));
              }, icon: const Icon(Icons.delete),
                  iconSize: 50,
                  color: Colors.yellow,                
                  highlightColor: Colors.black,
                  
              ),
                ],),
            ],
          ),
         
        
      ),
    );
    
}