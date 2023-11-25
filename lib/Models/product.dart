class Product {
  int? productId;
  String name;
  int perUnitPrice;
  String unitType;
  int quantity;
  int price;
  int? bagId;

  Product({
    required this.name,
    required this.perUnitPrice,
    required this.unitType,
    required this.quantity,
    required this.price,
    this.productId,
    this.bagId,
  });

  // Convert a Product into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap(int newBagId) {
    return {
      'product_id': productId,
      'name': name,
      'per_unit_price': perUnitPrice,
      'unit_type': unitType,
      'quantity': quantity,
      'price': price,
      'bag_id': newBagId,
    };
  }

  // Extract a Product object from a Map object. The keys must correspond to the
  // names of the columns in the database.
  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      productId: map['product_id'],
      name: map['name'],
      perUnitPrice: map['per_unit_price'],
      unitType: map['unit_type'],
      quantity: map['quantity'],
      price: map['price'],
      bagId: map['bag_id'],
    );
  }
}
