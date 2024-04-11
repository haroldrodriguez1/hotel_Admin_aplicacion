// To parse this JSON data, do
//
//     final mongoReservaHabitaciones = mongoReservaHabitacionesFromJson(jsonString);

// ignore_for_file: file_names

import 'dart:convert';

import 'package:mongo_dart/mongo_dart.dart';


MongoReservaHabitaciones mongoReservaHabitacionesFromJson(String str) => MongoReservaHabitaciones.fromJson(json.decode(str));

String mongoReservaHabitacionesToJson(MongoReservaHabitaciones data) => json.encode(data.toJson());

class MongoReservaHabitaciones {
    ObjectId id;
    String habitacion;
    String usuario;
    String fechainicio;
    String fechafinal;
    String namereservador;
    String idreservador;
    String estado;
    String personas;
    String precio;


    MongoReservaHabitaciones({
        required this.id,
        required this.habitacion,
        required this.usuario,
        required this.fechainicio,
        required this.fechafinal,
        required this.namereservador,
        required this.idreservador,
        required this.estado,
        required this.personas,
        required this.precio,

    });

    factory MongoReservaHabitaciones.fromJson(Map<String, dynamic> json) => MongoReservaHabitaciones(
      id: json["_id"],
        habitacion: json["habitacion"],
        usuario: json["usuario"],
        fechainicio: json["fechainicio"],
        fechafinal: json["fechafinal"],
        namereservador: json["namereservador"],
        idreservador: json["idreservador"],
        estado: json["estado"],
        personas: json["personas"],
        precio: json["precio"],
    );

    Map<String, dynamic> toJson() => {
      "_id": id,
        "habitacion": habitacion,
        "usuario": usuario,
        "fechainicio": fechainicio,
        "fechafinal": fechafinal,
        "namereservador": namereservador,
        "idreservador": idreservador,
        "estado": estado,
        "personas": personas,
        "precio": precio,
    };
}
