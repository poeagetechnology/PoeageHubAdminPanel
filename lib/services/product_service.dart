import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product.dart';

class ProductService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  ///  Fetch ALL products across sellers/categories
  Stream<List<Product>> getAllProducts() {
    return _firestore
        .collectionGroup('items')
        .snapshots()
        .map((snapshot) {

      print("📦 Total products fetched: ${snapshot.docs.length}");

      List<Product> products = [];

      for (var doc in snapshot.docs) {
        try {
          final data = doc.data();
          products.add(Product.fromFirestore(data, doc.id));
        } catch (e) {
          print("❌ Error parsing product ${doc.id}: $e");
        }
      }

      return products;
    }).handleError((error) {
      print("❌ Firestore fetch error: $error");
      return <Product>[];
    });
  }

  /// Fetch only LOW STOCK products
  Stream<List<Product>> getLowStockProducts() {
    return getAllProducts().map((products) {

      final lowStockProducts = products
          .where((product) => product.stock <= product.minStock)
          .toList();

      print("⚠ Low stock products: ${lowStockProducts.length}");

      return lowStockProducts;
    });
  }
}