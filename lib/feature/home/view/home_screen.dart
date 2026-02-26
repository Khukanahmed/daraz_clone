import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/home_controller.dart';
import '../model/model.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final HomeController controller = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: GetBuilder<HomeController>(
          builder: (ctrl) {
            if (ctrl.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (ctrl.errorMessage != null) {
              return Center(child: Text(ctrl.errorMessage!));
            }

            return RefreshIndicator(
              onRefresh: ctrl.onRefresh,
              child: CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  /// 🔹 Collapsible Header
                  SliverAppBar(
                    backgroundColor: Colors.white,
                    expandedHeight: 220,
                    pinned: false,
                    flexibleSpace: const FlexibleSpaceBar(
                      collapseMode: CollapseMode.pin,
                      background: _HeaderSection(),
                    ),
                  ),

                  SliverPersistentHeader(
                    pinned: true,
                    delegate: _TabBarDelegate(
                      TabBar(
                        controller: ctrl.tabController,
                        isScrollable: true,
                        labelColor: const Color(0xFF00B14F),
                        unselectedLabelColor: Colors.grey,
                        indicatorColor: const Color(0xFF00B14F),
                        tabs: ctrl.tabs.map((e) => Tab(text: e)).toList(),
                      ),
                    ),
                  ),

                  /// 🔹 Tab Content
                  SliverFillRemaining(
                    child: TabBarView(
                      controller: ctrl.tabController,
                      children: List.generate(
                        ctrl.tabs.length,
                        (i) => _ProductGrid(tabIndex: i),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

/// ─────────────────────────────────────────
/// HEADER (Search + Banner + Welcome)
/// ─────────────────────────────────────────
class _HeaderSection extends StatelessWidget {
  const _HeaderSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        SizedBox(height: 12),
        _SearchBar(),
        SizedBox(height: 8),
        _FlashSaleBanner(),
        SizedBox(height: 8),
        _WelcomeCard(),
      ],
    );
  }
}

/// ─────────────────────────────────────────
/// Sticky TabBar Delegate
/// ─────────────────────────────────────────
class _TabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;
  const _TabBarDelegate(this.tabBar);

  @override
  double get minExtent => tabBar.preferredSize.height;

  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlaps) {
    return Container(color: Colors.white, child: tabBar);
  }

  @override
  bool shouldRebuild(_) => false;
}

/// ─────────────────────────────────────────
/// Product Grid (Non-scrollable)
/// ─────────────────────────────────────────
class _ProductGrid extends StatelessWidget {
  final int tabIndex;
  const _ProductGrid({required this.tabIndex});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      builder: (ctrl) {
        final products = ctrl.getProductsForTab(tabIndex);

        return GridView.builder(
          key: PageStorageKey(tabIndex),
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          padding: const EdgeInsets.all(12),
          itemCount: products.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 0.65,
          ),
          itemBuilder: (_, index) => _ProductCard(product: products[index]),
        );
      },
    );
  }
}

class _ProductCard extends StatelessWidget {
  final Product product;
  const _ProductCard({required this.product});

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
          Expanded(
            flex: 5,
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(14),
              ),
              child: Image.network(
                product.image,
                fit: BoxFit.contain,
                width: double.infinity,
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
                  const Spacer(),
                  Text(
                    "\$${product.price}",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF00B14F),
                    ),
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

class _SearchBar extends StatelessWidget {
  const _SearchBar();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Container(
        height: 44,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
        ),
        child: const Row(
          children: [
            Icon(Icons.search, color: Color(0xFF00B14F)),
            SizedBox(width: 8),
            Text("Search Products"),
          ],
        ),
      ),
    );
  }
}

class _FlashSaleBanner extends StatelessWidget {
  const _FlashSaleBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF00B14F), Color(0xFF007A36)],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Flash Sale!",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          Text("Shop Now", style: TextStyle(color: Colors.white)),
        ],
      ),
    );
  }
}

class _WelcomeCard extends StatelessWidget {
  const _WelcomeCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: const Row(
        children: [
          CircleAvatar(
            backgroundColor: Color(0xFFE8F5E9),
            child: Icon(Icons.person, color: Color(0xFF00B14F)),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              "Welcome Back!",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
