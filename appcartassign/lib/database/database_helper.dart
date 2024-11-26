// lib/db/database_helper.dart
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();

  factory DatabaseHelper() => _instance;

  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'shopping_cart.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
      CREATE TABLE Products(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        price REAL,
        quantity INTEGER,
        discount TEXT
      )
    ''');

        await db.execute('''
      CREATE TABLE Cart(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        productId INTEGER,
        quantity INTEGER,
        FOREIGN KEY (productId) REFERENCES Products(id)
      )
    ''');

        await db.execute('''
      CREATE TABLE Transactions(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        products TEXT,
        total REAL,
        date TEXT
      )
    ''');

        // Insert sample products
        await db.insert('Products', {
          'name': 'Apple',
          'price': 100.0,
          'quantity': 50,
          'discount': 'Buy2Get1',
        });
        await db.insert('Products', {
          'name': 'Banana',
          'price': 50.0,
          'quantity': 100,
          'discount': null,
        });
        await db.insert('Products', {
          'name': 'Orange',
          'price': 80.0,
          'quantity': 80,
          'discount': 'Buy2Get1',
        });
      },
    );
  }

  // CRUD operations for Products
  Future<List<Map<String, dynamic>>> getProducts() async {
    final db = await database;
    return await db.query('Products');
  }

  // CRUD operations for Cart
  Future<List<Map<String, dynamic>>> getCartItems() async {
    final db = await database;
    return await db.query('Cart');
  }

  Future<void> addToCart(int productId, int quantity) async {
    final db = await database;
    // Check if the product is already in the cart
    var res =
        await db.query('Cart', where: 'productId = ?', whereArgs: [productId]);
    if (res.isNotEmpty) {
      // Update quantity
      int newQuantity = (res.first['quantity'] as int) + quantity;
      await db.update('Cart', {'quantity': newQuantity},
          where: 'productId = ?', whereArgs: [productId]);
    } else {
      // Insert new entry
      await db.insert('Cart', {'productId': productId, 'quantity': quantity});
    }
  }

  Future<void> updateCartItem(int productId, int quantity) async {
    final db = await database;
    if (quantity > 0) {
      await db.update('Cart', {'quantity': quantity},
          where: 'productId = ?', whereArgs: [productId]);
    } else {
      // Remove item if quantity is zero
      await db.delete('Cart', where: 'productId = ?', whereArgs: [productId]);
    }
  }

  Future<void> removeCartItem(int productId) async {
    final db = await database;
    await db.delete('Cart', where: 'productId = ?', whereArgs: [productId]);
  }

  Future<void> clearCart() async {
    final db = await database;
    await db.delete('Cart');
  }

  // CRUD operations for Transactions
  Future<void> addTransaction(String products, double total) async {
    final db = await database;
    await db.insert('Transactions', {
      'products': products,
      'total': total,
      'date': DateTime.now().toIso8601String(),
    });
  }

  Future<void> insertProduct(
      String name, double price, int quantity, String? discount) async {
    final db = await database;
    await db.insert('Products', {
      'name': name,
      'price': price,
      'quantity': quantity,
      'discount': discount,
    });
  }
}
