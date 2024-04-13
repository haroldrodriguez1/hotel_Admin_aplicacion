// To parse this JSON data, do
//
//     final modelcodigoAdmin = modelcodigoAdminFromJson(jsonString);

import 'dart:convert';

import 'package:mongo_dart/mongo_dart.dart';

ModelcodigoAdmin modelcodigoAdminFromJson(String str) => ModelcodigoAdmin.fromJson(json.decode(str));

String modelcodigoAdminToJson(ModelcodigoAdmin data) => json.encode(data.toJson());

class ModelcodigoAdmin {
    ObjectId id;
    String codigo;
    bool usado;

    ModelcodigoAdmin({
        required this.id,
        required this.codigo,
        required this.usado,
    });

    factory ModelcodigoAdmin.fromJson(Map<String, dynamic> json) => ModelcodigoAdmin(
        id: json["_id"],
        codigo: json["codigo"],
        usado: json["usado"],
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "codigo": codigo,
        "usado": usado,
    };
}
