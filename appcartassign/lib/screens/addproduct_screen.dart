import 'package:appcartassign/controllers/product_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../database/database_helper.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  _AddProductScreenState createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController discountController = TextEditingController();

  ProductController productController = Get.put(ProductController());
  void _addProduct() async {
    String name = nameController.text.trim();
    double? price = double.tryParse(priceController.text.trim());
    int? quantity = int.tryParse(quantityController.text.trim());
    String? discount = discountController.text.trim().isNotEmpty
        ? discountController.text.trim()
        : null;

    if (name.isNotEmpty && price != null && quantity != null) {
      await DatabaseHelper().insertProduct(name, price, quantity, discount);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Product added successfully!')),
      );
      // Clear the input fields
      Get.toNamed('/');
      nameController.clear();
      priceController.clear();
      quantityController.clear();
      discountController.clear();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all the required fields.')),
      );
    }
    productController.fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add Product',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Product Name',
                labelStyle: const TextStyle(
                    color: Colors.teal, fontWeight: FontWeight.bold),
                prefixIcon: const Icon(Icons.shopping_bag, color: Colors.teal),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: const BorderSide(color: Colors.teal, width: 2),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: const BorderSide(color: Colors.grey, width: 1),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                fillColor: Colors.teal.withOpacity(0.05),
                filled: true, // Adds a background color
              ),
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: priceController,
              decoration: InputDecoration(
                labelText: 'Price',
                labelStyle: const TextStyle(
                    color: Colors.teal, fontWeight: FontWeight.bold),
                prefixIcon: const Icon(Icons.price_change, color: Colors.teal),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: const BorderSide(color: Colors.teal, width: 2),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: const BorderSide(color: Colors.grey, width: 1),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                fillColor: Colors.teal.withOpacity(0.05),
                filled: true, // Adds a background color
              ),
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: quantityController,
              decoration: InputDecoration(
                labelText: 'Quantity',
                labelStyle: const TextStyle(
                    color: Colors.teal, fontWeight: FontWeight.bold),
                prefixIcon: const Icon(Icons.price_change, color: Colors.teal),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: const BorderSide(color: Colors.teal, width: 2),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: const BorderSide(color: Colors.grey, width: 1),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                fillColor: Colors.teal.withOpacity(0.05),
                filled: true, // Adds a background color
              ),
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: discountController,
              decoration: InputDecoration(
                labelText: 'Discount',
                labelStyle: const TextStyle(
                    color: Colors.teal, fontWeight: FontWeight.bold),
                prefixIcon: const Icon(Icons.price_change, color: Colors.teal),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: const BorderSide(color: Colors.teal, width: 2),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: const BorderSide(color: Colors.grey, width: 1),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                fillColor: Colors.teal.withOpacity(0.05),
                filled: true, // Adds a background color
              ),
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _addProduct,
              child: const Text('Add Product'),
            ),
          ],
        ),
      ),
    );
  }
}
