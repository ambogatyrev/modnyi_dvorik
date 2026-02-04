import 'package:flutter/material.dart';
import '../../../home/domain/entities/product.dart';
import '../../../home/presentation/widgets/product_card.dart';

/// Search results grid widget
/// Displays search results in a 2-column grid layout
class SearchResultsGrid extends StatelessWidget {
  final List<Product> products;

  const SearchResultsGrid({
    super.key,
    required this.products,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.7,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        return ProductCard(product: products[index]);
      },
    );
  }
}
