import 'package:daraz_clone/core/colors/app_colors.dart';
import 'package:daraz_clone/feature/home/controller/description_controller.dart';
import 'package:daraz_clone/feature/home/widget/product_description_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductDescriptionScreen extends StatelessWidget {
  ProductDescriptionScreen({super.key});

  final ProductDescriptionController controller = Get.put(
    ProductDescriptionController(),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: const BackButton(color: Colors.black),
        title: const Text(
          "Product Details",
          style: TextStyle(color: Colors.black),
        ),
      ),

      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: ProductDescriptionShimmer());
        }

        final product = controller.product.value!;

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 300,
                width: double.infinity,
                color: Colors.white,
                child: Image.network(product.image),
              ),

              const SizedBox(height: 10),

              Container(
                color: Colors.white,
                padding: const EdgeInsets.all(12),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 10),

                    Text(
                      "\$${product.price}",
                      style: const TextStyle(
                        fontSize: 22,
                        color: AppColors.primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 10),

                    Text(product.description),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
