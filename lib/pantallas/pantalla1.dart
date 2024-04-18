
// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_local_variable, avoid_web_libraries_in_flutter, unnecessary_new, prefer_interpolation_to_compose_strings, unused_label, library_prefixes, camel_case_types, use_build_context_synchronously, must_be_immutable, prefer_typing_uninitialized_variables, unnecessary_import
//import 'dart:js';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hotel_aplicacion/dbHelper/ModelCodigoAdmin.dart';
import 'package:hotel_aplicacion/dbHelper/mongodb.dart';
import 'package:hotel_aplicacion/pantallas/olvidecontrase%C3%B1a.dart';
import 'package:hotel_aplicacion/pantallas/pantallainicio.dart';
import 'package:hotel_aplicacion/pantallas/registrousuario.dart';
import 'package:shared_preferences/shared_preferences.dart';
bool checkedValue = false;
String publicusername = "name";
String? codigo;
class pantalla1 extends StatefulWidget {
  const pantalla1({super.key});
  @override
  State<pantalla1> createState() => _pantalla1State();
}

class _pantalla1State extends State<pantalla1> {
  var fnamecontroller = new TextEditingController();
    var contracontroller = new TextEditingController();
bool obscureText = true;
bool showError = false;

  @override
  Widget build(BuildContext context) {
    fill();
    return  Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title:  Text("HOTEL CLEMENTINA",style: TextStyle(fontFamily:"Lato" ),),
        
        
      ),
      body : Stack(
        children: [
          Image.asset(
          'assets/images/8083666.jpg',
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        ),
          SingleChildScrollView( child:
          SafeArea (
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
               
              children: [
                
              Text(
                "Inserte Datos", 
                style: TextStyle(fontSize: 22,fontFamily:"CourrierPrime"),
                ),
              
                SizedBox(height: 50,
                ),
                Container(
                  decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(10),
                ),
                  child: TextField(
                    textAlign: TextAlign.center,
                    controller: fnamecontroller,
                    decoration: InputDecoration(labelText: "Nombre de Usuario"),
                  ),
                ),
            SizedBox(height: 20,),
             Stack(
            alignment: Alignment.centerRight,  
            children: [  
             Container(
              decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(10),
                ),
               child: TextField(
                  textAlign: TextAlign.center,
                  controller: contracontroller,
                  obscureText: obscureText,
                  decoration: InputDecoration(
                    labelText: "Contraseña",
                    errorText: showError ? "Contraseña o usuario incorrectos" : null,
                  ),
                  
                  
                ),
             ),IconButton(
          onPressed: () {
            setState(() {
              obscureText = !obscureText;
            });
          },
          icon: Icon(
            obscureText ? Icons.visibility_off : Icons.visibility,
            color: Colors.black,
          ),
              ),],),
                SizedBox(height: 10,),
                
                            Container(
                              decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(10),
                            ),
                              child: TextButton(
                              onPressed: () async {
                                if (fnamecontroller.text.isNotEmpty) {
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
                            var datauser = await MongoDatabase.recuperarContrasenia(fnamecontroller.text);
                            Navigator.pop(context); 
                            if (datauser == true) {
                              publicusername = fnamecontroller.text;
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => olvideContrasenia()),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("USUARIO NO EXISTE")));
              
                  
                            }
                          }else{
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Ingresar Usuario")));
                  
                          }
                        },
                        child: Text("Olvidé mi Contraseña"),
                      ),
      ),
          
                 SizedBox(height: 10,),
                Container(
                  decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(10),
                ),
                  child: CheckboxListTile(
                                title: Text("¿Guardar Datos de Inicio de Sesion?",style: TextStyle(fontSize:13 ),),
                                value: checkedValue,
                                onChanged: (newValue) {
                                setState(() {
                                 checkedValue = newValue!;
                                } );
                                },
                                controlAffinity: ListTileControlAffinity.leading, 
                                ),
                ),
                          SizedBox(height: 50,),
          
                Container(
                  width: 280,
                  height: 40,
                  decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      //BOTON DE INGRESAR
                      OutlinedButton(
                              onPressed: () async {
                                if (fnamecontroller.text.isNotEmpty && contracontroller.text.isNotEmpty) {
                            if (kDebugMode) {
                              print("BOTON PRESIONADO INICIAR SESION");
                            }
                            showDialog(
                        context: context,
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
                            bool userExists = await MongoDatabase.getuser(fnamecontroller.text, contracontroller.text);
                            
                            if (userExists) {
                              if (kDebugMode) {
                                print("ESTE USUARIO EXISTE");
                              }
                              publicusername = fnamecontroller.text;
                                if (checkedValue){
                  guardarValorPref();
                                }
                                Navigator.pop(context);
                  //  clearAll();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => PantallaInicio()),
                    );
                            } else {
                                Navigator.pop(context);
                            
                              if (kDebugMode) {
                                print("CONTRASEÑA O USUARIO ERRONEO");
                              }
                              setState(() {
                     showError = true;
                      
                                } );
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("CONTRASEÑA O USUARIO ERRONEO")));
                            }
                                }
                              },
                              child: Text("Iniciar Sesion")
                            ),
                            
                            SizedBox(width: 20,),
                            OutlinedButton(
                              onPressed: () async {
                                nameappbar="Registro";
                                namebutton="Insertar";
                                var codigocontroller = new TextEditingController();
                            
                                set = 0;
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                            String randomCode = '';
                            return AlertDialog(
                              title: Text("CODIGO"),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                  Text("Un administrador deberia proporcionar el codigo para crear cuenta de administrador"),
                  TextField(
                    textAlign: TextAlign.center,
                    controller: codigocontroller,
                    decoration: const InputDecoration(labelText: "Codigo"),
                  ),
                  
                                ],
                              ),
                              actions: [
                                TextButton(
                  child: const Text("Cancelar"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                                ),
                                TextButton(
                  child: Text("Verificar"),
                  onPressed: () async {
                            
                    if(codigocontroller.text.isNotEmpty)
                   {
                    Future<bool> codigoexists = MongoDatabase.getcodigo(codigocontroller.text);
                    if (await codigoexists){
                      codigo = codigocontroller.text;
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => RegistrarUsuario()),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('CODIGO VALIDADO')));
                            
                    }else{
                       ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('CODIGO NO DISPONIBLE')));
                    }
                    
                    }else{
                     ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('RELLENAR DATOS')));
                    }
                   // Navigator.of(context).pop();
                            
                  },
                                ),
                              ],
                            );
                                },
                              );
                              /*  Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => RegistrarUsuario()),
                                );*/
                              },
                              child: Text("Registrarse")
                            ),
                    ],
                  ),
                ),
              ],
            ),      
           )
          ),),
        ],
      )
        
    );
  }



void guardarValorPref() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('username',fnamecontroller.text);
  prefs.setString('contra',contracontroller.text);

}


void clearAll(){
  fnamecontroller.text = "";
  contracontroller.text ="";
}

void fill() async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
String? name = prefs.getString('username');
String? contra = prefs.getString('contra');
if (name != null && contra != null)
  {fnamecontroller.text = name;
  contracontroller.text = contra;}
}
}