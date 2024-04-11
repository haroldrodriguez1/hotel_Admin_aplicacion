// ignore_for_file: library_prefixes, unnecessary_new, use_build_context_synchronously

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hotel_aplicacion/dbHelper/MongoModelReportar.dart';
import 'package:hotel_aplicacion/dbHelper/mongodb.dart';
import 'package:hotel_aplicacion/pantallas/pantalla1.dart';
import 'package:mongo_dart/mongo_dart.dart' as M;
class RepoprtarProblema extends StatefulWidget {
  const RepoprtarProblema({super.key});

  @override
  State<RepoprtarProblema> createState() => _RepoprtarProblemaState();
}

class _RepoprtarProblemaState extends State<RepoprtarProblema> {
 

  var problema = new TextEditingController();
  var asunto = new TextEditingController();
 

Future<void> _insertProblema() async {
  
  if(  problema.text.isNotEmpty && asunto.text.isNotEmpty ){
    final data = ReportarProblemaModel(username: publicusername, problema: problema.text, id: M.ObjectId(), asunto: asunto.text);
if (kDebugMode) {
  print(data.asunto);
  print(data.problema);
}

  try {
    await MongoDatabase.insertProblema(data);

    

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Problema Enviado")));

  

    Navigator.of(context).pop();
  } catch (e) {
    if (kDebugMode) {
      print("ERROR AL REGISTRAR USUARIO");
    }
  }
  }else{
    
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Rellenar Campos")));

  }
  
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reportar Problema'),
      ),
      body: SingleChildScrollView( child:
      SafeArea (
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child:
      Column(
        
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
         const Icon(
          Icons.report_problem,
          size: 60,
          ),
            
          TextField(
            textAlign: TextAlign.center,
            controller: asunto,

            decoration: const InputDecoration(labelText: "Asunto"),
            maxLength: 16, 
          ),
           
            
              
               
               Container(width: 16),
               
              const SizedBox(width: 30),
              TextField(
                 textAlign: TextAlign.center,
                controller: problema,
                decoration: const InputDecoration(labelText: "Problema"),
                 style:const TextStyle(fontWeight: FontWeight.w500),
                 maxLength: 200,
                 maxLines: null,
                 keyboardType: TextInputType.multiline,
                 textInputAction: TextInputAction.newline,
                 
                 

              ),
            
          
          const SizedBox(height: 50,),
          
                OutlinedButton(onPressed: () async {
                  
                 _insertProblema();

                  
                }, child: const Text("Enviar Problema"))
        ],
      ),
        ),
      ),
      ),
    );
  }
}