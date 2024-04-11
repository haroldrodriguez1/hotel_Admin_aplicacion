// ignore_for_file: library_private_types_in_public_api, unnecessary_new, use_build_context_synchronously, sized_box_for_whitespace, library_prefixes, use_key_in_widget_constructors, prefer_const_constructors, prefer_typing_uninitialized_variables

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hotel_aplicacion/dbHelper/MongoDBModel.dart';
import 'package:hotel_aplicacion/dbHelper/mongodb.dart';
import 'package:hotel_aplicacion/pantallas/pantalla1.dart';
import 'package:hotel_aplicacion/pantallas/pantallainicio.dart';
import 'package:mongo_dart/mongo_dart.dart' as M;
import 'package:shared_preferences/shared_preferences.dart';
var nameappbar="Registro",namebutton="Insertar";
var objectidact;
var set = 0;
bool onlyread = false;
class RegistrarUsuario extends StatefulWidget {
  @override
  _RegistrarUsuario createState() => _RegistrarUsuario();
}

class _RegistrarUsuario extends State<RegistrarUsuario> {
  String? dropdownValue1;

  var namecontroller = new TextEditingController();
  var apellidoscontroller = new TextEditingController();
  var idcontroller = new TextEditingController();
  var usernamecontroller = new TextEditingController();
  var contraseniacontroller = new TextEditingController();
  var repetircontraseniacontroller = new TextEditingController();
  var respuestacontroller = new TextEditingController();

  bool obscureText = true; // Para ocultar la contraseña

  @override
  Widget build(BuildContext context) {
    if(nameappbar=="ACTUALIZAR"){
      MongoDbModel data = ModalRoute.of(context)!.settings.arguments as MongoDbModel;
      objectidact = data.id;
      if (set ==0)
    
     { namecontroller.text = data.firstName;
       apellidoscontroller.text = data.apellidos;
        idcontroller.text = data.identidad;
         usernamecontroller.text = data.usernamae;
          contraseniacontroller.text = data.contrasenia;
          repetircontraseniacontroller.text = data.contrasenia;
          dropdownValue1 = data.pregunta;
          respuestacontroller.text=data.respuesta;}
        set++;

    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title:  Text(nameappbar),
      ),
      body: Container(
        color: Colors.green[300],
        child: SingleChildScrollView(
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.person_add_alt_outlined,
                    size: 60,
                  ),
                  TextField(
                    textAlign: TextAlign.center,
                    controller: namecontroller,
                    decoration: const InputDecoration(labelText: "NOMBRES"),
                  ),
                  TextField(
                    textAlign: TextAlign.center,
                    controller: apellidoscontroller,
                    decoration: const InputDecoration(labelText: "APELLIDOS"),
                  ),
                  TextField(
                    textAlign: TextAlign.center,
                    controller: idcontroller,
                    decoration: const InputDecoration(labelText: "IDENTIDAD"),
                  ),
                  TextField(
                    textAlign: TextAlign.center,
                    controller: usernamecontroller,
                    readOnly: onlyread,
                    decoration: const InputDecoration(labelText: "NOMBRE DE USUARIO"),
                    onChanged: (text) {
                      usernamecontroller.value = TextEditingValue(
                        text: text.trim(),
                        selection: TextSelection.collapsed(offset: text.trim().length),
                      );
                    },
                  ),
                 Stack(
  alignment: Alignment.centerRight,
  children: [
    TextField(
      
      textAlign: TextAlign.center,
      controller: contraseniacontroller,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: "CONTRASEÑA",
        errorText: contraseniacontroller.text.isNotEmpty && contraseniacontroller.text.length < 5
            ? "La contraseña debe tener al menos 5 caracteres"
            : null,
      ),
      onChanged: (value) {
        contraseniacontroller.value = TextEditingValue(
                        text: value.trim(),
                        selection: TextSelection.collapsed(offset: value.trim().length),
                      );
        if (value.length >= 5 && repetircontraseniacontroller.text.isNotEmpty) {
          if (value != repetircontraseniacontroller.text) {
           /* setState(() {
            });*/
          } else {
            /*setState(() {
            });*/
          }
        }
      },
    ),
    IconButton(
      onPressed: () {
        setState(() {
          obscureText = !obscureText;
        });
      },
      icon: Icon(
        obscureText ? Icons.visibility_off : Icons.visibility,
        color: Colors.grey,
      ),
    ),
  ],
),
Stack(
  alignment: Alignment.centerRight,
  children: [
    TextField(
      textAlign: TextAlign.center,
      controller: repetircontraseniacontroller,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: "REPETIR CONTRASEÑA",
        errorText: contraseniacontroller.text.isNotEmpty && repetircontraseniacontroller.text.isNotEmpty &&
                contraseniacontroller.text != repetircontraseniacontroller.text
            ? "Las contraseñas no coinciden"
            : null,
      ),
      onChanged: (value) {
        repetircontraseniacontroller.value = TextEditingValue(
                        text: value.trim(),
                        selection: TextSelection.collapsed(offset: value.trim().length),
                      );
        if (value.length >= 5 && contraseniacontroller.text.isNotEmpty) {
          if (value != contraseniacontroller.text) {
           /* setState(() {
            });*/
          } else {
           /* setState(() {
            });*/
          }
        }
      },
    ),
    IconButton(
      onPressed: () {
        setState(() {
          obscureText = !obscureText;
        });
      },
      icon: Icon(
        obscureText ? Icons.visibility_off : Icons.visibility,
        color: Colors.grey,
      ),
    ),
  ],
),

                  const SizedBox(height: 15),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.blueAccent, width: 1, strokeAlign: BorderSide.strokeAlignOutside),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Column(
                      children: [
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(height: 50),
                            Text("PREGUNTA DE SEGURIDAD"),
                          ],
                        ),
                        Container(
                          width: 250,
                          child: DropdownButton<String>(
                            value: dropdownValue1,
                            icon: const Icon(Icons.arrow_downward),
                            iconSize: 24,
                            elevation: 16,
                            style: const TextStyle(color: Colors.deepPurple),
                            underline: Container(
                              height: 2,
                              color: Colors.deepPurpleAccent,
                            ),
                            onChanged: (String? newValue) {
                              setState(() {
                                dropdownValue1 = newValue;
                              });
                            },
                            items: <String>[
                              'NOMBRE DE MI MASCOTA',
                              'MI COMIDA FAVORITA',
                              'PELICULA FAVORITA',
                              'COLOR FAVORITO',
                              'CANCION FAVORITA',
                              'NOMBRE DE MI PRIMERA NOVIA'
                            ].map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                        ),
                        Container(width: 16),
                        TextField(
                          textAlign: TextAlign.center,
                          controller: respuestacontroller,
                          decoration: const InputDecoration(labelText: "RESPUESTA:"),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                  const SizedBox(width: 30),
                  const SizedBox(height: 50),
                  OutlinedButton(
                    onPressed: () async {
     if(nameappbar== "Registro") {
      if (namecontroller.text.isNotEmpty && apellidoscontroller.text.isNotEmpty &&
      idcontroller.text.isNotEmpty && usernamecontroller.text.isNotEmpty &&
      contraseniacontroller.text.isNotEmpty && repetircontraseniacontroller.text.isNotEmpty &&
      respuestacontroller.text.isNotEmpty && dropdownValue1!=null
      ) {
      if (contraseniacontroller.text == repetircontraseniacontroller.text) {
      

      bool userExists = await MongoDatabase.registro(usernamecontroller.text);

      if (userExists) {
         if (kDebugMode) {
          print("USUARIO YA EXISTE");
        }
               ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("USUARIO YA EXISTE")));

        
      } else {
        publicusername = usernamecontroller.text;
        if (kDebugMode) {
          print("USUARIO NO EXISTENTE, SE INGRESA");
        }
        
           _insertUser();

      }
      }else{
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("CONTRASEÑAS NO COINCIDEN")));
      }
    }else{
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("RELLENAR CAMPOS")));

    }}//ESTE ES EL PROCESO PARA HACER UPDATES
    else if (nameappbar == "ACTUALIZAR"){

          _updateUser();
        
    }
                    },                  
                    child:  Text(namebutton),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
Future<void> _updateUser() async {
final dataset = MongoDbModel(
    id: objectidact, 
  firstName: namecontroller.text, 
  apellidos: apellidoscontroller.text,
   identidad: idcontroller.text,
    usernamae: usernamecontroller.text,
     contrasenia: contraseniacontroller.text, 
     respuesta: respuestacontroller.text,
      pregunta: dropdownValue1.toString());
    

            if (namecontroller.text.isNotEmpty && apellidoscontroller.text.isNotEmpty &&
      idcontroller.text.isNotEmpty && usernamecontroller.text.isNotEmpty &&
      contraseniacontroller.text.isNotEmpty && repetircontraseniacontroller.text.isNotEmpty &&
      respuestacontroller.text.isNotEmpty && dropdownValue1!=null
      ){
        if (contraseniacontroller.text == repetircontraseniacontroller.text){
          showDialog(
                  context: context,
                  barrierDismissible: false, 
                  builder: (BuildContext context) {
                    return AlertDialog(
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          CircularProgressIndicator(), 
                          SizedBox(height: 20),
                          Text("Cargando..."),
                        ],
                      ),
                    );
                  },
                );
                  await MongoDatabase.updateProfile(dataset);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("SE ACTUALIZO")));
              set = 0;
              publicusername = usernamecontroller.text;
         Navigator.pop(context); 

              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => PantallaInicio()),
              );
        }else{
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("CONTRASEÑAS NO COINCIDEN")));

        }

      }else{
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("RELLENAR CAMPOS")));

      }
}
Future<void> _insertUser() async {
  final data = MongoDbModel(
    id: M.ObjectId(), 
  firstName: namecontroller.text, 
  apellidos: apellidoscontroller.text,
   identidad: idcontroller.text,
    usernamae: usernamecontroller.text,
     contrasenia: contraseniacontroller.text, 
     respuesta: respuestacontroller.text,
      pregunta: dropdownValue1.toString());

  try {
    showDialog(
                  context: context,
                  barrierDismissible: false, 
                  builder: (BuildContext context) {
                    return AlertDialog(
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          CircularProgressIndicator(), 
                          SizedBox(height: 20),
                          Text("Cargando..."),
                        ],
                      ),
                    );
                  },
                );
    await MongoDatabase.insert(data);
    if (kDebugMode) {
      print("Snapshot has data DEL REGISTRO");
    }

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("USUARIO REGISTRADO")));
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('username',namecontroller.text);
  prefs.setString('contra',contraseniacontroller.text);

   // clearAll();
    Navigator.pop(context);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => PantallaInicio()),
    );
  } catch (e) {
    if (kDebugMode) {
      print("ERROR AL REGISTRAR USUARIO");
    }
  }
}


}
