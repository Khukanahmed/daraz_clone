import 'package:daraz_clone/feature/home/controller/home_controller.dart';
import 'package:daraz_clone/feature/home/model/model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductGrid extends StatelessWidget {
  final int tabIndex;
  const ProductGrid({super.key, required this.tabIndex});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<HomeController>();
    final screenHeight = MediaQuery.of(context).size.height;
    final itemHeight = screenHeight * 0.30;

    return Obx(() {
      final products = ctrl.getProductsForTab(tabIndex);

      if (products.isEmpty) {
        return const Center(child: Text('No products found'));
      }

      return GridView.builder(
        key: PageStorageKey(tabIndex),
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(12),
        itemCount: products.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          mainAxisExtent: itemHeight,
        ),
        itemBuilder: (_, index) => ProductCard(product: products[index]),
      );
    });
  }
}

class ProductCard extends StatelessWidget {
  final Product product;
  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 6),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Product Image ──
          Expanded(
            flex: 5,
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(14),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.network(
                  product.image,
                  fit: BoxFit.contain,
                  width: double.infinity,
                  loadingBuilder: (_, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFF00B14F),
                        strokeWidth: 2,
                      ),
                    );
                  },
                  errorBuilder: (_, __, ___) => const Center(
                    child: Icon(Icons.broken_image, color: Colors.grey),
                  ),
                ),
              ),
            ),
          ),

          // ── Product Info ──
          Expanded(
            flex: 4,
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    product.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 12),
                  ),
                  const Spacer(),

                  // Rating
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 14),
                      const SizedBox(width: 2),
                      Text(
                        "${product.ratingRate}",
                        style: const TextStyle(
                          fontSize: 11,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        "(${product.ratingCount})",
                        style: const TextStyle(
                          fontSize: 11,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),

                  // Price + Cart Button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "\$${product.price.toStringAsFixed(2)}",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                          color: Color(0xFF00B14F),
                        ),
                      ),
                      Container(
                        height: 26,
                        width: 26,
                        decoration: BoxDecoration(
                          color: const Color(0xFF00B14F),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.add,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
