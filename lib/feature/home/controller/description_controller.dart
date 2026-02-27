import 'dart:convert';
import 'package:daraz_clone/feature/home/model/product_description_model.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class ProductDescriptionController extends GetxController {
  var isLoading = true.obs;

  var product = Rxn<ProductDescription>();

  final String baseUrl = "https://fakestoreapi.com";

  late int productId;

  @override
  void onInit() {
    super.onInit();

    /// Argument Receive
    productId = Get.arguments;

    /// API Call
    getProductDescription(productId);
  }

  Future<void> getProductDescription(int id) async {
    try {
      isLoading.value = true;

      final response = await http.get(Uri.parse("$baseUrl/products/$id"));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        product.value = ProductDescription.fromJson(data);
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    } finally {
      isLoading.value = false;
    }
  }
}
