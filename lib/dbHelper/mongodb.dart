// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:hotel_aplicacion/dbHelper/ModelCodigoAdmin.dart';
import 'package:hotel_aplicacion/dbHelper/ModelTarjeta.dart';
import 'package:hotel_aplicacion/dbHelper/MongoDBModel.dart';
import 'package:hotel_aplicacion/dbHelper/MongoDbModelReserva.dart';
import 'package:hotel_aplicacion/dbHelper/MongoDisplayNotificaciones.dart';
import 'package:hotel_aplicacion/dbHelper/MongoHabitaciones.dart';
import 'package:hotel_aplicacion/dbHelper/MongoModelReportar.dart';
import 'package:hotel_aplicacion/dbHelper/constant.dart';
import 'package:hotel_aplicacion/pantallas/pantalla1.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:shared_preferences/shared_preferences.dart';
   var db, userCollection;
   String pregunta ="?";
   var respuesta;
class MongoDatabase {


   static Future<bool> connect() async {
    try {
      db = await Db.create(MONGO_CON_URL);
      await db!.open();
      inspect(db);
      userCollection = db.collection(USER_COLLECTION);
      return true; 
    } catch (e) {
      if (kDebugMode) {
        print('Error al conectar a la base de datos: $e');
      }
      return false; 
    }
  }

  static Future<List<Map<String, dynamic>>> getData() async {

    final arrData = (await userCollection.find().toList()).reversed.toList();
    return arrData;

  }

    static Future<List<Map<String, dynamic>>> getDataTarjetas() async {
      userCollection = db.collection(USER_COLLECTION4);
    final query = {
    
    'user': publicusername,
    

  };
    final arrData = await userCollection.find(query).toList();
    return arrData;

  }

      static Future<List<Map<String, dynamic>>> getDataNotificaciones() async {
       userCollection = db!.collection('notificaciones');
    
    final arrData = (await userCollection.find().toList()).reversed.toList();
    return arrData;

  }

 
static Future<List<Map<String, dynamic>>> getDataReservas() async {
  DateTime fechaManana = DateTime.now();
  
  String fechaMananaFormatted = "${fechaManana.year}-${fechaManana.month.toString().padLeft(2, '0')}-${fechaManana.day.toString().padLeft(2, '0')}";

  final query = {
    'fechainicio': {r'$gte': fechaMananaFormatted},
    'estado': "Pendiente",
  };

  final arrData = (await userCollection.find(query).toList()).reversed.toList();

  return arrData;
}

static Future<List<MongoReservaHabitaciones>> getDataReservasPorPagar(String state) async {
   DateTime fechaManana = DateTime.now();
  
  String fechaMananaFormatted = "${fechaManana.year}-${fechaManana.month.toString().padLeft(2, '0')}-${fechaManana.day.toString().padLeft(2, '0')}";
        userCollection = db!.collection('reservas');

  final query = {
    'fechainicio': {r'$gte': fechaMananaFormatted},
    'estado': state,
  };
    List<MongoReservaHabitaciones> reservasPagadas = [];
   final data = (await userCollection.find(query).toList()).reversed.toList();
    for (var reserva in data) {
      reservasPagadas.add(MongoReservaHabitaciones.fromJson(reserva));
    }
    return reservasPagadas;
}


static Future<List<MongoDbModel>> getusuarios() async {
          userCollection = db!.collection('admin');

  final query = {
    'username': { '\$exists': true }
    
  };
    List<MongoDbModel> user = [];
   final data = (await userCollection.find(query).toList()).reversed.toList();
    for (var usuario in data) {
      user.add(MongoDbModel.fromJson(usuario));
    }
    return user;
}



static Future<List<Map<String, dynamic>>> getDataReservasPagadas() async {
        userCollection = db!.collection('reservas');

  
  DateTime fechaManana = DateTime.now();
  
  
  String fechaMananaFormatted = "${fechaManana.year}-${fechaManana.month.toString().padLeft(2, '0')}-${fechaManana.day.toString().padLeft(2, '0')}";

  
  final query = {
    'fechainicio': {r'$gte': fechaMananaFormatted},
    'estado': "Pagado",
  };
  
  final arrData = (await userCollection.find(query).toList()).reversed.toList();

  return arrData;
}
static Future<List<MongoReservaHabitaciones>> getDataReservasPagadass() async {
   DateTime fechaManana = DateTime.now();
  
  String fechaMananaFormatted = "${fechaManana.year}-${fechaManana.month.toString().padLeft(2, '0')}-${fechaManana.day.toString().padLeft(2, '0')}";
        userCollection = db!.collection('reservas');

  final query = {
    'fechainicio': {r'$gte': fechaMananaFormatted},
    'estado': "Pagado",
  };
    List<MongoReservaHabitaciones> reservasPagadas = [];
   final data = (await userCollection.find(query).toList()).reversed.toList();
    for (var reserva in data) {
      reservasPagadas.add(MongoReservaHabitaciones.fromJson(reserva));
    }
    return reservasPagadas;
  }


static Future<List<MongoReservaHabitaciones>> getDataHistorial() async {

        userCollection = db!.collection('reservas');

 
    final query = {
  '\$expr': {
    '\$gt': [ { '\$toDouble': '\$precio' }, 1 ]
  }
};
    List<MongoReservaHabitaciones> reservasPagadas = [];
   final data = (await userCollection.find(query).toList()).reversed.toList();
    for (var reserva in data) {
      reservasPagadas.add(MongoReservaHabitaciones.fromJson(reserva));
    }
    return reservasPagadas;
    
}

  static Future<void> gethabitacion(ObjectId ide) async {
  userCollection = db!.collection(USER_COLLECTION2);

  final arrData = await userCollection.findOne({"_id": ide});

  return arrData!;
}
 static Future<void> getProfile() async {
      userCollection = db!.collection('admin');

  final arrData = await userCollection.findOne({"username": publicusername});

  return arrData!;
}
  // ignore: non_constant_identifier_names
  static Future<bool> getuser(String name, String Contrasenia) async {
  userCollection = db!.collection('admin');

  var arrData = await userCollection.findOne({"contrasenia": Contrasenia,"username" : name});
  if (arrData != null){
    arrData = true;
  }else{
    arrData = false;
  }
  return arrData;

}

  static Future<bool> getcodigo(String codigo) async {
        userCollection = db!.collection('codigos');

  var arrData = await userCollection.findOne({"codigo": codigo ,"usado":false });
  if (arrData != null){
    arrData = true;
  }else{
    arrData = false;
  }
  return arrData;

}


 static Future<bool> registro(String name) async {
        userCollection = db!.collection('admin');

  var user = await userCollection.findOne({"username": name});
  if(user != null){
    user= true;
  }else{
    user = false;
  }
  return user;
}

 

  static Future<String> insert(MongoDbModel data) async {
    try {
       userCollection = db!.collection('admin');

      var result = await userCollection.insertOne(data.toJson());
      if (result.isSuccess){
        return "DATOS INSERTADOS";
      }else {
        return "ERROR INESPERADO";
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      return(e.toString());
    }
  }
   static Future<String> insertHabitacion(MongoHabitaciones data) async {
    try {
             userCollection = db!.collection('habitaciones');

      var result = await userCollection.insertOne(data.toJson());
      if (result.isSuccess){
        return "DATOS INSERTADOS";
      }else {
        return "ERROR INESPERADO";
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      return(e.toString());
    }
  }

 static Future<String> insertNotificacion( ModelDisplayNotificaciones data) async {
    try {
            userCollection = db!.collection('notificaciones');

      var result = await userCollection.insertOne(data.toJson());
      if (result.isSuccess){
        print("DATOS INSERTADOS") ;
                        return "result";

        
      }else {
        print("DATOS INSERTADOS") ;
                return "result";

      }
    } catch (e) {
      if (kDebugMode) {
        print(" Problema al insertar ${e.toString()}");
      }
      return(e.toString());
    }
  }

   static Future<String> insertCodigo( ModelcodigoAdmin data) async {
    try {
            userCollection = db!.collection('codigos');

      var result = await userCollection.insertOne(data.toJson());
      if (result.isSuccess){
        print("DATOS INSERTADOS") ;
                        return "result";

        
      }else {
        print("DATOS INSERTADOS") ;
                return "result";

      }
    } catch (e) {
      if (kDebugMode) {
        print(" Problema al insertar ${e.toString()}");
      }
      return(e.toString());
    }
  }

  static Future<String> insertProblema(ReportarProblemaModel data) async {
    try {
      userCollection = db!.collection('problemas');
      var result = await userCollection.insertOne(data.toJson());
      if (result.isSuccess){
        return "DATOS INSERTADOS";
      }else {
        return "ERROR INESPERADO";
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      return(e.toString());
    }
  }

  static Future<String> insertCard(ModelTarjeta data) async {
    try {
      userCollection = db!.collection('tarjetas');
      var result = await userCollection.insertOne(data.toJson());
      if (result.isSuccess){
        return "DATOS INSERTADOS";
      }else {
        return "ERROR INESPERADO";
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      return(e.toString());
    }
  }

  static Future<String> insertReserva(MongoReservaHabitaciones data) async {
    try {
      userCollection = db!.collection('reservas');
      var result = await userCollection.insertOne(data.toJson());
      if (result.isSuccess){
        return "DATOS INSERTADOS";
      }else {
        return "ERROR INESPERADO";
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      return(e.toString());
    }
  }
  static Future<bool> recuperarContrasenia(String name) async {
  userCollection = db!.collection('admin');
  var arrData;
  bool getuser = false;
try {
   arrData = await userCollection.findOne({"username" : name});
  if (arrData != null){
    
    respuesta = arrData['respuesta'];
        pregunta = arrData['pregunta'];
        getuser = true;

  }else{
            getuser = false;

  }

} catch (e) {
  if (kDebugMode) {
      print(e.toString());
    }
}
  return getuser;
  
}
   static Future<void> updateReserva(MongoReservaHabitaciones data,String estado) async {
    userCollection = db!.collection('reservas');
    
  try {
    var result = await userCollection.findOne({"_id": data.id});
    if (result!= null) {
      if (kDebugMode) {
        print(result['estado']);
      }
      /*
      result['estado'] = 'Pagado';
      var response = await userCollection.update(result); */
      
      var response = await userCollection.updateOne(where.eq('_id',data.id),modify.set('estado',estado));
     
      inspect(response);
    } else {
      if (kDebugMode) {
        print('No document');
      }
    }
  } catch (e) {
    if (kDebugMode) {
      print(e.toString());
    }
  }
}

   static Future<void> updateContrasenia(String contra) async {
    userCollection = db!.collection('admin');
    
  try {
    var result = await userCollection.findOne({"username": publicusername});
    if (result!= null) {
      if (kDebugMode) {
        print(result['contrasenia']);
      }
     
      
      var response = await userCollection.updateOne(where.eq('username',publicusername),modify.set('contrasenia',contra));
     
      inspect(response);
    } else {
      if (kDebugMode) {
        print('No document ');
      }
    }
  } catch (e) {
    if (kDebugMode) {
      print(e.toString());
    }
  }
}

 static Future<void> updateCodigo(String? codigo) async {
    userCollection = db!.collection('codigos');
    
  try {
    var result = await userCollection.findOne({"codigo": codigo});
    if (result!= null) {
      if (kDebugMode) {
        print(result['contrasenia']);
      }
     
      
      var response = await userCollection.updateOne(where.eq('codigo',codigo),modify.set('usado',true));
     
      inspect(response);
    } else {
      if (kDebugMode) {
        print('No document ');
      }
    }
  } catch (e) {
    if (kDebugMode) {
      print(e.toString());
    }
  }
}

 static Future<void> updateProfile(MongoDbModel data) async {
  userCollection = db!.collection('admin');

  try {
    var result = await userCollection.findOne({"_id": data.id});
    if (result != null) {
      publicusername = data.usernamae;
        SharedPreferences prefs = await SharedPreferences.getInstance();
       prefs.setString('contra',data.contrasenia);
         prefs.setString('username',data.usernamae);

      var modifiers = {
        'firstName': data.firstName,
        'apellidos': data.apellidos,
        'identidad': data.identidad,
        'username': data.usernamae,
        'contrasenia': data.contrasenia,
        'respuesta': data.respuesta,
        'pregunta': data.pregunta,
      };

      var setModifiers = modify;
      modifiers.forEach((key, value) {
        setModifiers = setModifiers.set(key, value);
      });

      var response = await userCollection.updateOne(where.eq('_id', data.id), setModifiers);
      
      inspect(response);
    } else {
      if (kDebugMode) {
        print('No document found');
      }
    }
  } catch (e) {
    if (kDebugMode) {
      print(e.toString());
    }
  }
}

 static Future<void> updateHabitacion(MongoHabitaciones data) async {
  userCollection = db!.collection('habitaciones');

  try {
    var result = await userCollection.findOne({"_id": data.id});
    if (result != null) {
      
      var modifiers = {
        'habitacion': data.habitacion,
        'capacidad': data.capacidad,
        'disponible': data.disponible,
        'linkimagen': data.linkimagen,
        'precio_por_Persona': data.precio_por_Persona,
  
      };

      var setModifiers = modify;
      modifiers.forEach((key, value) {
        setModifiers = setModifiers.set(key, value);
      });

      var response = await userCollection.updateOne(where.eq('_id', data.id), setModifiers);
      
      inspect(response);
    } else {
      if (kDebugMode) {
        print('No document found');
      }
    }
  } catch (e) {
    if (kDebugMode) {
      print(e.toString());
    }
  }
}

static Future<void> deleteReserva(MongoReservaHabitaciones data) async {
    userCollection = db!.collection('reservas');
    
  try {
    
      
      var response = await userCollection.deleteOne({'_id':data.id});
     
      inspect(response);
     
  } catch (e) {
    if (kDebugMode) {
      print(e.toString());
    }
  }
}

static Future<void> deleteHabitacion(MongoHabitaciones data) async {
    userCollection = db!.collection('habitaciones');
    
  try {
    
      
      var response = await userCollection.deleteOne({'_id':data.id});
     
      inspect(response);
     
  } catch (e) {
    if (kDebugMode) {
      print(e.toString());
    }
  }
}

static Future<void> deleteTarjeta(ModelTarjeta data) async {
    userCollection = db!.collection('tarjetas');
    
  try {
    
      
      var response = await userCollection.deleteOne({'_id':data.id});
     
      inspect(response);
     
  } catch (e) {
    if (kDebugMode) {
      print(e.toString());
    }
  }
}

}
