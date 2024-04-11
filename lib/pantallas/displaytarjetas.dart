
// ignore_for_file: depend_on_referenced_packages, implementation_imports, unnecessary_import, camel_case_types, avoid_unnecessary_containers, non_constant_identifier_names

import 'package:bson/src/classes/object_id.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hotel_aplicacion/dbHelper/ModelTarjeta.dart';
import 'package:hotel_aplicacion/dbHelper/MongoDbModelReserva.dart';

import 'package:hotel_aplicacion/dbHelper/constant.dart';
import 'package:hotel_aplicacion/dbHelper/mongodb.dart';
import 'package:hotel_aplicacion/pantallas/creditcard.dart';
import 'package:hotel_aplicacion/pantallas/pantallainicio.dart';

class displayTarjetas extends StatefulWidget {
 const displayTarjetas({super.key});
  
  

  
  @override
  State<displayTarjetas> createState() => _displayTarjetas();
}

class _displayTarjetas extends State<displayTarjetas> {
  
  @override
  
  Widget build(BuildContext context) {
      userCollection = db.collection(USER_COLLECTION2);
    return Scaffold(
      appBar: AppBar (
        title : const Text('Tarjetas'),
        backgroundColor:Colors.blueGrey ,
        shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.only(
      bottomLeft: Radius.circular(30), 
      bottomRight: Radius.circular(30), 
    ),
      ),
        actions: [IconButton(onPressed: (){
                Navigator.push(
                     context,
                    MaterialPageRoute(
                    builder: (BuildContext context){
                      return CreditCardsPage();
                    },
                    
                    ));
              }, icon: const Icon(Icons.add_card),
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
                
                future : MongoDatabase.getDataTarjetas(),
                
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
                        
                        if (kDebugMode) {
                          print('Estás en la pantalla: $routeName');
                        }
                        if(routeName == "PantallaInicio"){
                          
                          return displayCardPInicio(
                            ModelTarjeta.fromJson(snapshot.data[index]),context );
                        }else{
                          
                          return displayCardPagar(
                            ModelTarjeta.fromJson(snapshot.data[index]),context );
                        }
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
// ignore: dead_code
   Future<void> _UpdateReserva(var ids,String habitacion,String usuario,String fechainicio,
   String fechafinal, String namereservador, String idreservador,  String personas, String precio,BuildContext context)async {
    final updatedata=MongoReservaHabitaciones(id:ids , habitacion: habitacion,
     usuario: usuario, fechainicio: fechainicio, fechafinal: fechafinal,
      namereservador: namereservador, 
      idreservador: idreservador, 
      estado: 'Por Pagar', 
      personas: personas,
       precio: precio);
       
       await MongoDatabase.updateReserva(updatedata,"Por Pagar").whenComplete(
        
        () => Navigator.push(
                     context,
                    MaterialPageRoute(
                    builder: (BuildContext context){
                      return const PantallaInicio();
                    },
                   
                    )));

   } 
Widget displayCardPInicio(ModelTarjeta data,BuildContext context){
   String lastFourDigits = data.numerotarjeta.substring(data.numerotarjeta.length - 4);
    Future<void> deleteTarjeta(var ids,String propietario,String numerotarjeta,String? fechavenc,
   String? aniovenc, String cvv, String user, BuildContext context)async {
    final updatedata=ModelTarjeta(id: ids, propietario: propietario, numerotarjeta: numerotarjeta, fechavenc: fechavenc, 
    aniovenc: aniovenc, cvc: cvv, user: user);
       
       await MongoDatabase.deleteTarjeta(updatedata).whenComplete(
        
        () => Navigator.push(
                     context,
                    MaterialPageRoute(
                    builder: (BuildContext context){
                      return const PantallaInicio();
                    },
                   
                    )));

   } 
  return Card( color: Colors.blue,
    child: Padding(
      padding: const EdgeInsets.all(15.0),
      child: 
          Column( 
            children: [
               
              
              Text("Titular: ${data.propietario}", style: const TextStyle(fontWeight: FontWeight.bold )),
              const SizedBox(height: 5,),
              Text("**** **** **** $lastFourDigits", style: const TextStyle(fontWeight: FontWeight.bold )),
               const SizedBox(height: 5,),
              
              
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                   const Text("Eliminar: ",style: TextStyle(fontWeight: FontWeight.bold),),
                
              IconButton(onPressed: (){
               deleteTarjeta(data.id, data.propietario, data.numerotarjeta, data.fechavenc,
                data.aniovenc, data.cvc, data.user, context);
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

Widget displayCardPagar(ModelTarjeta data,BuildContext context){
  MongoReservaHabitaciones datas = ModalRoute.of(context)!.settings.arguments as MongoReservaHabitaciones;
   String lastFourDigits = data.numerotarjeta.substring(data.numerotarjeta.length - 4);
    
  return Card( color: Colors.blue,
    child: Padding(
      padding: const EdgeInsets.all(15.0),
      child: 
          Column( 
            children: [
               
              
              Text("Titular: ${data.propietario}", style: const TextStyle(fontWeight: FontWeight.bold )),
              const SizedBox(height: 5,),
              Text("**** **** **** $lastFourDigits", style: const TextStyle(fontWeight: FontWeight.bold )),
               const SizedBox(height: 5,),
              
              
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                   const Text("Pagar",style: TextStyle(fontWeight: FontWeight.bold),),
                IconButton(onPressed: (){
              /* Navigator.push(
                     context,
                    MaterialPageRoute(
                    builder: (BuildContext context){
                      return const PantallaInicio();
                    },
                    settings: RouteSettings(arguments: datas)
                    ));*/
                    ObjectId estado = datas.id;
                    
                    _UpdateReserva(estado,datas.habitacion,datas.usuario,datas.fechainicio
                    ,datas.fechafinal,datas.namereservador,datas.idreservador,datas.personas,datas.precio,context);
                    
                    if (kDebugMode) {
                      print("$estado");
                    }
              }, icon: const Icon(Icons.payment),
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