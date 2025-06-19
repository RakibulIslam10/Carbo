class HistoryModel {
  Message message;
  Data data;
  String type;

  HistoryModel({
    required this.message,
    required this.data,
    required this.type,
  });

  factory HistoryModel.fromJson(Map<String, dynamic> json) => HistoryModel(
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
  List<History> history;

  Data({
    required this.history,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        history:
            List<History>.from(json["history"].map((x) => History.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "history": List<dynamic>.from(history.map((x) => x.toJson())),
      };
}

class History {
  String location;
  String destination;
  String paymentType;
  int distance;
  String pickupTime;
  dynamic roundPickupTime;
  dynamic amount;
  DateTime pickupDate;
  dynamic roundPickupDate;
  String message;
  int status;
  DateTime createdAt;
  DateTime updatedAt;
  Cars cars;

  History({
    required this.location,
    required this.destination,
    required this.paymentType,
    required this.distance,
    required this.pickupTime,
    required this.roundPickupTime,
    required this.amount,
    required this.pickupDate,
    required this.roundPickupDate,
    required this.message,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.cars,
  });

  factory History.fromJson(Map<String, dynamic> json) => History(
        location: json["location"],
        destination: json["destination"],
        paymentType: json["payment_type"],
        distance: json["distance"],
        pickupTime: json["pickup_time"],
        roundPickupTime: json["round_pickup_time"],
        amount: json["amount"],
        pickupDate: DateTime.parse(json["pickup_date"]),
        roundPickupDate: json["round_pickup_date"],
        message: json["message"],
        status: json["status"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        cars: Cars.fromJson(json["cars"]),
      );

  Map<String, dynamic> toJson() => {
        "location": location,
        "destination": destination,
        "payment_type": paymentType,
        "distance": distance,
        "pickup_time": pickupTime,
        "round_pickup_time": roundPickupTime,
        "pickup_date":
            "${pickupDate.year.toString().padLeft(4, '0')}-${pickupDate.month.toString().padLeft(2, '0')}-${pickupDate.day.toString().padLeft(2, '0')}",
        "round_pickup_date": roundPickupDate,
        "message": message,
        "status": status,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "cars": cars.toJson(),
      };
}

class Cars {
  String carModel;
  String carNumber;

  Cars({
    required this.carModel,
    required this.carNumber,
  });

  factory Cars.fromJson(Map<String, dynamic> json) => Cars(
        carModel: json["car_model"],
        carNumber: json["car_number"],
      );

  Map<String, dynamic> toJson() => {
        "car_model": carModel,
        "car_number": carNumber,
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
