// lib/controllers/cart_controller.dart
import 'package:get/get.dart';
import '../database/database_helper.dart';
import 'product_controller.dart';

class CartController extends GetxController {
  var cartItems = <Map<String, dynamic>>[].obs;
  final dbHelper = DatabaseHelper();
  final ProductController productController = Get.find();

  @override
  void onInit() {
    super.onInit();
    fetchCartItems();
  }

  void fetchCartItems() async {
    var fetchedCart = await dbHelper.getCartItems();
    cartItems.assignAll(fetchedCart);
  }

  void addToCart(int productId) async {
    await dbHelper.addToCart(productId, 1);
    fetchCartItems();
  }

  void updateQuantity(int productId, int quantity) async {
    await dbHelper.updateCartItem(productId, quantity);
    fetchCartItems();
  }

  void removeItem(int productId) async {
    await dbHelper.removeCartItem(productId);
    fetchCartItems();
  }

  void clearCart() async {
    await dbHelper.clearCart();
    fetchCartItems();
  }

  // Calculate total with discounts
  double get total {
    double total = 0.0;
    for (var item in cartItems) {
      var product = productController.products
          .firstWhere((p) => p['id'] == item['productId']);
      double price = product['price'];
      int quantity = item['quantity'];
      String? discount = product['discount'];

      // Apply "Buy 2 Get 1 Free" if applicable
      if (discount == 'Buy2Get1') {
        int freeItems = quantity ~/ 3;
        total += price * (quantity - freeItems);
      } else {
        total += price * quantity;
      }
    }

    // Apply "10% off on orders above $1000"
    if (total > 1000) {
      total = total * 0.9;
    }

    return total;
  }

  // Get discount details
  String get discountDetails {
    String details = '';
    double discount = 0.0;

    for (var item in cartItems) {
      var product = productController.products
          .firstWhere((p) => p['id'] == item['productId']);
      double price = product['price'];
      int quantity = item['quantity'];
      String? discountType = product['discount'];

      if (discountType == 'Buy2Get1') {
        int freeItems = quantity ~/ 3;
        discount += price * freeItems;
        details += '${product['name']}: Buy 2 Get 1 Free\n';
      }
    }

    double subtotal = 0.0;
    for (var item in cartItems) {
      var product = productController.products
          .firstWhere((p) => p['id'] == item['productId']);
      subtotal += product['price'] * item['quantity'];
    }

    if (subtotal > 1000) {
      double tenPercent = subtotal * 0.1;
      discount += tenPercent;
      details += '10% off on orders above \$1000\n';
    }

    return details.isEmpty ? 'No Discounts Applied' : details;
  }
}
