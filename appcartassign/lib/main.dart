// lib/main.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controllers/cart_controller.dart';
import 'controllers/product_controller.dart';
import 'controllers/transcation_controller.dart';
import 'screens/home_screen.dart';
import 'screens/cart_screen.dart';
import 'screens/checkout_screen.dart';

void main() {
  // Initialize Controllers
  Get.put(ProductController());
  Get.put(CartController());
  Get.put(TransactionController());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Shopping Cart App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
      getPages: [
        GetPage(name: '/', page: () => HomeScreen()),
        GetPage(name: '/cart', page: () => CartScreen()),
        GetPage(name: '/checkout', page: () => CheckoutScreen()),
      ],
    );
  }
}
