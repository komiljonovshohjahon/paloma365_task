import 'package:flutter/material.dart';
import 'package:paloma365_task/presentation/components/app_drawer.dart';
import 'package:paloma365_task/presentation/pages/homepage/homepage_vm.dart';
import 'package:paloma365_task/presentation/pages/orderpage/order_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isLoading = true;

  final vm = HomepageVm();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      vm.fetchAllTables().then((_) {
        setState(() {
          isLoading = false;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        leading: Builder(builder: (context) {
          return IconButton(
              onPressed: Scaffold.of(context).openDrawer,
              icon: const Icon(Icons.menu));
        }),
        title: const Text('Paloma365'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator.adaptive())
          : Wrap(
              children: [
                for (final table in vm.tables)
                  InkWell(
                    onTap: () {
                      Navigator.of(context)
                          .push(MaterialPageRoute(
                              builder: (_) => OrderPage(tableId: table.id!)))
                          .then((value) => vm
                              .fetchAllTables()
                              .then((value) => setState(() {})));
                    },
                    child: Card(
                      color: table.orderedProducts.isEmpty
                          ? null
                          : Colors.blue.shade200,
                      child: SizedBox(
                        width: size.width / 2.2,
                        height: size.height / 7,
                        child: Center(
                          child: ListTile(
                            title: Text(table.name),
                            subtitle: Text('Total: ${table.totalOrderPrice}'),
                            trailing: table.orderedProducts.isNotEmpty
                                ? IconButton.filled(
                                    color: Colors.white,
                                    onPressed: () async {
                                      //show prompt dialog
                                      final res = await showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            title: const Text('Close Table'),
                                            content: const Text(
                                                'Are you sure you want to close this table?'),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: const Text('Cancel'),
                                              ),
                                              ElevatedButton(
                                                onPressed: () {
                                                  Navigator.of(context)
                                                      .pop(true);
                                                },
                                                child: const Text('Close'),
                                              ),
                                            ],
                                          );
                                        },
                                      );

                                      if (res == true) {
                                        vm.payTable(table: table).then((_) {
                                          setState(() {});
                                        });
                                      }
                                    },
                                    icon: const Icon(
                                        Icons.shopping_cart_checkout_rounded))
                                : null,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
    );
  }
}
