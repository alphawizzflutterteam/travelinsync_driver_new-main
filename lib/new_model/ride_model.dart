class RideModel {
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
  String? remark;
  String? status;
  String? createdDate;
  String? bookingOtp;
  String? assignedFor;
  String? userImage;
  String? usermobile;

  RideModel(
      {this.id,
        this.userId,
        this.remark,
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
        this.bookingOtp,
        this.assignedFor,
        this.userImage,
        this.usermobile});

  RideModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    remark = json['remark'];
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
    assignedFor = json['assigned_for'];
    userImage = json['user_image'];
    usermobile = json['usermobile'];
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
    data['assigned_for'] = this.assignedFor;
    data['user_image'] = this.userImage;
    data['usermobile'] = this.usermobile;
    return data;
  }
}
