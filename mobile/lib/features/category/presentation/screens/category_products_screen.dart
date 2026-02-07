import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../home/data/repositories/product_repository_impl.dart';
import '../../../home/domain/usecases/get_products_by_category.dart';
import '../../../home/presentation/widgets/product_card.dart';
import '../../../home/presentation/widgets/search_app_bar_title.dart';
import '../bloc/category_bloc.dart';
import '../bloc/category_event.dart';
import '../bloc/category_state.dart';

/// Category Products screen - displays products filtered by category
class CategoryProductsScreen extends StatelessWidget {
  final String categoryId;

  const CategoryProductsScreen({super.key, required this.categoryId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        // Create repository and use case
        final repository = ProductRepositoryImpl();
        final getProductsByCategory = GetProductsByCategory(repository);

        // Create and initialize BLoC
        return CategoryBloc(getProductsByCategory: getProductsByCategory)
          ..add(LoadCategoryProducts(categoryId));
      },
      child: const _CategoryProductsScreenView(),
    );
  }
}

class _CategoryProductsScreenView extends StatelessWidget {
  const _CategoryProductsScreenView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const SearchAppBarTitle(showLogo: false),
        titleSpacing: 16,
      ),
      body: BlocBuilder<CategoryBloc, CategoryState>(
        builder: (context, state) {
          if (state is CategoryLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is CategoryError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Text(
                      state.message,
                      style: Theme.of(context).textTheme.bodyLarge,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Назад'),
                  ),
                ],
              ),
            );
          }

          if (state is CategoryLoaded) {
            return CustomScrollView(
              slivers: [
                // Category Name Header
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                    child: Text(
                      state.categoryName,
                      style: Theme.of(context).textTheme.headlineMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),

                // Products Grid or Empty State
                if (state.products.isEmpty)
                  SliverFillRemaining(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.shopping_bag_outlined,
                            size: 64,
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurface.withValues(alpha: 0.3),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Нет товаров',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 8),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 32),
                            child: Text(
                              'В этой категории пока нет товаров',
                              style: Theme.of(context).textTheme.bodyMedium,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  SliverPadding(
                    padding: const EdgeInsets.all(16),
                    sliver: SliverGrid(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.75,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                          ),
                      delegate: SliverChildBuilderDelegate((context, index) {
                        final product = state.products[index];
                        return ProductCard(
                          product: product,
                          onAddToCart: () {
                            // Show snackbar when adding to cart
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  '${product.name} добавлен в корзину',
                                ),
                                duration: const Duration(seconds: 2),
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          },
                        );
                      }, childCount: state.products.length),
                    ),
                  ),
              ],
            );
          }

          // Initial state
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
