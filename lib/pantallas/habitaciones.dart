
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
      actions: [
        IconButton(onPressed: (){
              namebotonhabitacion="Insertar";
              estadoboton = 0;
                Navigator.push(
                     context,
                    MaterialPageRoute(
                    builder: (BuildContext context){
                      return insertarHabitacion();
                    },
                    
                    ));
              }, icon: const Icon(Icons.add_box),
                  iconSize: 40,
                  color: Colors.yellow,                
                  highlightColor: Colors.black,
                  
              ),
              IconButton(onPressed: (){
              setState(() {
                
              });
              }, icon: const Icon(Icons.refresh),
                  iconSize: 40,
                  color: Colors.yellow,                
                  highlightColor: Colors.black,
                  
              ),
              
              
              ],
              
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
  Widget displayCard(MongoHabitaciones data,BuildContext context){
    Future<void> _deleteHabitacion()async {
    final updatedata=MongoHabitaciones(id: data.id, 
    habitacion: data.habitacion,
     capacidad: data.capacidad, 
     disponible: data.disponible, 
     linkimagen: data.linkimagen, 
     precio_por_Persona: data.precio_por_Persona);
       
       await MongoDatabase.deleteHabitacion(updatedata);

   } 
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
                estadoboton = 1;
                namebotonhabitacion = "Actualizar";
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
                showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text("Confirmar acción"),
        content: const Text("¿Estás seguro de querer eliminar esta habitacion?"),
        actions: [
                  TextButton(
            child: const Text("Cancelar"),
            onPressed: () {
              Navigator.of(context).pop(); 
            },
          ),
          TextButton(
            child: const Text("Sí, eliminar"),
            onPressed: () async{
             
                
               await _deleteHabitacion();

           Navigator.of(context).pop(); 
          setState(() {
            
          });
              
             
              
            },
          ),

        ],
      );
    },
  );
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
}

