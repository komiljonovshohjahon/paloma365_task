// Data Access Object for Restaurant Tables
import 'dart:convert';

import 'package:paloma365_task/core/db/models/table.dart';
import 'package:sqflite/sqflite.dart';

class RestaurantTableDao {
  final Database db;

  RestaurantTableDao(this.db);

  Future<List<RestaurantTable>> getAllTables() async {
    final List<Map<String, dynamic>> maps = await db.query('restaurant_tables');
    return maps.map((map) => RestaurantTable.fromMap(map)).toList();
  }

  Future<RestaurantTable?> getTableById(int id) async {
    final List<Map<String, dynamic>> maps = await db.query(
      'restaurant_tables',
      where: 'id = ?',
      whereArgs: [id],
    );
    return maps.isNotEmpty ? RestaurantTable.fromMap(maps.first) : null;
  }

  Future<void> addProductToTable({
    required int tableId,
    required int productId,
    required String productName,
    required double quantity,
    required double price,
    String? notes,
  }) async {
    final table = await getTableById(tableId);
    if (table != null) {
      final newOrderItem = TableOrderItem(
        productId: productId,
        productName: productName,
        quantity: quantity,
        price: price,
        notes: notes,
      );

      final updatedOrderedProducts = [...table.orderedProducts, newOrderItem];

      await db.update(
        'restaurant_tables',
        {
          'ordered_products': jsonEncode(
              updatedOrderedProducts.map((e) => e.toJson()).toList()),
        },
        where: 'id = ?',
        whereArgs: [tableId],
      );
    }
  }

  Future<void> removeProductFromTable(int tableId, int productId) async {
    final table = await getTableById(tableId);
    if (table != null) {
      final updatedOrderedProducts =
          List<TableOrderItem>.from(table.orderedProducts)
            ..removeWhere((element) => element.productId == productId);

      await db.update(
        'restaurant_tables',
        {
          'ordered_products': updatedOrderedProducts.isNotEmpty
              ? jsonEncode(
                  updatedOrderedProducts.map((e) => e.toJson()).toList())
              : '',
        },
        where: 'id = ?',
        whereArgs: [tableId],
      );
    }
  }

  Future<void> clearTableProducts(int tableId) async {
    await db.update(
      'restaurant_tables',
      {'ordered_products': ''},
      where: 'id = ?',
      whereArgs: [tableId],
    );
  }

  Future<void> updateTableStatus(int tableId, bool isClosed) async {
    await db.update(
      'restaurant_tables',
      {'is_closed': isClosed ? 1 : 0},
      where: 'id = ?',
      whereArgs: [tableId],
    );
  }

  Future<void> updateOrderItemQuantity(
      int tableId, int productId, double quantity) async {
    final table = await getTableById(tableId);
    if (table != null) {
      final updatedOrderedProducts = table.orderedProducts
          .map((orderItem) => orderItem.productId == productId
              ? orderItem.copyWith(quantity: quantity)
              : orderItem)
          .toList();

      await db.update(
        'restaurant_tables',
        {
          'ordered_products': jsonEncode(
              updatedOrderedProducts.map((e) => e.toJson()).toList()),
        },
        where: 'id = ?',
        whereArgs: [tableId],
      );
    }
  }

  Future<void> updateOrderItemPrice(
      int tableId, int productId, double price) async {
    final table = await getTableById(tableId);
    if (table != null) {
      final updatedOrderedProducts = table.orderedProducts
          .map((orderItem) => orderItem.productId == productId
              ? orderItem.copyWith(price: price)
              : orderItem)
          .toList();

      await db.update(
        'restaurant_tables',
        {
          'ordered_products': jsonEncode(
              updatedOrderedProducts.map((e) => e.toJson()).toList()),
        },
        where: 'id = ?',
        whereArgs: [tableId],
      );
    }
  }
}
