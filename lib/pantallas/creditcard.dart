
// ignore_for_file: library_private_types_in_public_api, unnecessary_new, use_build_context_synchronously, sized_box_for_whitespace, library_prefixes, use_key_in_widget_constructors

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hotel_aplicacion/dbHelper/ModelTarjeta.dart';
import 'package:hotel_aplicacion/dbHelper/mongodb.dart';
import 'package:hotel_aplicacion/pantallas/pantalla1.dart';
import 'package:mongo_dart/mongo_dart.dart' as M;
class CreditCardsPage extends StatefulWidget {
  @override
  _CreditCardsPageState createState() => _CreditCardsPageState();
}

class _CreditCardsPageState extends State<CreditCardsPage> {
  String? dropdownValue1;
  String? dropdownValue2;
 

  var numerocontroller = new TextEditingController();
  var cvvcontroller = new TextEditingController();
  var titularcontroller = new TextEditingController();

Future<void> _insertCard() async {
  int tarjetalength = numerocontroller.text.length;
  int cvvlenght = cvvcontroller.text.length;
  if(tarjetalength == 16  &&
  cvvlenght == 3 && titularcontroller.text.isNotEmpty &&
  dropdownValue1 != null && dropdownValue2 != null){
    final data = ModelTarjeta(propietario: titularcontroller.text,
   numerotarjeta: numerocontroller.text,
    fechavenc: dropdownValue1,
     aniovenc: dropdownValue2, 
     cvc: cvvcontroller.text,
      user: publicusername, 
      id: M.ObjectId());

  try {
    await MongoDatabase.insertCard(data);

    if (kDebugMode) {
      print("Snapshot has data DEL REGISTRO");
    }

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("TARJETA GUARDADA")));

  

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
        title: const Text('AGREGAR TARJETA'),
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
          Icons.credit_card,
          size: 60,
          ),
            
          TextField(
            textAlign: TextAlign.center,
            controller: numerocontroller,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: "Ingresar 16 dígitos de la tarjeta"),
            maxLength: 16,
            
            
            
          ),
           const Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: 50, width: 85,),
                Text("MES"),
              ],
              ),
            
              Container (
                width: 80,
                
             child : DropdownButton<String>(
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
                items: <String>['01', '02', '03', '04', '05', '06', '07', '08', '09', '10', '11', '12']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
                
              ),
               const Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: 15, width: 85,),
                Text("AÑO"),
              ],
              ),
               Container(width: 16),
               Container(
                width: 80,
          child :   DropdownButton<String>(
                value: dropdownValue2,
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
                    dropdownValue2 = newValue;
                  });
                },
                items: <String>['2024', '2025', '2026', '2027', '2028', '2029', '2030', '2031', '2032', '2033', '2034', '2035']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    
                    child: Text(value),
                  );
                }).toList(),
              ),),
              const SizedBox(width: 30),
              TextField(
                 textAlign: TextAlign.center,
                controller: cvvcontroller,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: "CVV"),
                 style:const TextStyle(fontWeight: FontWeight.w500),
                 maxLength: 3,
                 

              ),
            
          TextField(
            textAlign: TextAlign.center,
            controller: titularcontroller,
            decoration: const InputDecoration(labelText: "Nombre del titular de la tarjeta"),
            style:const TextStyle(fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 50,),
          
                OutlinedButton(onPressed: () async {
                  
                 _insertCard();

                  
                }, child: const Text("Insertar Datos"))
        ],
      ),
        ),
      ),
      ),
    );
  }
}



