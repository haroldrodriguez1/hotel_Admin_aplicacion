
// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_local_variable, avoid_web_libraries_in_flutter, unnecessary_new, prefer_interpolation_to_compose_strings, unused_label, library_prefixes, camel_case_types, use_build_context_synchronously, must_be_immutable, prefer_typing_uninitialized_variables, file_names
//import 'dart:js';

import 'package:flutter/material.dart';
import 'package:hotel_aplicacion/dbHelper/mongodb.dart';
import 'package:hotel_aplicacion/pantallas/pantallainicio.dart';
import 'package:shared_preferences/shared_preferences.dart';
bool checkedValue = false;
String publicusername = "name";

class olvideContrasenia extends StatefulWidget {
  const olvideContrasenia({super.key});
  @override
  State<olvideContrasenia> createState() => _olvideContrasenia();
}

class _olvideContrasenia extends State<olvideContrasenia> {
  var respuestacontrollerr = new TextEditingController();
    var contracontroller = new TextEditingController();
bool obscureText = true;
bool showError = false;

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title:  Text("Recuperar Contraseña"),
        
      ),
      body : SingleChildScrollView( child:
      SafeArea (
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
           
          children: [
          Text(
            'Pregunta: $pregunta ?', 
            style: TextStyle(fontSize: 15),
            ),
          
            SizedBox(height: 50,
            ),
            TextField(
              controller: respuestacontrollerr,
              decoration: InputDecoration(labelText: "Respuesta"),
            ),

            SizedBox(height: 10,),
            
                      SizedBox(height: 50,),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //BOTON DE VALIDAR
                OutlinedButton(
  onPressed: () async {
    if (respuestacontrollerr.text.isNotEmpty ) {
      if(respuesta ==respuestacontrollerr.text){
            setState(() {
                              showError = false; // Oculta el mensaje de error
                            });
          
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                content: Column(
                   mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    displayCardrecuperar(context),
                  ],
                ),
              );
            },
          );
        } else {
          setState(() {
                              showError = true; // Oculta el mensaje de error
                            });
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("RESPUESTA NO COINCIDE")));
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("RELLENAR CAMPOS")));
      }
    },
  child: Text("VALIDAR RESPUESTA")
),

      SizedBox(width: 20,),
      
              ],
            ),
          ],
        ),      
       )
      ),)
        
    );
  }



void guardarValorPref() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('contra',contracontroller.text);

}

Widget displayCardrecuperar(BuildContext context){
 bool obscureText = true;
    
  var contraseniacontroller = new TextEditingController();
    var recuperarContraseniacontroller = new TextEditingController();

  return Card( color: Colors.white10,
    child: Padding(
      padding: const EdgeInsets.all(5.0),
      child: 
          Column( 
            children: [
     TextField(
                    textAlign: TextAlign.center,
                    controller: contraseniacontroller,
                    decoration: const InputDecoration(labelText: "Nueva Contraseña:"),
                    onChanged: (text) {
                      contraseniacontroller.value = TextEditingValue(
                        text: text.trim(),
                        selection: TextSelection.collapsed(offset: text.trim().length),
                      );
                    },
                  ),
     TextField(
                    textAlign: TextAlign.center,
                    controller: recuperarContraseniacontroller,
                    decoration: const InputDecoration(labelText: "Repetir Nueva Contraseña:"),
                    onChanged: (text) {
                      recuperarContraseniacontroller.value = TextEditingValue(
                        text: text.trim(),
                        selection: TextSelection.collapsed(offset: text.trim().length),
                      );
                    },
                  ),
          SizedBox(height: 20,),
            OutlinedButton(onPressed: ()async{
            if(contraseniacontroller.text == recuperarContraseniacontroller.text)  {
              showDialog(
                  context: context,
                  barrierDismissible: false, 
                  builder: (BuildContext context) {
                    return AlertDialog(
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircularProgressIndicator(), 
                          SizedBox(height: 20),
                          Text("Cargando..."),
                        ],
                      ),
                    );
                  },
                );
                var datauser = await MongoDatabase.updateContrasenia(contraseniacontroller.text);
                  SharedPreferences prefs = await SharedPreferences.getInstance();
                  prefs.setString('contra',contraseniacontroller.text);
                Navigator.pop(context); 
                  Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => PantallaInicio()),
              );
                }else{
           ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("CONTRASEÑA NO COINCIDE")));
                 
                }
            }, child: Text("Actualizar"),
            
            )
            ],
          ),
         
        
      ),
    );
   
}


}