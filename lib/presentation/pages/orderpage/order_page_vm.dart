import 'package:flutter/material.dart';
import 'package:paloma365_task/core/db/models/product.dart';
import 'package:paloma365_task/core/db/models/table.dart';
import 'package:paloma365_task/core/di.dart';

class OrderPageVm {
  final int tableId;

  OrderPageVm({required this.tableId});

  final List<CategoryMd> categories = [];
  final List<Product> products = [];

  final ValueNotifier<RestaurantTable?> table = ValueNotifier(null);

  final TextEditingController searchController = TextEditingController();

  void dispose() {
    searchController.dispose();
  }

  Future<void> fetchAllProducts() async {
    categories.clear();
    products.clear();
    await findTable();
    categories.addAll(await Di().db.categoryDao.getAllCategories());
    products.addAll(await Di().db.productDao.getAllProducts());
  }

  Future<void> findTable() async {
    table.value = await Di().db.tableDao.getTableById(tableId);
  }

  List<Product> getProductsByCategory(CategoryMd category) {
    return products.where((product) {
      final result = product.categoryId == category.id;

      if (searchController.text.isNotEmpty) {
        return result &&
            product.name
                .toLowerCase()
                .contains(searchController.text.toLowerCase());
      }

      return result;
    }).toList();
  }

  List<TableOrderItem> getTableProducts() {
    return table.value?.orderedProducts ?? [];
  }

  void addProductToTable(Product product) async {
    if (getTableProducts().any((element) => element.productId == product.id)) {
      increaseProductQuantity(getTableProducts()
          .firstWhere((element) => element.productId == product.id));

      return;
    }
    //add product to the table
    await Di().db.tableDao.addProductToTable(
          tableId: tableId,
          productId: product.id!,
          productName: product.name,
          quantity: 1,
          price: product.price,
        );
    await findTable();
  }

  Future<void> increaseProductQuantity(TableOrderItem product) async {
    //increase product quantity
    await Di().db.tableDao.updateOrderItemQuantity(
        tableId, product.productId, product.quantity + 1);
    await findTable();
  }

  void decreaseProductQuantity(TableOrderItem product) async {
    //decrease product quantity
    if (product.quantity == 1) {
      await removeProductFromTable(product);
    } else {
      await Di().db.tableDao.updateOrderItemQuantity(
          tableId, product.productId, product.quantity - 1);
    }
    await findTable();
  }

  Future<void> removeProductFromTable(TableOrderItem product) async {
    //remove product from the table
    await Di().db.tableDao.removeProductFromTable(
          tableId,
          product.productId,
        );
    await findTable();
  }

  Future<void> updateProductPrice(
      {required int productId, required double newPrice}) async {
    //update product price
    await Di().db.tableDao.updateOrderItemPrice(tableId, productId, newPrice);
    await findTable();
  }
}
