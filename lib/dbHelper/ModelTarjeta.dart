// ignore_for_file: file_names

import 'dart:convert';

import 'package:mongo_dart/mongo_dart.dart';


ModelTarjeta modelTarjetaFromJson(String str) => ModelTarjeta.fromJson(json.decode(str));

String modelTarjetaToJson(ModelTarjeta datas) => json.encode(datas.toJson());
class ModelTarjeta {
ObjectId id;
    String propietario;
    String numerotarjeta;
    String? fechavenc;
    String? aniovenc;
    String cvc;
    String user;
    

    ModelTarjeta({
              required this.id,

        required this.propietario,
        required this.numerotarjeta,
        required this.fechavenc,
        required this.aniovenc,
        required this.cvc,
       required this.user,

        
    });

    factory ModelTarjeta.fromJson(Map<String, dynamic> json) => ModelTarjeta(
      id: json["_id"],
        propietario: json["propietario"],
        numerotarjeta: json["numerotarjeta"],
        fechavenc: json["fechavenc"],
        aniovenc: json["aniovenc"],
        cvc: json["cvc"],
        user: json["user"],
       
    );

    Map<String, dynamic> toJson() => {
      "_id": id,
        "propietario": propietario,
        "numerotarjeta": numerotarjeta,
        "fechavenc": fechavenc,
        "aniovenc": aniovenc,
        "cvc": cvc,
        "user": user,
        
    };
}