// lib/screens/checkout_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/transcation_controller.dart';

class CheckoutScreen extends StatelessWidget {
  final TransactionController transactionController = Get.find();
  CheckoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Checkout',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 226, 193, 232),
      ),
      body: Center(
        child: ElevatedButton(
          child: const Text('Confirm Purchase'),
          onPressed: () {
            transactionController.checkout();
            Get.offAllNamed('/');
          },
        ),
      ),
    );
  }
}
