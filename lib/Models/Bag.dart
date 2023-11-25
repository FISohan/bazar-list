import 'package:bazar_list/Models/product.dart';

class Bag {
  int? bagId;
  final String createTime;
  final List<Product>products;
  Bag({
    required this.createTime,
    required this.products,
    this.bagId
  });

  Map<String, dynamic> toMap() {
    return {
      'bag_id': bagId,
      'create_time': createTime,
      'products':products
    };
  }

  factory Bag.fromMap(Map<String, dynamic> map) {
    return Bag(
      bagId:map['bagId']!,
      createTime: map['create_time'],
      products: map['products']
    );
  }
}