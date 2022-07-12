part of 'helpers.dart';

extension ShimmerExtensions on Widget {
  //
  Widget toShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.withOpacity(0.1),
      highlightColor: Colors.grey.withOpacity(0.18),
      child: this,
    );
  }
}
