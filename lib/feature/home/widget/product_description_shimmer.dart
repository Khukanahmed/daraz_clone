import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ProductDescriptionShimmer extends StatelessWidget {
  const ProductDescriptionShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        shimmerBox(height: 300, width: double.infinity),

        const SizedBox(height: 10),

        Padding(
          padding: const EdgeInsets.all(12),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              shimmerBox(height: 20, width: 250),

              const SizedBox(height: 10),

              shimmerBox(height: 20, width: 120),

              const SizedBox(height: 15),

              shimmerBox(height: 15, width: double.infinity),

              const SizedBox(height: 8),

              shimmerBox(height: 15, width: double.infinity),

              const SizedBox(height: 8),

              shimmerBox(height: 15, width: 200),
            ],
          ),
        ),
      ],
    );
  }

  /// Reusable Shimmer Box
  Widget shimmerBox({required double height, required double width}) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,

      child: Container(height: height, width: width, color: Colors.white),
    );
  }
}
