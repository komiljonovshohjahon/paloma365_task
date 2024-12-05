import 'package:paloma365_task/core/db/models/order.dart';
import 'package:paloma365_task/core/di.dart';

class OrdersPageVm {
  final List<OrderMd> orders = [];

  Future<void> fetchAllOrders() async {
    orders.clear();
    orders.addAll(await Di().db.orderDao.getAllOrders());
  }
}
