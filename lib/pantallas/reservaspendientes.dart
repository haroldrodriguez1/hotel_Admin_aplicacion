
// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers, no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';
import 'package:hotel_aplicacion/dbHelper/MongoDbModelReserva.dart';
import 'package:hotel_aplicacion/dbHelper/MongoDisplayNotificaciones.dart';
import 'package:hotel_aplicacion/dbHelper/constant.dart';
import 'package:hotel_aplicacion/dbHelper/mongodb.dart';
import 'package:hotel_aplicacion/pantallas/displaytarjetas.dart';
import 'package:hotel_aplicacion/pantallas/pantallainicio.dart';
import 'package:mongo_dart/mongo_dart.dart' as M;

class Reservasactivas extends StatefulWidget {
  const Reservasactivas({super.key});

  @override
  State<Reservasactivas> createState() => _ReservasactivasState();
}

class _ReservasactivasState extends State<Reservasactivas> {
  
  @override
  
  Widget build(BuildContext context) {        
    userCollection = db.collection(USER_COLLECTION3);


    return Scaffold(
      appBar: AppBar (
        title : Text('Reservas Pendientes'),
        centerTitle: true,
        backgroundColor:Colors.blueGrey ,
        shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.only(
      bottomLeft: Radius.circular(30), 
      bottomRight: Radius.circular(30), 
    ),
      ),
      bottom: const PreferredSize(
      preferredSize: Size.fromHeight(80.0), // Altura del espacio debajo del AppBar
      child: Padding(
        padding: EdgeInsets.all(10.0),
        child: Text(
          'Aqui Podras ver las reservas\npendientes de ser aprobadas\npor el Hotel',
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
                future : MongoDatabase.getDataReservas(),
                builder: (context, AsyncSnapshot snapshot) {
                 if (snapshot.connectionState==ConnectionState.waiting){
                  return Center(
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
                    return Center(
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
  
 Widget displayCard(MongoReservaHabitaciones data,BuildContext context){
  String estado ="";
  
   Future<void> _deleteReserva(var ids,String habitacion,String usuario,String fechainicio,
   String fechafinal, String namereservador, String idreservador,  String personas, String precio,BuildContext context)async {
    final updatedata=MongoReservaHabitaciones(id:ids , habitacion: habitacion,
     usuario: usuario, fechainicio: fechainicio, fechafinal: fechafinal,
      namereservador: namereservador, 
      idreservador: idreservador, 
      estado: estado, 
      personas: personas,
       precio: precio);
       
       await MongoDatabase.deleteReserva(updatedata);

   } 

   Future<void> _UpdateReserva(var ids,String habitacion,String usuario,String fechainicio,
   String fechafinal, String namereservador, String idreservador,  String personas, String precio,BuildContext context)async {
    final updatedata=MongoReservaHabitaciones(id:ids , habitacion: habitacion,
     usuario: usuario, fechainicio: fechainicio, fechafinal: fechafinal,
      namereservador: namereservador, 
      idreservador: idreservador, 
      estado: estado, 
      personas: personas,
       precio: precio);
       await MongoDatabase.updateReserva(updatedata,estado);

   } 

  Future<void> sendNotificacion(String notificacion, String usuario) async{
    final data = ModelDisplayNotificaciones(
      notificacion: notificacion,
       username: usuario, 
       id: M.ObjectId());
       await MongoDatabase.insertNotificacion(data);
  }
   void mostrarAlerta(BuildContext context, int action, String mensaje, String usuarioparanotificar) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("Confirmar acción"),
        content: Text("¿Estás seguro de querer $mensaje esta reserva?"),
        actions: [
                  TextButton(
            child: Text("Cancelar"),
            onPressed: () {
              Navigator.of(context).pop(); 
            },
          ),
          TextButton(
            child: Text("Sí, $mensaje"),
            onPressed: () async{
              if(action==1){
                
               await _deleteReserva(data.id, data.habitacion, 
                data.usuario, data.fechainicio, data.fechafinal,
                 data.namereservador, data.idreservador,
                  data.personas, data.precio, context);
           await sendNotificacion("El estado de tu reserva para el ${data.fechainicio} es $mensaje ", data.usuario);

           Navigator.of(context).pop(); 

              } if (action==2){
             await _UpdateReserva(data.id, data.habitacion, 
                data.usuario, data.fechainicio, data.fechafinal,
                 data.namereservador, data.idreservador,
                  data.personas, data.precio, context);
              await sendNotificacion("El estado de tu reserva para el ${data.fechainicio} es $mensaje ", data.usuario);
               Navigator.of(context).pop(); 

              }
             
              setState(() {
                
              });
            },
          ),

        ],
      );
    },
  );
}
  return Card( color: const Color.fromARGB(255, 80, 156, 218),
    child: Padding(
      padding: const EdgeInsets.all(15.0),
      child: 
          Column( 
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("ELIMINAR"),
                  IconButton(onPressed: (){
                    
                    mostrarAlerta(context, 1, "Eliminar",data.usuario);
               
              
              }, icon: const Icon(Icons.delete),
              color: Colors.yellow,
              ),
               const Text("Aprobar"),

              IconButton(onPressed: (){
                    estado="Por Pagar";
                mostrarAlerta(context, 2, "Aprobar",data.usuario);
  
              
              }, icon: const Icon(Icons.check),
              color: Colors.yellow,
              ),
              const Text("DENEGAR"),

              IconButton(onPressed: (){
                 estado="Rechazado";
                  
                 mostrarAlerta(context, 2, "Rechazar",data.usuario);

              
              }, icon: const Icon(Icons.cancel),
              color: Colors.yellow,
              ),
                ],
              ),

              
              TextButton(onPressed: (){
                
              },
               child: Text("Usuario: ${data.usuario}", style: const TextStyle(fontWeight: FontWeight.bold )),
               ),
              SizedBox(height: 5,),
              Text("Habitacion: ${data.habitacion}", style: const TextStyle(fontWeight: FontWeight.bold )),
              SizedBox(height: 5,),
              Text("Estado :${data.estado}", style: const TextStyle(fontWeight: FontWeight.bold )),
               SizedBox(height: 5,),
              Text("Fecha Inicio : ${data.fechainicio}", style: const TextStyle(fontWeight: FontWeight.bold )),
              SizedBox(height: 5,),
             Text("Fecha Final : ${data.fechafinal}", style: const TextStyle(fontWeight: FontWeight.bold )),
            SizedBox(height: 5,),
             Text("A nombre de: ${data.namereservador}", style: const TextStyle(fontWeight: FontWeight.bold )),
            SizedBox(height: 5,),
             Text("ID: ${data.idreservador}", style: const TextStyle(fontWeight: FontWeight.bold )),
             SizedBox(height: 5,),
             Text("Personas: ${data.personas}", style: const TextStyle(fontWeight: FontWeight.bold )),
             SizedBox(height: 5,),
             Text("Precio HNL: ${data.precio}", style: const TextStyle(fontWeight: FontWeight.bold )),
              
          
            ],
          ),
         
        
      ),
    );
    
}
 
}

