class ScheduleModel {
  Schedule? schedule;
  Booking? booking;

  ScheduleModel({this.schedule, this.booking});

  ScheduleModel.fromJson(Map<String, dynamic> json) {
    schedule = json['schedule'] != null
        ? new Schedule.fromJson(json['schedule'])
        : null;
    booking =
    json['booking'] != null ? new Booking.fromJson(json['booking']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.schedule != null) {
      data['schedule'] = this.schedule!.toJson();
    }
    if (this.booking != null) {
      data['booking'] = this.booking!.toJson();
    }
    return data;
  }
}

class Schedule {
  String? id;
  String? userId;
  String? pickupTime;
  String? dropTime;
  String? pickupAddress;
  String? dropAddress;

  Schedule(
      {this.id,
        this.userId,
        this.pickupTime,
        this.dropTime,
        this.pickupAddress,
        this.dropAddress});

  Schedule.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    pickupTime = json['pickup_time'];
    dropTime = json['drop_time'];
    pickupAddress = json['pickup_address'];
    dropAddress = json['drop_address'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['pickup_time'] = this.pickupTime;
    data['drop_time'] = this.dropTime;
    data['pickup_address'] = this.pickupAddress;
    data['drop_address'] = this.dropAddress;
    return data;
  }
}

class Booking {
  String? id;
  String? userId;
  String? username;
  String? pickupAddress;
  String? dropAddress;
  String? latitude;
  String? longitude;
  String? dropLatitude;
  String? dropLongitude;
  String? pickupTime;
  String? pickupDate;
  String? type;
  String? status;
  String? createdDate;
  String? bookingOtp;

  Booking(
      {this.id,
        this.userId,
        this.username,
        this.pickupAddress,
        this.dropAddress,
        this.latitude,
        this.longitude,
        this.dropLatitude,
        this.dropLongitude,
        this.pickupTime,
        this.pickupDate,
        this.type,
        this.status,
        this.createdDate,
        this.bookingOtp});

  Booking.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    username = json['username'];
    pickupAddress = json['pickup_address'];
    dropAddress = json['drop_address'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    dropLatitude = json['drop_latitude'];
    dropLongitude = json['drop_longitude'];
    pickupTime = json['pickup_time'];
    pickupDate = json['pickup_date'];
    type = json['type'];
    status = json['status'];
    createdDate = json['created_date'];
    bookingOtp = json['booking_otp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['username'] = this.username;
    data['pickup_address'] = this.pickupAddress;
    data['drop_address'] = this.dropAddress;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['drop_latitude'] = this.dropLatitude;
    data['drop_longitude'] = this.dropLongitude;
    data['pickup_time'] = this.pickupTime;
    data['pickup_date'] = this.pickupDate;
    data['type'] = this.type;
    data['status'] = this.status;
    data['created_date'] = this.createdDate;
    data['booking_otp'] = this.bookingOtp;
    return data;
  }
}
