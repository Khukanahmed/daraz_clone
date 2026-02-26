import 'dart:convert';
import 'package:daraz_clone/feature/home/model/model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

// ─────────────────────────────────────────────────────────────────────────────
// HomeController
// ─────────────────────────────────────────────────────────────────────────────
class HomeController extends GetxController with GetTickerProviderStateMixin {
  // ── Tab ──────────────────────────────────────────────────────────────────
  late TabController tabController;

  // Tabs: first tab is always "All", rest come from API categories
  final List<String> tabs = [];

  // ── State ────────────────────────────────────────────────────────────────
  bool isLoading = true;
  String? errorMessage;
  List<Product> allProducts = [];

  // ── API ───────────────────────────────────────────────────────────────────
  static const String _apiUrl = 'https://fakestoreapi.com/products';

  @override
  void onInit() {
    super.onInit();
    fetchProducts();
  }

  @override
  void onClose() {
    tabController.dispose();
    super.onClose();
  }

  // ── Fetch from API ────────────────────────────────────────────────────────
  Future<void> fetchProducts() async {
    isLoading = true;
    errorMessage = null;
    update();

    try {
      final response = await http
          .get(Uri.parse(_apiUrl))
          .timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        allProducts = jsonList.map((j) => Product.fromJson(j)).toList();

        // Build tabs: All + unique categories (title-cased)
        final categories = allProducts.map((p) => p.category).toSet().toList();

        tabs
          ..clear()
          ..add('All')
          ..addAll(categories.map(_titleCase));

        // Init TabController after we know tab count
        tabController = TabController(length: tabs.length, vsync: this);
        isLoading = false;
      } else {
        errorMessage = 'Server error: ${response.statusCode}';
        isLoading = false;
      }
    } catch (e) {
      errorMessage = 'Failed to load products. Check your connection.';
      isLoading = false;
    }

    update();
  }

  // ── Pull-to-Refresh ───────────────────────────────────────────────────────
  Future<void> onRefresh() async {
    await fetchProducts();
  }

  // ── Products for a given tab index ───────────────────────────────────────
  // Safe: called from GetBuilder, never mid-layout.
  List<Product> getProductsForTab(int tabIndex) {
    if (tabs.isEmpty || tabIndex == 0) return allProducts;
    final category = tabs[tabIndex].toLowerCase();
    return allProducts.where((p) => p.category == category).toList();
  }

  // ── Helpers ───────────────────────────────────────────────────────────────
  String _titleCase(String s) {
    if (s.isEmpty) return s;
    return s
        .split(' ')
        .map((w) {
          if (w.isEmpty) return w;
          return w[0].toUpperCase() + w.substring(1);
        })
        .join(' ');
  }
}
