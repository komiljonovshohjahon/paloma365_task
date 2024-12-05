class CategoryMd {
  final int? id;
  final String name;
  final String? description;

  CategoryMd({
    this.id,
    required this.name,
    this.description,
  });

  factory CategoryMd.fromMap(Map<String, dynamic> map) {
    return CategoryMd(
      id: map['id'],
      name: map['name'],
      description: map['description'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
    };
  }
}

class Product {
  final int? id;
  final String name;
  final int? categoryId;
  final double price;
  final String? description;
  final bool isAvailable;
  final double stockQuantity;

  Product({
    this.id,
    required this.name,
    this.categoryId,
    required this.price,
    this.description,
    this.isAvailable = true,
    this.stockQuantity = 0,
  });

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'],
      name: map['name'],
      categoryId: map['category_id'],
      price: map['price'],
      description: map['description'],
      isAvailable: map['is_available'] == 1,
      stockQuantity: map['stock_quantity'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'category_id': categoryId,
      'price': price,
      'description': description,
      'is_available': isAvailable ? 1 : 0,
      'stock_quantity': stockQuantity,
    };
  }
}
