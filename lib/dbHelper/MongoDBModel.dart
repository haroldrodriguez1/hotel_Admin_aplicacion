// To parse this JSON data, do
//
//     final mongoDbModel = mongoDbModelFromJson(jsonString);

// ignore_for_file: file_names

import 'dart:convert';

import 'package:mongo_dart/mongo_dart.dart';

MongoDbModel mongoDbModelFromJson(String str) => MongoDbModel.fromJson(json.decode(str));

String mongoDbModelToJson(MongoDbModel data) => json.encode(data.toJson());

class MongoDbModel {
    ObjectId id;
    String firstName;
    String apellidos;
    String identidad;
    String usernamae;
    String contrasenia;
    String respuesta;
    String pregunta;

    MongoDbModel({
        required this.id,
        required this.firstName,
        required this.apellidos,
        required this.identidad,
        required this.usernamae,
        required this.contrasenia,
        required this.respuesta,
   required this.pregunta,

    });

    factory MongoDbModel.fromJson(Map<String, dynamic> json) => MongoDbModel(
        id: json["_id"],
        firstName: json["firstName"],
        apellidos: json["apellidos"],
        identidad: json["identidad"],
        usernamae: json["username"],
        contrasenia: json["contrasenia"],
        respuesta: json["respuesta"],
        pregunta: json["pregunta"],
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "firstName": firstName,
        "apellidos": apellidos,
        "identidad": identidad,
        "username": usernamae,
        "contrasenia": contrasenia,
        "respuesta": respuesta,
        "pregunta": pregunta,

    };
}
