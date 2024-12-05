import 'dart:convert';

class TableOrderItem {
  final int? id;
  final int productId;
  final String productName;
  final double quantity;
  final double price;
  final String? notes;

  TableOrderItem({
    this.id,
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.price,
    double? totalPrice,
    this.notes,
  });

  double get totalPrice => quantity * price;

  Map<String, dynamic> toJson() {
    return {
      'product_id': productId,
      'product_name': productName,
      'quantity': quantity,
      'price': price,
      'notes': notes,
    };
  }

  factory TableOrderItem.fromJson(Map<String, dynamic> json) {
    return TableOrderItem(
      productId: json['product_id'],
      productName: json['product_name'],
      quantity: json['quantity'],
      price: json['price'],
      notes: json['notes'],
    );
  }

  TableOrderItem copyWith({
    int? id,
    int? productId,
    String? productName,
    double? quantity,
    double? price,
    String? notes,
  }) {
    return TableOrderItem(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      quantity: quantity ?? this.quantity,
      price: price ?? this.price,
      notes: notes ?? this.notes,
    );
  }
}

class RestaurantTable {
  final int? id;
  final String name;
  final List<TableOrderItem> orderedProducts;
  final bool isClosed;

  RestaurantTable({
    this.id,
    required this.name,
    this.orderedProducts = const [],
    this.isClosed = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'ordered_products': orderedProducts.isNotEmpty
          ? jsonEncode(orderedProducts.map((e) => e.toJson()).toList())
          : '',
      'is_closed': isClosed ? 1 : 0,
    };
  }

  factory RestaurantTable.fromMap(Map<String, dynamic> map) {
    return RestaurantTable(
      id: map['id'],
      name: map['name'],
      orderedProducts:
          map['ordered_products'] != null && map['ordered_products'] != ''
              ? (jsonDecode(map['ordered_products']) as List)
                  .map((item) => TableOrderItem.fromJson(item))
                  .toList()
              : [],
      isClosed: map['is_closed'] == 1,
    );
  }

  double get totalOrderPrice =>
      orderedProducts.fold(0, (total, item) => total + item.totalPrice);
}
