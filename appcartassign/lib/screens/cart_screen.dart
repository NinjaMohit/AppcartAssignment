// lib/screens/cart_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/cart_controller.dart';
import '../controllers/product_controller.dart';
import 'checkout_screen.dart';

class CartScreen extends StatelessWidget {
  CartScreen({super.key});

  final CartController cartController = Get.find();
  final ProductController productController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Your Cart',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 226, 193, 232),
      ),
      body: Obx(() {
        if (cartController.cartItems.isEmpty) {
          return const Center(child: Text('Your cart is empty.'));
        }
        return Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: cartController.cartItems.length,
                itemBuilder: (context, index) {
                  var cartItem = cartController.cartItems[index];
                  var product = productController.products
                      .firstWhere((p) => p['id'] == cartItem['productId']);
                  return Card(
                    color: const Color.fromARGB(255, 230, 237, 233),
                    margin: const EdgeInsets.all(8.0),
                    child: ListTile(
                      title: Text(
                        product['name'],
                        style: const TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.w500),
                      ),
                      subtitle: Text(
                        'Price: \$${product['price']}',
                        style: const TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w400),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove),
                            onPressed: () {
                              int newQty = cartItem['quantity'] - 1;
                              cartController.updateQuantity(
                                  product['id'], newQty);
                            },
                          ),
                          Text(
                            '${cartItem['quantity']}',
                            style: const TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w400),
                          ),
                          IconButton(
                            icon: const Icon(Icons.add),
                            onPressed: () {
                              if (cartItem['quantity'] < product['quantity']) {
                                int newQty = cartItem['quantity'] + 1;
                                cartController.updateQuantity(
                                    product['id'], newQty);
                              } else {
                                Get.snackbar(
                                    'Error', 'No more stock available.');
                              }
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              cartController.removeItem(product['id']);
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const Divider(),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 226, 193, 232),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(width: 1)),
                child: Column(
                  children: [
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Discounts Applied:',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        cartController.discountDetails,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        'Total: \$${cartController.total.toStringAsFixed(2)}',
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      child: const Text('Buy Now'),
                      onPressed: () {
                        Get.to(() => CheckoutScreen());
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
