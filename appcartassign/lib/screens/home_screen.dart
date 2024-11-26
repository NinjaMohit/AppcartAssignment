// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/product_controller.dart';
import '../controllers/cart_controller.dart';
import 'addproduct_screen.dart';
import 'cart_screen.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final ProductController productController = Get.find();
  final CartController cartController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Products',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color.fromARGB(255, 226, 193, 232),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.shopping_cart,
              size: 40,
              weight: 10,
            ),
            onPressed: () {
              Get.to(() => CartScreen());
            },
          )
        ],
      ),
      body: Obx(() {
        if (productController.products.isEmpty) {
          return const Center(child: Text('No products available.'));
        }
        return ListView.builder(
          itemCount: productController.products.length,
          itemBuilder: (context, index) {
            var product = productController.products[index];
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
                  'Price: \$${product['price']} \nStock: ${product['quantity']},',
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w400),
                ),
                trailing: ElevatedButton(
                  child: const Text('Add to Cart'),
                  onPressed: () {
                    if (product['quantity'] > 0) {
                      cartController.addToCart(product['id']);
                      Get.snackbar(
                          snackPosition:
                              SnackPosition.BOTTOM, // Position at the bottom

                          'Added',
                          '${product['name']} added to cart.');
                    } else {
                      Get.snackbar(
                          snackPosition:
                              SnackPosition.BOTTOM, // Position at the bottom
                          'Error',
                          'Product out of stock.');
                    }
                  },
                ),
              ),
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton.large(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddProductScreen()),
          );
        },
        child: const Text(
          "Add Data",
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
