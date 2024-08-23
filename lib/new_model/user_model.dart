class UserModel {
  String? username;
  String? email;
  String? password;
  String? mobile;
  String? gender;
  String? employeeId;
  String? userImage;

  UserModel(
      {this.username,
        this.employeeId,
        this.email,
        this.password,
        this.mobile,
        this.gender,
        this.userImage});

  UserModel.fromJson(Map<String, dynamic> json) {
    username = json['user_name'];
    employeeId = json['driver_code']??"Tis0001";
    email = json['email'];
    password = json['password'];
    mobile = json['phone'];
    gender = json['gender'];
    userImage = json['user_image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['username'] = this.username;
    data['email'] = this.email;
    data['password'] = this.password;
    data['mobile'] = this.mobile;
    data['gender'] = this.gender;
    data['user_image'] = this.userImage;
    return data;
  }
}
