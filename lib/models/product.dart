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
    return Product(
      id: id,
      name: data['name'] ?? '',
      category: data['category'] ?? '',
      price: (data['sellingPrice'] ?? 0).toDouble(),
      stock: data['stock'] ?? 0,
      sellerName: data['sellerName'] ?? 'Unknown Seller',
      businessName: data['businessName'] ?? 'Unknown Business',
      imageUrl: (data['images'] != null && data['images'].isNotEmpty)
          ? data['images'][0]
          : '',
      createdAt: (data['createdAt'] != null)
          ? DateTime.parse(data['createdAt'])
          : DateTime.now(),
      minStock: data['minStock'] ?? 0,
      productionCost: (data['productionCost'] ?? 0).toDouble(),
      vipPrice: (data['vipPrice'] ?? 0).toDouble(),
      specialPrice: (data['specialPrice'] ?? 0).toDouble(),
    );
  }
}