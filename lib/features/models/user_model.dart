class UserModel {
  String firstName;
  String lastName;
  String? otherName;
  int roleId;
  String userId;
  String shopId;
  String roleName;

  UserModel(
      {required this.firstName,
      required this.lastName,
      this.otherName,
      required this.roleId,
      required this.userId,
      required this.shopId,
      required this.roleName});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      otherName: json['otherName'] ?? '',
      roleId: int.parse(json['roleId']),
      userId: json['userId'] as String,
      shopId: json['shopId'] as String,
      roleName: json['roleName'] as String,
    );
  }
}
