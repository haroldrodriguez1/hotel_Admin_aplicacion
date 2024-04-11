// To parse this JSON data, do
//
//     final modelDisplayNotificaciones = modelDisplayNotificacionesFromJson(jsonString);

// ignore_for_file: file_names

import 'dart:convert';

import 'package:mongo_dart/mongo_dart.dart';

ModelDisplayNotificaciones modelDisplayNotificacionesFromJson(String str) => ModelDisplayNotificaciones.fromJson(json.decode(str));

String modelDisplayNotificacionesToJson(ModelDisplayNotificaciones data) => json.encode(data.toJson());

class ModelDisplayNotificaciones {
    String notificacion;
    String username;
    ObjectId id;

    ModelDisplayNotificaciones({
        required this.notificacion,
        required this.username,
        required this.id,
    });

    factory ModelDisplayNotificaciones.fromJson(Map<String, dynamic> json) => ModelDisplayNotificaciones(
        notificacion: json["notificacion"],
        username: json["username"],
        id: json["_id"],
    );

    Map<String, dynamic> toJson() => {
        "notificacion": notificacion,
        "username": username,
        "_id": id,
    };
}
