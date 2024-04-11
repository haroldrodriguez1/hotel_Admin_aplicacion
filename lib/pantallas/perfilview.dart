// ignore_for_file: camel_case_types, avoid_unnecessary_containers

import 'package:flutter/material.dart';
import 'package:hotel_aplicacion/dbHelper/MongoDBModel.dart';
import 'package:hotel_aplicacion/dbHelper/mongodb.dart';
import 'package:hotel_aplicacion/pantallas/registrousuario.dart';

class perfilView extends StatefulWidget {
  const perfilView({super.key});

  @override
  State<perfilView> createState() => _perfilViewState();
}

class _perfilViewState extends State<perfilView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
          appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: const Text('PERFIL'),
        shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.only(
      bottomLeft: Radius.circular(30), 
      bottomRight: Radius.circular(30), 
    ),
      ),
      ),

      body: Container(
          child:  SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          
          child: FutureBuilder(
            future: MongoDatabase.getProfile(),
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                if (snapshot.hasData) {
                  var data = MongoDbModel.fromJson(snapshot.data);
                  
                  return displayCardProfile(data, context);
                   
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

Widget displayCardProfile(MongoDbModel data, BuildContext context) {
  String contraencripted = data.contrasenia.replaceAll(RegExp(r'.'), '*');
    String respuestaencripted = data.respuesta.replaceAll(RegExp(r'.'), '*');

  return SingleChildScrollView( 
    child: Card( 
      color: Colors.blue[200],
      child: Padding(
        
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.person),
                                const SizedBox(width: 15,),

           Text("Nombres : ${data.firstName}", style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 15,),
             Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.person_outline_rounded),
                                const SizedBox(width: 15,),

           Text("Apellidos : ${data.apellidos}", style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
const SizedBox(height: 15,),
             Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.numbers),
                                const SizedBox(width: 15,),

           Text("Identidad : ${data.identidad}", style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
const SizedBox(height: 15,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.verified_user),
                                const SizedBox(width: 15,),

           Text("Usuario : ${data.usernamae}", style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
const SizedBox(height: 15,),
             Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.password),
                const SizedBox(width: 15,),
           Text("Contraseña : $contraencripted", style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
const SizedBox(height: 15,),
             Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.question_mark),
                                const SizedBox(width: 15,),

           Text("Pregunta : ${data.pregunta}", style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
const SizedBox(height: 15,),
              Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.question_answer),
                                const SizedBox(width: 15,),

           Text("Respuesta : $respuestaencripted", style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
    const SizedBox(height: 25,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
  
              children: [
           const Text("Editar:",style: TextStyle(fontWeight: FontWeight.bold),),

                IconButton(onPressed: (){
                  nameappbar = "ACTUALIZAR";
                  namebutton = "ACTUALIZAR";
                  set = 0;
                  onlyread = true;
                   Navigator.push(
                     context,
                    MaterialPageRoute(
                    builder: (BuildContext context){
                      return RegistrarUsuario();
                    },
                    settings: RouteSettings(arguments: data)
                    ));
                }, icon: const Icon(Icons.edit),
                  iconSize: 50,
                  color: Colors.yellow,                
                  highlightColor: Colors.black,)
              ],
            )
          ],)
      )
    )
  );
}