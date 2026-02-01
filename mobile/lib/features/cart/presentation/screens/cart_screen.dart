import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../cart/data/repositories/cart_repository_impl.dart';
import '../../../cart/domain/usecases/add_to_cart.dart' as usecases;
import '../../../cart/domain/usecases/get_cart_items.dart';
import '../../../cart/domain/usecases/remove_from_cart.dart' as usecases;
import '../../../cart/domain/usecases/update_cart_quantity.dart';
import '../bloc/cart_bloc.dart';
import '../bloc/cart_event.dart';
import '../bloc/cart_state.dart';
import '../widgets/cart_item_widget.dart';
import '../widgets/order_summary.dart';

/// Cart Screen - displays shopping cart with items and checkout option
class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<SharedPreferences>(
      future: SharedPreferences.getInstance(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            backgroundColor: AppColors.muted,
            appBar: AppBar(
              title: const Text('Ваша корзина'),
              centerTitle: false,
            ),
            body: const Center(
              child: CircularProgressIndicator(
                color: AppColors.primary,
              ),
            ),
          );
        }

        if (snapshot.hasError || !snapshot.hasData) {
          return Scaffold(
            backgroundColor: AppColors.muted,
            appBar: AppBar(
              title: const Text('Ваша корзина'),
              centerTitle: false,
            ),
            body: Center(
              child: Text(
                'Ошибка при загрузке корзины',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
          );
        }

        final prefs = snapshot.data!;

        return BlocProvider(
          create: (context) {
            // Create repository and use cases
            final repository = CartRepositoryImpl(prefs);
            final getCartItems = GetCartItems(repository);
            final addToCart = usecases.AddToCart(repository);
            final removeFromCart = usecases.RemoveFromCart(repository);
            final updateCartQuantity = UpdateCartQuantity(repository);

            // Create and initialize BLoC
            return CartBloc(
              getCartItems: getCartItems,
              addToCart: addToCart,
              removeFromCart: removeFromCart,
              updateCartQuantity: updateCartQuantity,
            )..add(const LoadCart());
          },
          child: const _CartScreenView(),
        );
      },
    );
  }
}

class _CartScreenView extends StatelessWidget {
  const _CartScreenView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.muted,
      appBar: AppBar(
        title: const Text('Ваша корзина'),
        centerTitle: false,
      ),
      body: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          if (state is CartLoading) {
            return const Center(
              child: CircularProgressIndicator(
                color: AppColors.primary,
              ),
            );
          }

          if (state is CartError) {
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
                    state.message,
                    style: Theme.of(context).textTheme.bodyLarge,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      context.read<CartBloc>().add(const LoadCart());
                    },
                    child: const Text('Повторить'),
                  ),
                ],
              ),
            );
          }

          if (state is CartLoaded) {
            if (state.isEmpty) {
              return _buildEmptyState(context);
            }

            return _buildCartContent(context, state);
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_cart_outlined,
            size: 120,
            color: AppColors.mutedForeground,
          ),
          const SizedBox(height: 24),
          Text(
            'Корзина пуста',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.darkBlue,
                ),
          ),
          const SizedBox(height: 12),
          Text(
            'Добавьте товары в корзину,\nчтобы оформить заказ',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppColors.textSecondary,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildCartContent(BuildContext context, CartLoaded state) {
    return Column(
      children: [
        // Cart Items List
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: state.items.length,
            itemBuilder: (context, index) {
              final cartItem = state.items[index];
              return CartItemWidget(
                cartItem: cartItem,
                onRemove: () {
                  context.read<CartBloc>().add(
                        RemoveFromCart(cartItem.product.id),
                      );
                },
                onIncrement: () {
                  context.read<CartBloc>().add(
                        UpdateQuantity(
                          productId: cartItem.product.id,
                          quantity: cartItem.quantity + 1,
                        ),
                      );
                },
                onDecrement: () {
                  context.read<CartBloc>().add(
                        UpdateQuantity(
                          productId: cartItem.product.id,
                          quantity: cartItem.quantity - 1,
                        ),
                      );
                },
              );
            },
          ),
        ),

        // Bottom section with Order Summary and Checkout Button
        Container(
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            color: AppColors.background,
            border: Border(
              top: BorderSide(
                color: AppColors.border,
                width: 1,
              ),
            ),
          ),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Order Summary
                OrderSummary(
                  subtotal: state.subtotal,
                  discount: state.discount,
                  total: state.totalPrice,
                ),
                const SizedBox(height: 16),

                // Checkout Button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () {
                      // TODO: Implement checkout functionality
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Оформление заказа в разработке'),
                          backgroundColor: AppColors.info,
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
                    child: const Text(
                      'Оформить заказ',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
