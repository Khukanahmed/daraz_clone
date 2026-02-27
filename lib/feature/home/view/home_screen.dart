import 'package:daraz_clone/core/colors/app_colors.dart';
import 'package:daraz_clone/feature/auth/view/login_screen.dart';
import 'package:daraz_clone/feature/home/widget/product_card_widget.dart';
import 'package:daraz_clone/feature/home/widget/shimmer_loader.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/home_controller.dart';
import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final HomeController controller = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      bottomNavigationBar: const _WelcomeCard(),
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
              SliverOverlapAbsorber(
                handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
                  context,
                ),
                sliver: SliverToBoxAdapter(
                  child: Column(
                    children: const [
                      SizedBox(height: 12),
                      _SearchBar(),
                      _FlashSaleBanner(),
                    ],
                  ),
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
                (i) => _TabBody(tabIndex: i),
              ),
            ),
          );
        }),
      ),
    );
  }
}

class _TabBody extends StatelessWidget {
  final int tabIndex;
  const _TabBody({required this.tabIndex});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<HomeController>();

    return Builder(
      builder: (innerContext) {
        return CustomRefreshIndicator(
          onRefresh: ctrl.onRefresh,
          offsetToArmed: 80,
          builder: (context, child, controller) {
            return Stack(
              children: [
                AnimatedBuilder(
                  animation: controller,
                  builder: (_, __) {
                    final offset = controller.value * 80.0;
                    return Transform.translate(
                      offset: Offset(0, offset),
                      child: child,
                    );
                  },
                ),

                // ── Top-এ Daraz-style indicator ──
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: AnimatedBuilder(
                    animation: controller,
                    builder: (_, __) {
                      final opacity = controller.value.clamp(0.0, 1.0);
                      final isLoading = controller.state.isLoading;

                      return Opacity(
                        opacity: opacity,
                        child: Container(
                          color: const Color(0xFFF5F5F5),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 48,
                                height: 48,
                                decoration: const BoxDecoration(
                                  color: AppColors.primaryColor,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black26,
                                      blurRadius: 6,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: isLoading
                                    ? const Padding(
                                        padding: EdgeInsets.all(12),
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 2.5,
                                        ),
                                      )
                                    : const Icon(
                                        Icons.shopping_bag,
                                        color: Colors.white,
                                        size: 26,
                                      ),
                              ),

                              const SizedBox(height: 8),

                              // >> Release to refresh text
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  if (!isLoading) ...[
                                    const Icon(
                                      Icons.keyboard_double_arrow_down,
                                      size: 14,
                                      color: Colors.grey,
                                    ),
                                    const SizedBox(width: 4),
                                  ],
                                  Text(
                                    isLoading
                                        ? 'Loading...'
                                        : 'Release to refresh',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          },
          child: CustomScrollView(
            key: PageStorageKey<int>(tabIndex),
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverOverlapInjector(
                handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
                  innerContext,
                ),
              ),
              ProductSliverGrid(tabIndex: tabIndex),
            ],
          ),
        );
      },
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
    return Material(
      elevation: overlaps ? 2.0 : 0.0,
      color: Colors.white,
      child: tabBar,
    );
  }

  @override
  bool shouldRebuild(_TabBarDelegate old) => old.tabBar != tabBar;
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
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 6,
              ),
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
        borderRadius: BorderRadius.circular(12),
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
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.green.shade100,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            backgroundColor: Color(0xFFE8F5E9),
            child: Icon(Icons.person, color: Color(0xFF00B14F)),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              "Welcome Back!",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),

          GestureDetector(
            onTap: () => Get.to(() => LoginScreen()),
            child: const Text(
              "Login",
              style: TextStyle(
                color: Color(0xFF00B14F),
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
    );
  }
}
