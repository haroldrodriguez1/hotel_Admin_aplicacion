
// ignore_for_file: avoid_unnecessary_containers, no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';
import 'package:hotel_aplicacion/dbHelper/MongoDBModel.dart';
import 'package:hotel_aplicacion/dbHelper/MongoDbModelReserva.dart';
import 'package:hotel_aplicacion/dbHelper/MongoDisplayNotificaciones.dart';
import 'package:hotel_aplicacion/dbHelper/constant.dart';
import 'package:hotel_aplicacion/dbHelper/mongodb.dart';
import 'package:hotel_aplicacion/pantallas/displaytarjetas.dart';
import 'package:hotel_aplicacion/pantallas/pantallainicio.dart';
import 'package:mongo_dart/mongo_dart.dart' as M;


class usuarios extends StatefulWidget {
  const usuarios({super.key});

  @override
  State<usuarios> createState() => _usuarios();
}
   late List<MongoDbModel> _originalData =[];
  final TextEditingController _searchController = TextEditingController();
  List<MongoDbModel> _filteredData = [];
class _usuarios extends State<usuarios> {
 @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      _filterData();
    });
  }
  @override
  Widget build(BuildContext context) {        
    userCollection = db.collection(USER_COLLECTION3);
    

    return Scaffold(
      appBar: AppBar (
        title : const Text('Usuarios'),
        centerTitle: true,
        backgroundColor:Colors.blueGrey ,
        shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.only(
      bottomLeft: Radius.circular(30), 
      bottomRight: Radius.circular(30), 
    ),
      ),
     
    actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(context: context, delegate: _SearchDelegate());
            },
          ),
        ],
      ),
      
      body : Container(
        
      child:SafeArea(
            child: Padding(
              
              padding: const EdgeInsets.all(10.0),
              child: FutureBuilder(
                future : MongoDatabase.getusuarios(),
                builder: (context, AsyncSnapshot snapshot) {
                 if (snapshot.connectionState==ConnectionState.waiting){
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                 }else{
                  if(snapshot.hasData){
                    var totalData = snapshot.data.length;
                    _originalData = snapshot.data;                
                    _filteredData = snapshot.data;                   
                    return ListView.builder(
                      itemCount: totalData,
                      itemBuilder: (context,index){
                        
                         return displayCard(_filteredData[index], context);
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
       void _filterData() {
    setState(() {
      _filteredData = _filteredData
          .where((element) =>
              element.firstName.contains(_searchController.text) ||
              element.apellidos.contains(_searchController.text) ||
              element.identidad.contains(_searchController.text) ||
              element.usernamae.contains(_searchController.text) ||
              element.contrasenia.contains(_searchController.text) 
            
              )
          .toList();
    });
  }

}
class _SearchDelegate extends SearchDelegate {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container();
  }

 @override
Widget buildSuggestions(BuildContext context) {
  if (query.isEmpty) {
    _filteredData = _originalData;
    return ListView.builder(
      itemCount: _filteredData.length,
      itemBuilder: (context, index) {
        return displayCard(_filteredData[index], context);
      },
    );
  } else {
    _filteredData = _originalData
        .where((element) =>
            element.firstName.contains(query) ||
            element.apellidos.contains(query) ||
            element.identidad.contains(query) ||
            element.usernamae.contains(query) ||
            element.contrasenia.contains(query) 
          
           
            )
        .toList();
    return ListView.builder(
      itemCount: _filteredData.length,
      itemBuilder: (context, index) {
        return displayCard(_filteredData[index], context);
      },
    );
  }
}
}
  
 Widget displayCard(MongoDbModel data,BuildContext context){
     var useraenviar = data.usernamae;

   var notificacioncontroller = new TextEditingController();


  
  return Card( color: Colors.blue,
    child: Padding(
      padding: const EdgeInsets.all(15.0),
      child: 
          Column( 
            children: [
              
              Text("Nombre: ${data.firstName}", style: const TextStyle(fontWeight: FontWeight.bold )),
              const SizedBox(height: 5,),
              Text("Apellido: ${data.apellidos}", style: const TextStyle(fontWeight: FontWeight.bold )),
              const SizedBox(height: 5,),
              Text("Identidad :${data.identidad}", style: const TextStyle(fontWeight: FontWeight.bold )),
               const SizedBox(height: 5,),
              Text("Usuario : ${data.usernamae}", style: const TextStyle(fontWeight: FontWeight.bold )),
              const SizedBox(height: 5,),
             Text("Contraseña : ${data.contrasenia}", style: const TextStyle(fontWeight: FontWeight.bold )),
            const SizedBox(height: 5,),
          Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  
              const SizedBox(width: 20,),
              const Text("Enviar Notificacion:"),

              IconButton(onPressed: (){
                 showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("Enviar Notificacion"),
        content: TextField(
                    textAlign: TextAlign.center,
                    controller: notificacioncontroller,
                    decoration: const InputDecoration(labelText: "Escriba Aqui:"),
                  ),
        actions: [
                  TextButton(
            child: const Text("Cancelar"),
            onPressed: () {
              Navigator.of(context).pop(); 
            },
          ),
          TextButton(
            child: Text("ENVIAR"),
            onPressed: () async{
              final data = ModelDisplayNotificaciones(
      notificacion: notificacioncontroller.text,
       username: useraenviar, 
       id: M.ObjectId());
       await MongoDatabase.insertNotificacion(data);
             Navigator.of(context).pop();
              
            },
          ),

        ],
      );
    },
  );
                
               
              }, icon: const Icon(Icons.send),color: Colors.white,iconSize: 40,),
                ],
              ),
             
              
          
            ],
          ),
         
        
      ),
    );
    
}
 


