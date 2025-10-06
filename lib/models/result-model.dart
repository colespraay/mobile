import 'dart:convert';

ResModel resModelFromJson(String str) => ResModel.fromJson(json.decode(str));
String resModelToJson(ResModel data) => json.encode(data.toJson());

String resModelDataToString(dynamic data) => json.encode(data);
dynamic resModelDataToJson(String data) => json.decode(data);

class ResModel {
  bool? success;
  String? message;
  dynamic data;
  bool? status;
  num? statusCode;
  UserD? userD;
  String? token;
  String? refreshToken;
  String? error;
  String? otp;

  bool get isSuccess => statusCode == 200 || statusCode == 201;

  ResModel({this.success = false, this.message, this.data, this.status, this.statusCode, this.token, this.refreshToken, this.userD, this.error, this.otp});

  factory ResModel.fromJson(Map<String, dynamic> json) => ResModel(
        success: json["success"],
        message: json["message"],
        // (json['error'] != null ? json['error']['message'] : (json['msg'])),
        data: json["data"],
        statusCode: json['code'] ?? json['statusCode'],
        refreshToken: json['refreshToken'],
        token: json['token'],
        userD: json['userD'] == null
            ? json['user'] == null
                ? null
                : UserD.fromJson(json['user'])
            : UserD.fromJson(json['userD']),
        otp: json['otp'] == null ? null : json['otp'].toString(),
      );

  Map<String, dynamic> toJson() =>
      {"success": success, "message": message, "data": data, 'statusCode': statusCode, "refreshToken": refreshToken ?? null, "token": token ?? null, "userD": userD ?? null, "otp": otp ?? null};

  @override
  String toString() {
    return 'ResModel{message: $message, data: $data, status: $status, statusCode: $statusCode, userD: ${userD.toString()}, token: $token, refreshToken: $refreshToken, error: $error, otp: $otp}';
  }

  ResModel copyWith({String? message, dynamic data, bool? status, String? error}) => ResModel(
        //success: success ?? this.success,
        message: message ?? this.message,
        data: data ?? this.data,
        status: status ?? this.status,
        error: error ?? this.error,
      );
}

//
UserD userDFromJson(String str) => UserD.fromJson(json.decode(str));
String userDToJson(UserD data) => json.encode(data.toJson());

class UserD {
  String? id;
  String? username;
  String? firstname;
  String? lastname;
  String? othername;
  String? phonenumber;
  String? email;
  String? passwordharsh;
  String? userType;
  String? profilePicture;
  String? createdAt;
  String? updatedAt;

  UserD({this.id, this.username, this.firstname, this.lastname, this.othername, this.phonenumber, this.email, this.passwordharsh, this.userType, this.profilePicture, this.createdAt, this.updatedAt});

  UserD.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    firstname = json['firstname'];
    lastname = json['lastname'];
    othername = json['othername'];
    phonenumber = json['phonenumber'];
    email = json['email'];
    passwordharsh = json['passwordharsh'];
    userType = json['userType'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['username'] = username;
    data['firstname'] = firstname;
    data['lastname'] = lastname;
    data['othername'] = othername;
    data['phonenumber'] = phonenumber;
    data['email'] = email;
    data['passwordharsh'] = passwordharsh;
    data['userType'] = userType;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }

  @override
  String toString() {
    return 'UserD{id: $id, username: $username, firstname: $firstname, lastname: $lastname, othername: $othername, phonenumber: $phonenumber, email: $email, passwordharsh: $passwordharsh, userType: $userType, createdAt: $createdAt, updatedAt: $updatedAt}';
  }
}

class CustomerAccountModel {
  String? id;
  String? accountName;
  CustomerAccountModel({this.id, this.accountName});

  CustomerAccountModel.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? json["id"].toString();
    accountName = json["accountName"];
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "accountName": accountName,
      };
}
