import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  final String id;
  final String name;
  final String category;
  final double price;
  final int stock;
  final String sellerName;
  final String businessName;
  final String imageUrl;
  final DateTime createdAt;
  final int minStock;
  final double productionCost;
  final double vipPrice;
  final double specialPrice;

  Product({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.stock,
    required this.sellerName,
    required this.businessName,
    required this.imageUrl,
    required this.createdAt,
    required this.minStock,
    required this.productionCost,
    required this.vipPrice,
    required this.specialPrice,
  });

  factory Product.fromFirestore(Map<String, dynamic> data, String id) {
    String image = '';
    if (data['images'] != null && data['images'] is List && data['images'].isNotEmpty) {
      image = data['images'][0].toString();
    }

    DateTime created;
    if (data['createdAt'] is Timestamp) {
      created = (data['createdAt'] as Timestamp).toDate();
    } else {
      created = DateTime.now();
    }

    double toDouble(dynamic value) {
      if (value == null) return 0.0;
      if (value is int) return value.toDouble();
      if (value is double) return value;
      return 0.0;
    }

    int toInt(dynamic value) {
      if (value == null) return 0;
      if (value is int) return value;
      if (value is double) return value.toInt();
      return 0;
    }

    return Product(
      id: id,
      name: data['name']?.toString() ?? '',
      category: data['category']?.toString() ?? '',

      price: toDouble(data['sellingPrice']),

      stock: toInt(data['stock']),

      sellerName: data['sellerName']?.toString() ?? 'Unknown Seller',

      businessName: data['businessName']?.toString() ?? 'Unknown Business',

      imageUrl: image,

      createdAt: created,

      minStock: toInt(data['minStock']),

      productionCost: toDouble(data['productionCost']),

      vipPrice: toDouble(data['vipPrice']),

      specialPrice: toDouble(data['specialPrice']),
    );
  }
}