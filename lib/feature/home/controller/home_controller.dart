import 'dart:convert';
import 'package:daraz_clone/feature/home/model/model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class HomeController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late TabController tabController;

  final List<String> tabs = [];
  var isLoading = true.obs;
  var errorMessage = Rxn<String>();
  var allProducts = <Product>[].obs;

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

  Future<void> fetchProducts() async {
    isLoading.value = true;
    errorMessage.value = null;

    try {
      final response = await http.get(Uri.parse(_apiUrl));

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        allProducts.value = jsonList.map((j) => Product.fromJson(j)).toList();

        final categories = allProducts.map((p) => p.category).toSet().toList();

        tabs
          ..clear()
          ..add('All')
          ..addAll(categories.map(_titleCase));

        tabController = TabController(length: tabs.length, vsync: this);
        isLoading.value = false;
      } else {
        errorMessage.value = 'Server error: ${response.statusCode}';
        isLoading.value = false;
      }
    } catch (e) {
      errorMessage.value = 'Failed to load products. Check your connection.';
      isLoading.value = false;
    }
  }

  Future<void> onRefresh() async {
    await fetchProducts();
  }

  var searchQuery = ''.obs;

  List<Product> getProductsForTab(int tabIndex) {
    List<Product> products;

    if (tabs.isEmpty || tabIndex == 0) {
      products = allProducts;
    } else {
      final category = tabs[tabIndex].toLowerCase();
      products = allProducts.where((p) => p.category == category).toList();
    }

    if (searchQuery.value.isNotEmpty) {
      products = products
          .where(
            (p) =>
                p.title.toLowerCase().contains(searchQuery.value.toLowerCase()),
          )
          .toList();
    }

    return products;
  }

  void onSearch(String query) {
    searchQuery.value = query;
  }

  void clearSearch() {
    searchQuery.value = '';
  }

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
