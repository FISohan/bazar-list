import 'package:bazar_list/Models/product.dart';

class BagDto {
  int? bagId;
  final String createTime;
  final int totalCost;
  BagDto( {
    required this.createTime,
    required this.totalCost,
    required this.bagId
  });

  Map<String, dynamic> toMap() {
    return {
      'bag_id': bagId,
      'create_time': createTime,
      'total_cost':totalCost
    };
  }

  factory BagDto.fromMap(Map<String, dynamic> map) {
    return BagDto(
        bagId:map['bag_id'],
        createTime: map['create_time'],
        totalCost: map['total_cost'],
    );
  }
}