// To parse this JSON data, do
//
//     final carInfoModel = carInfoModelFromJson(jsonString);

import 'dart:convert';

CarInfoModel carInfoModelFromJson(String str) =>
    CarInfoModel.fromJson(json.decode(str));

String carInfoModelToJson(CarInfoModel data) => json.encode(data.toJson());

class CarInfoModel {
  Message message;
  Data data;
  String type;

  CarInfoModel({
    required this.message,
    required this.data,
    required this.type,
  });

  factory CarInfoModel.fromJson(Map<String, dynamic> json) => CarInfoModel(
        message: Message.fromJson(json["message"]),
        data: Data.fromJson(json["data"]),
        type: json["type"],
      );

  Map<String, dynamic> toJson() => {
        "message": message.toJson(),
        "data": data.toJson(),
        "type": type,
      };
}

class Data {
  String token;
  List<Car> cars;
  DataPath dataPath;

  Data({
    required this.token,
    required this.cars,
    required this.dataPath,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        token: json["token"],
        cars: List<Car>.from(json["cars"].map((x) => Car.fromJson(x))),
        dataPath: DataPath.fromJson(json["data_path"]),
      );

  Map<String, dynamic> toJson() => {
        "token": token,
        "cars": List<dynamic>.from(cars.map((x) => x.toJson())),
        "data_path": dataPath.toJson(),
      };
}

class Car {
  int id;
  int vendorId;
  int carAreaId;
  int carTypeId;
  String slug;
  CarTitle carTitle;
  String carModel;
  int seat;
  int experience;
  String carNumber;
  String fees;
  String image;
  int status;
  int approval;
  DateTime createdAt;
  DateTime updatedAt;

  Car({
    required this.id,
    required this.vendorId,
    required this.carAreaId,
    required this.carTypeId,
    required this.slug,
    required this.carTitle,
    required this.carModel,
    required this.seat,
    required this.experience,
    required this.carNumber,
    required this.fees,
    required this.image,
    required this.status,
    required this.approval,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Car.fromJson(Map<String, dynamic> json) => Car(
        id: json["id"],
        vendorId: json["vendor_id"],
        carAreaId: json["car_area_id"],
        carTypeId: json["car_type_id"],
        slug: json["slug"],
        carTitle: CarTitle.fromJson(json["car_title"]),
        carModel: json["car_model"],
        seat: json["seat"],
        experience: json["experience"],
        carNumber: json["car_number"],
        fees: json["fees"],
        image: json["image"],
        status: json["status"],
        approval: json["approval"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "vendor_id": vendorId,
        "car_area_id": carAreaId,
        "car_type_id": carTypeId,
        "slug": slug,
        "car_title": carTitle.toJson(),
        "car_model": carModel,
        "seat": seat,
        "experience": experience,
        "car_number": carNumber,
        "fees": fees,
        "image": image,
        "status": status,
        "approval": approval,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}

class CarTitle {
  Ar en;
  Ar fr;
  Ar es;
  Ar ar;

  CarTitle({
    required this.en,
    required this.fr,
    required this.es,
    required this.ar,
  });

  factory CarTitle.fromJson(Map<String, dynamic> json) => CarTitle(
        en: Ar.fromJson(json["en"]),
        fr: Ar.fromJson(json["fr"]),
        es: Ar.fromJson(json["es"]),
        ar: Ar.fromJson(json["ar"]),
      );

  Map<String, dynamic> toJson() => {
        "en": en.toJson(),
        "fr": fr.toJson(),
        "es": es.toJson(),
        "ar": ar.toJson(),
      };
}

class Ar {
  String carTitle;

  Ar({
    required this.carTitle,
  });

  factory Ar.fromJson(Map<String, dynamic> json) => Ar(
        carTitle: json["car_title"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "car_title": carTitle,
      };
}

class DataPath {
  String baseUrl;
  String imagePath;

  DataPath({
    required this.baseUrl,
    required this.imagePath,
  });

  factory DataPath.fromJson(Map<String, dynamic> json) => DataPath(
        baseUrl: json["base_url"],
        imagePath: json["image_path"],
      );

  Map<String, dynamic> toJson() => {
        "base_url": baseUrl,
        "image_path": imagePath,
      };
}

class Message {
  List<String> success;

  Message({
    required this.success,
  });

  factory Message.fromJson(Map<String, dynamic> json) => Message(
        success: List<String>.from(json["success"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "success": List<dynamic>.from(success.map((x) => x)),
      };
}
