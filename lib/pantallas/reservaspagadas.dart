
// ignore_for_file: avoid_unnecessary_containers

import 'package:flutter/material.dart';
import 'package:hotel_aplicacion/dbHelper/MongoDbModelReserva.dart';
import 'package:hotel_aplicacion/dbHelper/constant.dart';
import 'package:hotel_aplicacion/dbHelper/mongodb.dart';

class ReservasPagadas extends StatefulWidget {
  const ReservasPagadas({super.key});

  @override
  State<ReservasPagadas> createState() => _ReservasPagadas();
}
   late List<MongoReservaHabitaciones> _originalData =[];
  final TextEditingController _searchController = TextEditingController();
  List<MongoReservaHabitaciones> _filteredData = [];
class _ReservasPagadas extends State<ReservasPagadas> {


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
      appBar: AppBar(
        title: const Text('Reservas Pagadas'),
        backgroundColor: Colors.blueGrey,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(30),
            bottomRight: Radius.circular(30),
          ),
        ),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(70.0),
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Text(
              'Aqui Podras ver las reservas\npagadas que pronto\npodras disfrutar',
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
      body: Container(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: FutureBuilder(
              future: MongoDatabase.getDataReservasPagadass(),
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  if (snapshot.hasData) {
                    var totalData = snapshot.data.length;
                    _originalData = snapshot.data;                
                    _filteredData = snapshot.data;
                    return ListView.builder(
                      itemCount: totalData,
                      itemBuilder: (context, index) {
                        return displayCard(_filteredData[index], context);
                      },
                    );
                  } else {
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