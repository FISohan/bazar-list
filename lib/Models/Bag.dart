import 'package:bazar_list/Models/product.dart';

class Bag {
  int? bagId;
  final String createTime;
  final int totalCost;
  final List<Product>products;
  Bag( {
    required this.createTime,
    required this.products,
    required this.totalCost,
    this.bagId
  });

  Map<String, dynamic> toMap() {
    return {
      'bag_id': bagId,
      'create_time': createTime,
      'total_cost':totalCost
    };
  }

  factory Bag.fromMap(Map<String, dynamic> map) {
    return Bag(
      bagId:map['bag_id'],
      createTime: map['create_time'],
      totalCost: map['total_cost'],
      products: map['products']
    );
  }
}