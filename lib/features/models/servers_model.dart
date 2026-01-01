// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ServersModel {
  String staffId;
  String staffName;
  String shopId;
  ServersModel({
   required this.staffId,
   required this.staffName ,
   required this.shopId,
  });
      

  ServersModel copyWith({
    String? staffId,
    String? staffName,
    String? shopId,
  }) {
    return ServersModel(
      staffId: staffId ?? this.staffId,
      staffName: staffName ?? this.staffName,
      shopId: shopId ?? this.shopId,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'staffId': staffId,
      'staffName': staffName,
      'shopId': shopId,
    };
  }

  factory ServersModel.fromMap(Map<String, dynamic> map) {
    return ServersModel(
      staffId: map['staffId'] as String,
      staffName: map['staffName'] as String,
      shopId: map['shopId'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory ServersModel.fromJson(String source) => ServersModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'ServersModel(staffId: $staffId, staffName: $staffName, shopId: $shopId)';

  @override
  bool operator ==(covariant ServersModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.staffId == staffId &&
      other.staffName == staffName &&
      other.shopId == shopId;
  }

  @override
  int get hashCode => staffId.hashCode ^ staffName.hashCode ^ shopId.hashCode;
}
