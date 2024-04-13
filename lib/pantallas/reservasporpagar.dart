
// ignore_for_file: avoid_unnecessary_containers, no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';
import 'package:hotel_aplicacion/dbHelper/MongoDbModelReserva.dart';
import 'package:hotel_aplicacion/dbHelper/constant.dart';
import 'package:hotel_aplicacion/dbHelper/mongodb.dart';
import 'package:hotel_aplicacion/pantallas/displaytarjetas.dart';
import 'package:hotel_aplicacion/pantallas/pantallainicio.dart';

class ReservasPorPagar extends StatefulWidget {
  const ReservasPorPagar({super.key});

  @override
  State<ReservasPorPagar> createState() => _ReservasPorPagar();
}
   late List<MongoReservaHabitaciones> _originalData =[];
  final TextEditingController _searchController = TextEditingController();
  List<MongoReservaHabitaciones> _filteredData = [];
class _ReservasPorPagar extends State<ReservasPorPagar> {
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
        title : const Text('Reservas Por Pagar'),
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
          'Aqui Podras ver las reservas\naprobadas por el Hotel\ndisponibles para pago',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
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
                future : MongoDatabase.getDataReservasPorPagar("Por Pagar"),
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
              element.habitacion.contains(_searchController.text) ||
              element.estado.contains(_searchController.text) ||
              element.fechainicio.contains(_searchController.text) ||
              element.fechafinal.contains(_searchController.text) ||
              element.namereservador.contains(_searchController.text) ||
              element.idreservador.contains(_searchController.text) ||
              element.personas.contains(_searchController.text) ||
              element.precio.contains(_searchController.text))
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
            element.habitacion.contains(query) ||
            element.estado.contains(query) ||
            element.fechainicio.contains(query) ||
            element.fechafinal.contains(query) ||
            element.namereservador.contains(query) ||
            element.idreservador.contains(query) ||
            element.personas.contains(query) ||
            element.precio.contains(query))
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
  
 Widget displayCard(MongoReservaHabitaciones data,BuildContext context){

   Future<void> _deleteReserva(var ids,String habitacion,String usuario,String fechainicio,
   String fechafinal, String namereservador, String idreservador,  String personas, String precio,BuildContext context)async {
    final updatedata=MongoReservaHabitaciones(id:ids , habitacion: habitacion,
     usuario: usuario, fechainicio: fechainicio, fechafinal: fechafinal,
      namereservador: namereservador, 
      idreservador: idreservador, 
      estado: 'Pagado', 
      personas: personas,
       precio: precio);
       
       await MongoDatabase.deleteReserva(updatedata);

   } 

    void mostrarAlerta(BuildContext context, int action, String mensaje ) {
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
           Navigator.of(context).pop(); 

              } 
             Navigator.of(context).pop();
              
            },
          ),

        ],
      );
    },
  );
}
  return Card( color: Colors.blue,
    child: Padding(
      padding: const EdgeInsets.all(15.0),
      child: 
          Column( 
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  
              const SizedBox(width: 20,),
              const Text("Eliminar:"),

              IconButton(onPressed: (){
                mostrarAlerta(context, 1, "Eliminar");
                
               
              }, icon: const Icon(Icons.delete_forever),color: Colors.white,iconSize: 40,),
                ],
              ),
              Text("Usuario: ${data.usuario}", style: const TextStyle(fontWeight: FontWeight.bold )),
              const SizedBox(height: 5,),
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
 


