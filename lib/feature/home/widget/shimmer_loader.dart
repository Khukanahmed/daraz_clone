import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class HomeScreenShimmer extends StatelessWidget {
  const HomeScreenShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final cardHeight = screenHeight * 0.28;

    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(14, 12, 14, 8),
                  child: _ShimmerBox(height: 44, borderRadius: 30),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(14, 0, 14, 12),
                  child: _ShimmerBox(height: 58, borderRadius: 12),
                ),
              ],
            ),
          ),

          Container(
            color: Colors.white,
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            child: Shimmer.fromColors(
              baseColor: Colors.grey.shade300,
              highlightColor: Colors.grey.shade100,
              child: Row(
                children: [
                  _ShimmerBox(height: 28, width: 60, borderRadius: 20),
                  const SizedBox(width: 16),
                  _ShimmerBox(height: 28, width: 90, borderRadius: 20),
                  const SizedBox(width: 16),
                  _ShimmerBox(height: 28, width: 70, borderRadius: 20),
                  const SizedBox(width: 16),
                  _ShimmerBox(height: 28, width: 80, borderRadius: 20),
                ],
              ),
            ),
          ),

          const SizedBox(height: 2),

          Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(child: _ProductCardShimmer(height: cardHeight)),
                      const SizedBox(width: 12),
                      Expanded(child: _ProductCardShimmer(height: cardHeight)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(child: _ProductCardShimmer(height: cardHeight)),
                      const SizedBox(width: 12),
                      Expanded(child: _ProductCardShimmer(height: cardHeight)),
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

class _ProductCardShimmer extends StatelessWidget {
  final double height;
  const _ProductCardShimmer({required this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 6),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 5,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(14)),
              ),
            ),
          ),

          Expanded(
            flex: 4,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _ShimmerBox(height: 10, borderRadius: 5),
                  const SizedBox(height: 6),
                  _ShimmerBox(height: 10, width: 90, borderRadius: 5),
                  const Spacer(),
                  _ShimmerBox(height: 13, width: 70, borderRadius: 5),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _ShimmerBox(height: 10, width: 60, borderRadius: 5),
                      _ShimmerBox(height: 26, width: 26, borderRadius: 8),
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

class _ShimmerBox extends StatelessWidget {
  final double height;
  final double? width;
  final double borderRadius;

  const _ShimmerBox({required this.height, this.width, this.borderRadius = 6});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width ?? double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    );
  }
}

class ProductGridShimmer extends StatelessWidget {
  const ProductGridShimmer({super.key});

  @override
  Widget build(BuildContext context) => const HomeScreenShimmer();
}
