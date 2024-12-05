import 'package:paloma365_task/core/db/models/order.dart';
import 'package:paloma365_task/core/db/models/table.dart';
import 'package:paloma365_task/core/di.dart';

class HomepageVm {
  final List<RestaurantTable> tables = [];

  Future<void> fetchAllTables() async {
    tables.clear();
    tables.addAll(await Di().db.tableDao.getAllTables());
  }

  Future<void> payTable({
    required RestaurantTable table,
  }) async {
    await Di().db.orderDao.insertOrder(OrderMd(
          tableId: table.id!,
          totalAmount: table.totalOrderPrice,
        ));
    for (var product in table.orderedProducts) {
      await Di()
          .db
          .productDao
          .updateProductStock(product.productId, -product.quantity);
    }
    await Di().db.tableDao.clearTableProducts(table.id!);
    await fetchAllTables();
  }
}
