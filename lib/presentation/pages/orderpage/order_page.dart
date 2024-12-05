import 'package:flutter/material.dart';
import 'package:paloma365_task/presentation/pages/orderpage/order_page_vm.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({super.key, required this.tableId});

  final int tableId;

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  bool isLoading = true;

  late final vm = OrderPageVm(tableId: widget.tableId);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      vm.searchController.addListener(() => setState(() {}));
      vm.fetchAllProducts().then((_) {
        setState(() {
          isLoading = false;
        });
      });
    });
  }

  @override
  void dispose() {
    vm.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: ValueListenableBuilder(
            valueListenable: vm.table,
            builder: (context, table, child) {
              if (table == null) {
                return const Text('Order Page');
              }
              return Text('Order Page for ${table.name}');
            }),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator.adaptive())
          : Column(
              children: [
                ValueListenableBuilder(
                  valueListenable: vm.table,
                  builder: (context, value, child) {
                    if (value == null || vm.getTableProducts().isEmpty) {
                      return const SizedBox();
                    }

                    return Expanded(
                        child: ListView.builder(
                      itemCount: vm.getTableProducts().length,
                      itemBuilder: (context, index) {
                        final product = vm.getTableProducts()[index];
                        return ExpansionTile(
                          title: ListTile(
                            title: Text(product.productName),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.add_circle_outline),
                                  color: Colors.green,
                                  onPressed: () {
                                    //add quantity to the product
                                    vm.increaseProductQuantity(product);
                                  },
                                ),
                                SizedBox(
                                  width: 30,
                                  child: Text(
                                      product.quantity.toStringAsFixed(0),
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(fontSize: 20)),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.remove_circle_outline),
                                  color: Colors.red,
                                  onPressed: () {
                                    vm.decreaseProductQuantity(product);
                                  },
                                ),
                              ],
                            ),
                            subtitle: Text(
                                "${product.quantity.toInt()} * ${product.price.toString()} = ${(product.quantity * product.price).toString()}"),
                          ),
                          backgroundColor: Colors.blue.shade100,
                          childrenPadding:
                              const EdgeInsets.symmetric(horizontal: 12),
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.red,
                                        foregroundColor: Colors.white,
                                      ),
                                      onPressed: () {
                                        //remove product from the table
                                        vm.removeProductFromTable(product);
                                      },
                                      child: const Text("Remove product")),
                                ),
                                const SizedBox(width: 8),
                                //change price
                                Expanded(
                                  child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.blueGrey,
                                        foregroundColor: Colors.white,
                                      ),
                                      onPressed: () {
                                        showDialog(
                                            context: context,
                                            builder: (context) {
                                              final controller =
                                                  TextEditingController(
                                                      text: product.price
                                                          .toString());
                                              return AlertDialog(
                                                title:
                                                    const Text("Change price"),
                                                content: TextField(
                                                  controller: controller,
                                                  keyboardType:
                                                      TextInputType.number,
                                                  decoration:
                                                      const InputDecoration(
                                                          labelText: "Price"),
                                                ),
                                                actions: [
                                                  TextButton(
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                      },
                                                      child:
                                                          const Text("Cancel")),
                                                  TextButton(
                                                      onPressed: () {
                                                        vm.updateProductPrice(
                                                            productId: product
                                                                .productId,
                                                            newPrice:
                                                                double.parse(
                                                                    controller
                                                                        .text));
                                                        Navigator.pop(context);
                                                      },
                                                      child:
                                                          const Text("Change")),
                                                ],
                                              );
                                            });
                                      },
                                      child: const Text("Change price")),
                                ),
                              ],
                            )
                          ],
                        );
                      },
                    ));
                  },
                ),
                const Divider(thickness: 3),
                ListTile(title: Text("Total products: ${vm.products.length}")),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: TextField(
                    controller: vm.searchController,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Search product by name"),
                  ),
                ),
                //Categories
                Expanded(
                  child: ListView.builder(
                    itemCount: vm.categories.length,
                    itemBuilder: (context, index) {
                      final category = vm.categories[index];
                      final products = vm.getProductsByCategory(category);
                      if (products.isEmpty) return const SizedBox();
                      return Card(
                        child: ExpansionTile(
                          title: Text(category.name),
                          children: [
                            for (final product in products)
                              InkWell(
                                onTap: () {
                                  vm.addProductToTable(product);
                                },
                                child: Card(
                                  color: Colors.white,
                                  child: ListTile(
                                    title: Text(product.name),
                                    trailing: Text(
                                      product.price.toString(),
                                      style: const TextStyle(fontSize: 20),
                                    ),
                                    subtitle: Text(
                                        "Stock: ${product.stockQuantity.toStringAsFixed(0)}",
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w500)),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
