import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/router/app_router.dart';
import '../../../home/data/repositories/product_repository_impl.dart';
import '../../../home/domain/usecases/get_product_by_id.dart';
import '../../../cart/presentation/bloc/cart_bloc.dart';
import '../../../cart/presentation/bloc/cart_event.dart';
import '../../../cart/presentation/bloc/cart_state.dart';
import '../cubit/product_detail_cubit.dart';
import '../cubit/product_detail_state.dart';
import '../widgets/quantity_selector.dart';

/// Product Detail Screen - shows full product information
class ProductDetailScreen extends StatelessWidget {
  final String productId;

  const ProductDetailScreen({super.key, required this.productId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        // Create repository and use case
        final repository = ProductRepositoryImpl();
        final getProductById = GetProductById(repository);

        // Create and initialize Cubit
        return ProductDetailCubit(getProductById: getProductById)
          ..loadProduct(productId);
      },
      child: const _ProductDetailView(),
    );
  }
}

class _ProductDetailView extends StatelessWidget {
  const _ProductDetailView();

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat('#,###', 'ru_RU');

    return Scaffold(
      backgroundColor: AppColors.background,
      body: BlocBuilder<ProductDetailCubit, ProductDetailState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }

          if (state.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 64,
                    color: AppColors.error,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    state.error!,
                    style: Theme.of(context).textTheme.bodyLarge,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Назад'),
                  ),
                ],
              ),
            );
          }

          final product = state.product;
          if (product == null) {
            return const SizedBox.shrink();
          }

          final formattedPrice = formatter.format(product.price);

          return CustomScrollView(
            slivers: [
              // App Bar with back button
              SliverAppBar(
                pinned: true,
                backgroundColor: AppColors.background,
                elevation: 0,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back, color: AppColors.darkBlue),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),

              // Product content
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Hero Image
                    Hero(
                      tag: 'product-${product.id}',
                      child: AspectRatio(
                        aspectRatio: 1.0,
                        child: CachedNetworkImage(
                          imageUrl: product.image,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(
                            color: AppColors.muted,
                            child: const Center(
                              child: CircularProgressIndicator(
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                          errorWidget: (context, url, error) => Container(
                            color: AppColors.muted,
                            child: const Icon(
                              Icons.image_not_supported,
                              size: 64,
                              color: AppColors.mutedForeground,
                            ),
                          ),
                        ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Product Name
                          Text(
                            product.name,
                            style: Theme.of(context).textTheme.headlineMedium
                                ?.copyWith(
                                  color: AppColors.darkBlue,
                                  fontWeight: FontWeight.w700,
                                ),
                          ),
                          const SizedBox(height: 12),

                          // Price
                          Text(
                            '$formattedPrice ₽',
                            style: Theme.of(context).textTheme.headlineSmall
                                ?.copyWith(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w700,
                                ),
                          ),
                          const SizedBox(height: 24),

                          // Description Section
                          _buildSection(
                            context,
                            title: 'Описание',
                            content: _getProductDescription(product.name),
                          ),
                          const SizedBox(height: 20),

                          // Features Section
                          _buildSection(
                            context,
                            title: 'Особенности',
                            content: _getProductFeatures(product.category),
                          ),
                          const SizedBox(height: 20),

                          // Specifications Section
                          _buildSection(
                            context,
                            title: 'Характеристики',
                            content: _getProductSpecifications(
                              product.category,
                            ),
                          ),
                          const SizedBox(
                            height: 100,
                          ), // Space for floating button
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: BlocBuilder<ProductDetailCubit, ProductDetailState>(
        builder: (context, productState) {
          final product = productState.product;
          if (product == null) {
            return const SizedBox.shrink();
          }

          return BlocBuilder<CartBloc, CartState>(
            builder: (context, cartState) {
              // Check if product is in cart
              int? cartQuantity;
              if (cartState is CartLoaded) {
                try {
                  final cartItem = cartState.items.firstWhere(
                    (item) => item.product.id == product.id,
                  );
                  cartQuantity = cartItem.quantity;
                } catch (e) {
                  // Product not in cart
                  cartQuantity = null;
                }
              }

              final isInCart = cartQuantity != null;

              return Container(
                decoration: BoxDecoration(
                  color: AppColors.background,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.darkBlue.withValues(alpha: 0.1),
                      blurRadius: 8,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(16),
                child: SafeArea(
                  child: SizedBox(
                    height: 56,
                    child: isInCart
                        ? Builder(
                            builder: (context) {
                              // Capture non-null cartQuantity for use in closures
                              final currentQuantity = cartQuantity!;
                              return Row(
                                children: [
                                  // "In Cart" button (left) - navigates to cart
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: () {
                                        // Navigate to cart screen
                                        context.go(AppRoutes.cart);
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColors.primary,
                                        foregroundColor: AppColors.textOnPrimary,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        elevation: 0,
                                      ),
                                      child: const Text(
                                        'В корзине',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  // Quantity selector (right) - controls cart quantity
                                  QuantitySelector(
                                    quantity: currentQuantity,
                                    minQuantity: 0,
                                    onIncrement: () {
                                      context.read<CartBloc>().add(
                                            UpdateQuantity(
                                              productId: product.id,
                                              quantity: currentQuantity + 1,
                                            ),
                                          );
                                    },
                                    onDecrement: () {
                                      if (currentQuantity == 1) {
                                        // Remove product from cart when quantity is 1
                                        context.read<CartBloc>().add(
                                              RemoveFromCart(product.id),
                                            );
                                      } else {
                                        // Decrease quantity
                                        context.read<CartBloc>().add(
                                              UpdateQuantity(
                                                productId: product.id,
                                                quantity: currentQuantity - 1,
                                              ),
                                            );
                                      }
                                    },
                                  ),
                                ],
                              );
                            },
                          )
                        : ElevatedButton(
                            onPressed: () {
                              // Add product to cart with quantity 1
                              context.read<CartBloc>().add(
                                    AddToCart(
                                      product: product,
                                      quantity: 1,
                                    ),
                                  );

                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Товар добавлен в корзину'),
                                  backgroundColor: AppColors.success,
                                  duration: Duration(seconds: 2),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: AppColors.textOnPrimary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              elevation: 0,
                            ),
                            child: Text(
                              'В корзину • ${formatter.format(product.price)} ₽',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildSection(
    BuildContext context, {
    required String title,
    required String content,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.darkBlue,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          content,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: AppColors.textSecondary,
            height: 1.5,
          ),
        ),
      ],
    );
  }

  String _getProductDescription(String productName) {
    // Generic descriptions based on product name
    final descriptions = {
      'Увлажняющий крем для лица':
          'Легкий увлажняющий крем для ежедневного ухода. Обеспечивает интенсивное увлажнение на 24 часа, делает кожу мягкой и сияющей.',
      'Сыворотка с витамином С':
          'Высококонцентрированная сыворотка с витамином С для сияния и выравнивания тона кожи. Борется с первыми признаками старения.',
      'Ночной крем для лица':
          'Питательный ночной крем для восстановления и регенерации кожи во время сна. Насыщенная формула глубоко питает кожу.',
      'Маска для лица':
          'Интенсивная увлажняющая маска для мгновенного преображения кожи. Придает коже свежий и отдохнувший вид.',
      'Помада красная':
          'Стойкая помада с насыщенным цветом и кремовой текстурой. Обеспечивает комфортное нанесение и длительную носкость.',
      'Тушь для ресниц':
          'Тушь для создания объемных и длинных ресниц. Не осыпается в течение дня и легко смывается.',
      'Палетка теней':
          'Универсальная палетка теней для создания любого макияжа. Высокопигментированные оттенки легко растушевываются.',
      'Шампунь для волос':
          'Мягкий шампунь для ежедневного использования. Бережно очищает волосы, не пересушивая их.',
    };

    return descriptions[productName] ??
        'Качественный косметический продукт для ухода и красоты. Подходит для ежедневного использования.';
  }

  String _getProductFeatures(String category) {
    final features = {
      'face':
          '• Подходит для всех типов кожи\n• Гипоаллергенная формула\n• Без парабенов и сульфатов\n• Протестировано дерматологами',
      'makeup':
          '• Стойкая формула\n• Насыщенный цвет\n• Не тестируется на животных\n• Подходит для чувствительной кожи',
      'hair':
          '• Натуральные компоненты\n• Подходит для частого использования\n• Восстанавливает структуру волос\n• Приятный аромат',
    };

    return features[category] ??
        '• Высокое качество\n• Безопасный состав\n• Проверено специалистами\n• Рекомендовано профессионалами';
  }

  String _getProductSpecifications(String category) {
    final specs = {
      'face': '• Объем: 50 мл\n• Срок годности: 12 месяцев\n• Страна: Корея',
      'makeup': '• Объем: 3.5 г\n• Срок годности: 24 месяца\n• Страна: Италия',
      'hair': '• Объем: 250 мл\n• Срок годности: 36 месяцев\n• Страна: Франция',
    };

    return specs[category] ??
        '• Объем: 50 мл\n• Срок годности: 12 месяцев\n• Страна производства: Европа';
  }
}
