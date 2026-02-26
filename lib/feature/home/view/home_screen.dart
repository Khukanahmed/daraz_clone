import 'package:daraz_clone/feature/auth/view/login_screen.dart';
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
      bottomNavigationBar: const _WelcomeCard(),
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: ProductGridShimmer());
          }

          if (controller.errorMessage.value != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(controller.errorMessage.value!),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: controller.onRefresh,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Retry'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF00B14F),
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              const SizedBox(height: 12),
              const _SearchBar(),
              const _FlashSaleBanner(),

              // ── Tab Bar ──────────────────────────────────────────────
              Container(
                color: Colors.white,
                child: TabBar(
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

              // ── Tab Content with RefreshIndicator ────────────────────
              Expanded(
                child: TabBarView(
                  controller: controller.tabController,
                  children: List.generate(
                    controller.tabs.length,
                    (i) => RefreshIndicator(
                      color: const Color(0xFF00B14F),
                      // physics must allow overscroll for pull-to-refresh
                      notificationPredicate: (notification) =>
                          notification.depth == 0,
                      onRefresh: () async {
                        controller.startRefreshAnimation();
                        await controller.onRefresh();
                      },
                      child: ProductGrid(tabIndex: i),
                    ),
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}

// ─── Search Bar ──────────────────────────────────────────────────────────────

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
              // Show clear button when searching, refresh icon otherwise
              if (ctrl.searchQuery.value.isNotEmpty)
                GestureDetector(
                  onTap: ctrl.clearSearch,
                  child: const Icon(Icons.close, color: Colors.grey, size: 18),
                )
              else
                GestureDetector(
                  onTap: () async {
                    ctrl.startRefreshAnimation();
                    await ctrl.onRefresh();
                  },
                  child: const _SpinningRefreshIcon(),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Spinning Refresh Icon ───────────────────────────────────────────────────

class _SpinningRefreshIcon extends StatefulWidget {
  const _SpinningRefreshIcon();

  @override
  State<_SpinningRefreshIcon> createState() => _SpinningRefreshIconState();
}

class _SpinningRefreshIconState extends State<_SpinningRefreshIcon>
    with SingleTickerProviderStateMixin {
  late final AnimationController _anim;

  @override
  void initState() {
    super.initState();
    _anim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    ever(Get.find<HomeController>().isRefreshing, (bool refreshing) {
      if (!mounted) return;
      if (refreshing) {
        _anim.repeat();
      } else {
        _anim.stop();
        _anim.animateTo(0, duration: const Duration(milliseconds: 150));
      }
    });
  }

  @override
  void dispose() {
    _anim.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: _anim,
      child: const Icon(Icons.refresh, color: Color(0xFF00B14F), size: 20),
    );
  }
}

// ─── Flash Sale Banner ───────────────────────────────────────────────────────

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

// ─── Welcome Card ────────────────────────────────────────────────────────────

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
