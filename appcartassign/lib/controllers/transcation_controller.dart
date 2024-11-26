// lib/controllers/transaction_controller.dart
import 'package:get/get.dart';
import '../database/database_helper.dart';
import 'cart_controller.dart';
import 'product_controller.dart';
import 'dart:convert';

class TransactionController extends GetxController {
  final dbHelper = DatabaseHelper();
  final CartController cartController = Get.find();
  final ProductController productController = Get.find();

  void checkout() async {
    // Prepare transaction details
    List<Map<String, dynamic>> transactionProducts = [];
    for (var item in cartController.cartItems) {
      var product = productController.products
          .firstWhere((p) => p['id'] == item['productId']);
      transactionProducts.add({
        'id': product['id'],
        'name': product['name'],
        'price': product['price'],
        'quantity': item['quantity'],
      });
    }

    String productsJson = jsonEncode(transactionProducts);
    double totalAmount = cartController.total;

    // Store transaction
    await dbHelper.addTransaction(productsJson, totalAmount);

    // Optionally, update product stock
    for (var item in cartController.cartItems) {
      var product = productController.products
          .firstWhere((p) => p['id'] == item['productId']);
      int newQuantity = product['quantity'] - item['quantity'];
      await dbHelper.database.then((db) {
        db.update('Products', {'quantity': newQuantity},
            where: 'id = ?', whereArgs: [product['id']]);
      });
    }

    // Clear cart
    cartController.clearCart();

    // Refresh products
    productController.fetchProducts();

    Get.snackbar('Success', 'Purchase completed successfully!');
  }
}
