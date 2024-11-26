// lib/controllers/product_controller.dart
import 'package:get/get.dart';
import '../database/database_helper.dart';

class ProductController extends GetxController {
  var products = <Map<String, dynamic>>[].obs;
  final dbHelper = DatabaseHelper();

  @override
  void onInit() {
    super.onInit();
    fetchProducts();
  }

  void fetchProducts() async {
    var fetchedProducts = await dbHelper.getProducts();
    products.assignAll(fetchedProducts);
  }
}
