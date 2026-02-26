import 'package:daraz_clone/feature/home/widget/product_card_widget.dart';
import 'package:daraz_clone/feature/home/widget/shimmer_loader.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/home_controller.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final HomeController controller = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: ProductGridShimmer());
          }

          if (controller.errorMessage.value != null) {
            return Center(child: Text(controller.errorMessage.value!));
          }

          return NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) => [
              SliverToBoxAdapter(
                child: Column(
                  children: const [
                    SizedBox(height: 12),
                    _SearchBar(),
                    SizedBox(height: 8),
                    _FlashSaleBanner(),
                    SizedBox(height: 8),
                    _WelcomeCard(),
                    SizedBox(height: 8),
                  ],
                ),
              ),

              SliverPersistentHeader(
                pinned: true,
                delegate: _TabBarDelegate(
                  TabBar(
                    controller: controller.tabController,
                    isScrollable: true,
                    padding: EdgeInsets.zero,
                    tabAlignment: TabAlignment.start,
                    labelColor: const Color(0xFF00B14F),
                    unselectedLabelColor: Colors.grey,
                    indicatorColor: const Color(0xFF00B14F),
                    tabs: controller.tabs.map((e) => Tab(text: e)).toList(),
                  ),
                ),
              ),
            ],

            body: TabBarView(
              controller: controller.tabController,
              children: List.generate(
                controller.tabs.length,
                (i) => ProductGrid(tabIndex: i),
              ),
            ),
          );
        }),
      ),
    );
  }
}

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

class _SearchBar extends StatelessWidget {
  const _SearchBar();

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<HomeController>();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Obx(
        () => Container(
          height: 44,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 6),
            ],
          ),
          child: Row(
            children: [
              const Icon(Icons.search, color: Color(0xFF00B14F)),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  onChanged: ctrl.onSearch,
                  decoration: const InputDecoration(
                    hintText: "Search Products",
                    hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                    border: InputBorder.none,
                    isDense: true,
                  ),
                ),
              ),
              if (ctrl.searchQuery.value.isNotEmpty)
                GestureDetector(
                  onTap: ctrl.clearSearch,
                  child: const Icon(Icons.close, color: Colors.grey, size: 18),
                ),
            ],
          ),
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
