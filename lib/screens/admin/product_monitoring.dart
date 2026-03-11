import 'package:flutter/material.dart';
import '../../services/product_service.dart';
import '../../models/product.dart';

class ProductMonitoringScreen extends StatefulWidget {
  const ProductMonitoringScreen({super.key});

  @override
  State<ProductMonitoringScreen> createState() =>
      _ProductMonitoringScreenState();
}

class _ProductMonitoringScreenState extends State<ProductMonitoringScreen> {
  final ProductService _productService = ProductService();

  String searchQuery = "";
  int? expandedIndex;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff8f8fa),

      appBar: AppBar(
        title: const Text("Product Monitoring"),
        backgroundColor: Colors.deepPurple,
        elevation: 0,
      ),

      body: Column(
        children: [

          /// SEARCH BAR
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Search product...",
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value.toLowerCase();
                });
              },
            ),
          ),

          /// PRODUCT LIST
          Expanded(
            child: StreamBuilder<List<Product>>(
              stream: _productService.getAllProducts(),
              builder: (context, snapshot) {

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData) {
                  return const Center(child: Text("No products found"));
                }

                final allProducts = snapshot.data!;

                final products = allProducts.where((product) {
                  return product.name
                      .toLowerCase()
                      .contains(searchQuery);
                }).toList();

                if (products.isEmpty) {
                  return const Center(
                    child: Text(
                      "No matching products",
                      style: TextStyle(fontSize: 16),
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: products.length,
                  itemBuilder: (context, index) {

                    final product = products[index];

                    bool lowStock = product.stock <= product.minStock;
                    bool expanded = expandedIndex == index;

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          expandedIndex =
                          expandedIndex == index ? null : index;
                        });
                      },

                      child: Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            )
                          ],
                        ),

                        child: Column(
                          children: [

                            /// TOP PRODUCT ROW
                            Row(
                              children: [

                                /// PRODUCT IMAGE
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: product.imageUrl.isNotEmpty
                                      ? Image.network(
                                    product.imageUrl,
                                    width: 75,
                                    height: 75,
                                    fit: BoxFit.cover,
                                  )
                                      : Container(
                                    width: 75,
                                    height: 75,
                                    color: Colors.grey[300],
                                    child: const Icon(Icons.image),
                                  ),
                                ),

                                const SizedBox(width: 14),

                                /// PRODUCT DETAILS
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [

                                      /// NAME + EXPAND ICON
                                      Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Text(
                                              product.name,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ),
                                          Icon(
                                            expanded
                                                ? Icons.keyboard_arrow_up
                                                : Icons.keyboard_arrow_down,
                                          )
                                        ],
                                      ),

                                      const SizedBox(height: 4),

                                      Text(
                                        "Category: ${product.category}",
                                        style: const TextStyle(
                                          fontSize: 13,
                                          color: Colors.grey,
                                        ),
                                      ),

                                      const SizedBox(height: 4),

                                      Text(
                                        "Seller: ${product.sellerName}",
                                        style: const TextStyle(
                                          fontSize: 13,
                                          color: Colors.grey,
                                        ),
                                      ),

                                      Text(
                                        "Business: ${product.businessName}",
                                        style: const TextStyle(
                                          fontSize: 13,
                                          color: Colors.grey,
                                        ),
                                      ),

                                      const SizedBox(height: 8),

                                      Row(
                                        children: [

                                          /// PRICE
                                          Text(
                                            "₹${product.price}",
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.green,
                                              fontSize: 15,
                                            ),
                                          ),

                                          const SizedBox(width: 16),

                                          /// STOCK BADGE
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10, vertical: 4),
                                            decoration: BoxDecoration(
                                              color: lowStock
                                                  ? Colors.red.withOpacity(0.15)
                                                  : Colors.green.withOpacity(0.15),
                                              borderRadius:
                                              BorderRadius.circular(10),
                                            ),
                                            child: Text(
                                              lowStock
                                                  ? "Low Stock ⚠ (${product.stock})"
                                                  : "Stock: ${product.stock}",
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                                color: lowStock
                                                    ? Colors.red
                                                    : Colors.green,
                                              ),
                                            ),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),

                            /// EXPANDED DETAILS
                            if (expanded) ...[
                              const SizedBox(height: 12),
                              const Divider(),

                              const Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Product Details",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              ),

                              const SizedBox(height: 8),

                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                    "Production Cost : ₹${product.productionCost}"),
                              ),

                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                    "VIP Price : ₹${product.vipPrice}"),
                              ),

                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                    "Special Price : ₹${product.specialPrice}"),
                              ),

                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                    "Min Stock : ${product.minStock}"),
                              ),

                              const SizedBox(height: 6),

                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Profit : ₹${product.price - product.productionCost}",
                                  style: const TextStyle(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ]
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          )
        ],
      ),
    );
  }
}