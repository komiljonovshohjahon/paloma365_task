import 'package:flutter/material.dart';
import 'package:paloma365_task/presentation/components/app_drawer.dart';
import 'package:paloma365_task/presentation/pages/orders/orders_vm.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  bool isLoading = true;

  final vm = OrdersPageVm();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      vm.fetchAllOrders().then((_) {
        setState(() {
          isLoading = false;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        leading: Builder(builder: (context) {
          return IconButton(
              onPressed: Scaffold.of(context).openDrawer,
              icon: const Icon(Icons.menu));
        }),
        title: const Text('Orders'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator.adaptive())
          : ListView.builder(
              itemCount: vm.orders.length,
              itemBuilder: (context, index) {
                final order = vm.orders[index];
                return Card(
                  child: ListTile(
                      leading: Text("#${order.id}",
                          style: const TextStyle(fontSize: 16)),
                      title: Text(order.tableName?.toString() ?? "-"),
                      subtitle: Text(order.status),
                      trailing: Text(
                        order.totalAmount.toString(),
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      )),
                );
              }),
    );
  }
}
