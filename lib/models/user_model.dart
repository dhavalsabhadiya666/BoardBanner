part of 'models.dart';

class UserData {
  String? userId;
  String? nickName;
  String? name;
  String? email;
  String? password;
  String? state;
  String? city;
  String? photoUrl;
  AuthType? authType; // 0 = Email/Password, 1 = Google, 2 = Apple, 3 = Facebook
  bool? isEnable;
  BankDetails? bankDetails;
  String? paypalId;
  String? deviceToken;
  DateTime? createdAt;
  DateTime? updatedAt;

  UserData({
    this.userId,
    this.nickName,
    this.name,
    this.email,
    this.password,
    this.state,
    this.city,
    this.photoUrl,
    this.authType,
    this.isEnable,
    this.bankDetails,
    this.paypalId,
    this.deviceToken,
    this.createdAt,
    this.updatedAt,
  });

  factory UserData.fromMap(Map<String, dynamic> data) {
    return UserData(
      userId: data['userId'],
      nickName: data['nickName'],
      name: data['name'],
      email: data['email'],
      password: data['password'],
      state: data['state'],
      city: data['city'],
      photoUrl: data['photoUrl'],
      authType: authTypeMap[data['authType']],
      isEnable: data['isEnable'],
      paypalId: data['paypalId'],
      deviceToken: data['deviceToken'],
      bankDetails: data['bankDetails'] != null
          ? BankDetails.fromMap(data['bankDetails'])
          : null,
      createdAt:
          DateTime.fromMillisecondsSinceEpoch(int.parse(data['createdAt'])),
      updatedAt:
          DateTime.fromMillisecondsSinceEpoch(int.parse(data['updatedAt'])),
    );
  }

  bool get hasData => userId != null;

  factory UserData.empty() {
    return UserData(
      userId: null,
      nickName: null,
      name: null,
      email: null,
      password: null,
      state: null,
      city: null,
      photoUrl: null,
      authType: null,
      isEnable: null,
      bankDetails: null,
      paypalId: null,
      createdAt: null,
      updatedAt: null,
      deviceToken: null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'nickName': nickName,
      'name': name,
      'email': email,
      'password': password,
      'state': state,
      'city': city,
      'photoUrl': photoUrl,
      'authType': authType?.index,
      'isEnable': isEnable,
      'paypalId': paypalId,
      'deviceToken': deviceToken,
      'bankDetails': bankDetails?.toMap(),
      'createdAt': createdAt?.millisecondsSinceEpoch.toString(),
      'updatedAt': updatedAt?.millisecondsSinceEpoch.toString(),
    };
  }
}

class BankDetails {
  String? accountNumber;
  String? ifscCode;
  String? bankName;
  String? branchName;
  String? accountHolderName;

  BankDetails({
    this.accountNumber,
    this.ifscCode,
    this.bankName,
    this.branchName,
    this.accountHolderName,
  });

  factory BankDetails.fromMap(Map<String, dynamic> data) {
    return BankDetails(
      accountNumber: data['accountNumber'],
      ifscCode: data['ifscCode'],
      bankName: data['bankName'],
      branchName: data['branchName'],
      accountHolderName: data['accountHolderName'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'accountNumber': accountNumber,
      'ifscCode': ifscCode,
      'bankName': bankName,
      'branchName': branchName,
      'accountHolderName': accountHolderName,
    };
  }
}
