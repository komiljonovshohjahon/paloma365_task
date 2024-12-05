// Data Access Object for Categories
import 'package:paloma365_task/core/db/models/product.dart';
import 'package:sqflite/sqflite.dart';

class CategoryDao {
  final Database db;

  CategoryDao(this.db);

  Future<List<CategoryMd>> getAllCategories() async {
    final List<Map<String, dynamic>> maps = await db.query('categories');
    return maps.map((map) => CategoryMd.fromMap(map)).toList();
  }

  Future<CategoryMd?> getCategoryById(int id) async {
    final List<Map<String, dynamic>> maps = await db.query(
      'categories',
      where: 'id = ?',
      whereArgs: [id],
    );
    return maps.isNotEmpty ? CategoryMd.fromMap(maps.first) : null;
  }

  Future<int> insertCategory(CategoryMd category) async {
    return await db.insert('categories', category.toMap());
  }

  Future<int> updateCategory(CategoryMd category) async {
    return await db.update(
      'categories',
      category.toMap(),
      where: 'id = ?',
      whereArgs: [category.id],
    );
  }
}

class ProductDao {
  final Database db;

  ProductDao(this.db);

  Future<List<Product>> getAllProducts() async {
    final List<Map<String, dynamic>> maps = await db.query('products');
    return maps.map((map) => Product.fromMap(map)).toList();
  }

  Future<List<Product>> getProductsByCategory(int categoryId) async {
    final List<Map<String, dynamic>> maps = await db.query(
      'products',
      where: 'category_id = ?',
      whereArgs: [categoryId],
    );
    return maps.map((map) => Product.fromMap(map)).toList();
  }

  Future<Product?> getProductById(int id) async {
    final List<Map<String, dynamic>> maps = await db.query(
      'products',
      where: 'id = ?',
      whereArgs: [id],
    );
    return maps.isNotEmpty ? Product.fromMap(maps.first) : null;
  }

  Future<List<Product>> getAvailableProducts() async {
    final List<Map<String, dynamic>> maps = await db.query(
      'products',
      where: 'is_available = 1 AND stock_quantity > 0',
    );
    return maps.map((map) => Product.fromMap(map)).toList();
  }

  Future<int> insertProduct(Product product) async {
    return await db.insert('products', product.toMap());
  }

  Future<int> updateProduct(Product product) async {
    return await db.update(
      'products',
      product.toMap(),
      where: 'id = ?',
      whereArgs: [product.id],
    );
  }

  Future<void> updateProductStock(int productId, double quantityChange) async {
    final product = await getProductById(productId);
    if (product != null) {
      final newStockQuantity = product.stockQuantity + quantityChange;
      await db.update(
        'products',
        {
          'stock_quantity': newStockQuantity,
          'is_available': newStockQuantity > 0 ? 1 : 0
        },
        where: 'id = ?',
        whereArgs: [productId],
      );
    }
  }

  Future<List<Map<String, dynamic>>> getProductsWithCategories() async {
    return await db.rawQuery('''
      SELECT 
        p.id, 
        p.name, 
        p.price, 
        p.description, 
        p.stock_quantity, 
        c.name AS category_name
      FROM products p
      LEFT JOIN categories c ON p.category_id = c.id
    ''');
  }
}
