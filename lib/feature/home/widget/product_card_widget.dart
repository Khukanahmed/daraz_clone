import 'package:daraz_clone/feature/home/controller/home_controller.dart';
import 'package:daraz_clone/feature/home/model/product_model.dart';
import 'package:daraz_clone/feature/home/view/product_descristion.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// A pure [SliverGrid] of products for [tabIndex].
///
/// Must live inside a [CustomScrollView] — it does NOT own a scroll view or
/// physics itself.  This is what makes per-tab pull-to-refresh and independent
/// scroll positions possible inside a [NestedScrollView].
class ProductSliverGrid extends StatelessWidget {
  final int tabIndex;
  const ProductSliverGrid({super.key, required this.tabIndex});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<HomeController>();
    final screenHeight = MediaQuery.of(context).size.height;
    final itemHeight = screenHeight * 0.28;

    return Obx(() {
      final products = ctrl.getProductsForTab(tabIndex);

      if (products.isEmpty) {
        return const SliverFillRemaining(
          child: Center(child: Text('No products found')),
        );
      }

      return SliverPadding(
        padding: const EdgeInsets.all(12),
        sliver: SliverGrid(
          delegate: SliverChildBuilderDelegate(
            (_, index) => GestureDetector(
              onTap: () {
                Get.to(
                  () => ProductDescriptionScreen(),
                  arguments: products[index].id,
                );
              },
              child: ProductCard(product: products[index]),
            ),
            childCount: products.length,
          ),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            mainAxisExtent: itemHeight,
          ),
        ),
      );
    });
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Legacy name kept so nothing else breaks if it was imported elsewhere.
// Routes to the new sliver-based implementation via a thin wrapper.
// ─────────────────────────────────────────────────────────────────────────────
class ProductGrid extends StatelessWidget {
  final int tabIndex;
  const ProductGrid({super.key, required this.tabIndex});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<HomeController>();
    return RefreshIndicator(
      color: const Color(0xFF00B14F),
      onRefresh: ctrl.onRefresh,
      child: CustomScrollView(
        key: PageStorageKey(tabIndex),
        controller: ctrl.scrollControllerForTab(tabIndex),
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [ProductSliverGrid(tabIndex: tabIndex)],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// ProductCard — unchanged
// ─────────────────────────────────────────────────────────────────────────────
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
          BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 6),
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

          Expanded(
            flex: 4,
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 12),
                  ),
                  const SizedBox(height: 8),

                  Text(
                    "\$${product.price.toStringAsFixed(2)}",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Color(0xFF00B14F),
                    ),
                  ),

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
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
