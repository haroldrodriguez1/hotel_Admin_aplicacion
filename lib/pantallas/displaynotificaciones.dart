
// ignore_for_file: unnecessary_import, camel_case_types, avoid_unnecessary_containers

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hotel_aplicacion/dbHelper/MongoDisplayNotificaciones.dart';
import 'package:hotel_aplicacion/dbHelper/mongodb.dart';
class displayNotificaciones extends StatefulWidget {
  const displayNotificaciones({super.key});

  @override
  State<displayNotificaciones> createState() => _displayNotificaciones();
}

class _displayNotificaciones extends State<displayNotificaciones> {
  
  @override
  
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar (
        title : const Text('Notificaciones'),
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
                
                future : MongoDatabase.getDataNotificaciones(),
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
                            ModelDisplayNotificaciones.fromJson(snapshot.data[index]),context );
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

Widget displayCard(ModelDisplayNotificaciones data,BuildContext context){
   
  return Card( color: Colors.blue,
    child: Padding(
      padding: const EdgeInsets.all(15.0),
      child: 
          Column( 
            children: [
               
              
              Text("Notificacion: ${data.notificacion}", style: const TextStyle(fontWeight: FontWeight.bold )),
              
              
            ],
          ),
         
        
      ),
    );
    
}