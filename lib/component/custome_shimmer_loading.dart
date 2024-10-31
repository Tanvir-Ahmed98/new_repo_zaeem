import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerLoading extends StatelessWidget {
  final Widget child;
  final Color? color;
  const ShimmerLoading({super.key, required this.child, this.color});
  @override
  Widget build(BuildContext context) {
    return Shimmer(
      gradient: LinearGradient(
        colors: [
          Colors.grey[300]!,
          Colors.grey[100]!,
          Colors.grey[300]!,
        ],
        stops: const [0.3, 0.5, 0.7],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      child: child,
    );
  }
}
