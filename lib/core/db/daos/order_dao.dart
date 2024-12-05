import 'package:paloma365_task/core/db/models/order.dart';
import 'package:sqflite/sqflite.dart';

class OrderDao {
  final Database db;

  OrderDao(this.db);

  Future<List<OrderMd>> getAllOrders() async {
    const String query = '''
    SELECT 
      o.id, 
      o.table_id, 
      t.name AS table_name, 
      o.order_date, 
      o.total_amount, 
      o.status
    FROM orders o
    LEFT JOIN restaurant_tables t ON o.table_id = t.id
  ''';

    final List<Map<String, dynamic>> maps = await db.rawQuery(query);

    return maps.map((map) => OrderMd.fromMap(map)).toList();
  }

  Future<OrderMd?> getOrderById(int id) async {
    final List<Map<String, dynamic>> maps = await db.query(
      'orders',
      where: 'id = ?',
      whereArgs: [id],
    );
    return maps.isNotEmpty ? OrderMd.fromMap(maps.first) : null;
  }

  Future<int> insertOrder(OrderMd order) async {
    return await db.insert('orders', order.toMap());
  }

  Future<int> updateOrder(OrderMd order) async {
    return await db.update(
      'orders',
      order.toMap(),
      where: 'id = ?',
      whereArgs: [order.id],
    );
  }

  Future<int> deleteOrder(int id) async {
    return await db.delete(
      'orders',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<OrderMd>> getOrdersByStatus(String status) async {
    final List<Map<String, dynamic>> maps = await db.query(
      'orders',
      where: 'status = ?',
      whereArgs: [status],
    );
    return maps.map((map) => OrderMd.fromMap(map)).toList();
  }

  Future<int> updateOrderStatus(int id, String status) async {
    return await db.update(
      'orders',
      {'status': status},
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
