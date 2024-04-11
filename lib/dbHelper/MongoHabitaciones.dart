// To parse this JSON data, do
//
//     final mongoHabitaciones = mongoHabitacionesFromJson(jsonString);

// ignore_for_file: file_names, non_constant_identifier_names

import 'dart:convert';

import 'package:mongo_dart/mongo_dart.dart';

MongoHabitaciones mongoHabitacionesFromJson(String str) => MongoHabitaciones.fromJson(json.decode(str));

String mongoHabitacionesToJson(MongoHabitaciones data) => json.encode(data.toJson());

class MongoHabitaciones {
    ObjectId id;
    String habitacion;
    String capacidad;
    bool disponible;
    String linkimagen;
    String precio_por_Persona;


    MongoHabitaciones({
        required this.id,
        required this.habitacion,
        required this.capacidad,
        required this.disponible,
        required this.linkimagen,
        required this.precio_por_Persona,
  
    });

    factory MongoHabitaciones.fromJson(Map<String, dynamic> json) => MongoHabitaciones(
        id: json["_id"],
        habitacion: json["habitacion"],
        capacidad: json["capacidad"],
        disponible: json["disponible"],
        linkimagen: json["linkimagen"],
        precio_por_Persona: json["precio_por_Persona"],
        
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "habitacion": habitacion,
        "capacidad": capacidad,
        "disponible": disponible,
        "linkimagen": linkimagen,
        "precio_por_Persona": precio_por_Persona,
        
    };
    }

