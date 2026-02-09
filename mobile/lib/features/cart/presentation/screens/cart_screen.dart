import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import '../../../../core/theme/app_colors.dart';
import '../bloc/cart_bloc.dart';
import '../bloc/cart_event.dart';
import '../bloc/cart_state.dart';
import '../widgets/cart_item_widget.dart';
import '../widgets/order_summary.dart';

/// Cart Screen - displays shopping cart with items and checkout option
/// Uses in-memory storage for MVP stage
class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Reload cart when screen is opened
    context.read<CartBloc>().add(const LoadCart());
    return const _CartScreenView();
  }
}

class _CartScreenView extends StatelessWidget {
  const _CartScreenView();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartBloc, CartState>(
      builder: (context, state) {
        final cartLoaded = state is CartLoaded && !state.isEmpty ? state : null;

        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            title: const Text('Ваша корзина'),
            centerTitle: false,
            bottom: cartLoaded != null
                ? PreferredSize(
                    preferredSize: const Size.fromHeight(40),
                    child: _buildSelectionToolbar(context, cartLoaded),
                  )
                : null,
          ),
          body: _buildBody(context, state),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, CartState state) {
    if (state is CartLoading) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      );
    }

    if (state is CartError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: AppColors.error),
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
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(color: AppColors.textSecondary),
              ),
            ],
          ),
        );
      }

      return _buildCartContent(context, state);
    }

    return const SizedBox.shrink();
  }

  Widget _buildSelectionToolbar(BuildContext context, CartLoaded state) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      child: Row(
        children: [
          if (state.selectedCount > 0)
            GestureDetector(
              onTap: () => _confirmRemoveSelected(
                context,
                () => context
                    .read<CartBloc>()
                    .add(const RemoveSelectedItems()),
              ),
              child: Row(
                spacing: 4,
                children: [
                  SvgPicture.asset(
                    'assets/icons/trach.svg',
                    width: 18,
                    height: 18,
                    colorFilter: ColorFilter.mode(
                      AppColors.secondary,
                      BlendMode.srcIn,
                    ),
                  ),
                  Text('${state.selectedCount}'),
                ],
              ),
            ),
          Spacer(),
          GestureDetector(
            onTap: () {
              if (state.allSelected) {
                context.read<CartBloc>().add(const DeselectAllItems());
              } else {
                context.read<CartBloc>().add(const SelectAllItems());
              }
            },
            child: Row(
              children: [
                Text(
                  'Выбрать все',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.darkBlue,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: state.allSelected
                          ? AppColors.secondary
                          : AppColors.border,
                      width: state.allSelected ? 2 : 1.5,
                    ),
                    color: state.allSelected
                        ? AppColors.secondary
                        : Colors.transparent,
                  ),
                  child: state.allSelected
                      ? const Icon(Icons.check, size: 16, color: Colors.white)
                      : null,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _confirmRemoveSelected(
    BuildContext context,
    VoidCallback onConfirm,
  ) {
    final isIOS = Theme.of(context).platform == TargetPlatform.iOS;
    final title = 'Удалить товары';
    final content = 'Вы уверены что хотите удалить выделенные товары из корзины?';

    if (isIOS) {
      showCupertinoDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            CupertinoDialogAction(
              onPressed: () => Navigator.pop(context),
              child: const Text('Отмена'),
            ),
            CupertinoDialogAction(
              isDestructiveAction: true,
              onPressed: () {
                Navigator.pop(context);
                onConfirm();
              },
              child: const Text('Удалить'),
            ),
          ],
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Отмена'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                onConfirm();
              },
              child: Text(
                'Удалить',
                style: TextStyle(color: AppColors.error),
              ),
            ),
          ],
        ),
      );
    }
  }

  void _confirmRemove(
    BuildContext context,
    String productName,
    VoidCallback onConfirm,
  ) {
    final isIOS = Theme.of(context).platform == TargetPlatform.iOS;
    final title = 'Удалить товар';
    final content = 'Вы уверены что хотите удалить $productName из корзины?';

    if (isIOS) {
      showCupertinoDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            CupertinoDialogAction(
              onPressed: () => Navigator.pop(context),
              child: const Text('Отмена'),
            ),
            CupertinoDialogAction(
              isDestructiveAction: true,
              onPressed: () {
                Navigator.pop(context);
                onConfirm();
              },
              child: const Text('Удалить'),
            ),
          ],
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Отмена'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                onConfirm();
              },
              child: Text(
                'Удалить',
                style: TextStyle(color: AppColors.error),
              ),
            ),
          ],
        ),
      );
    }
  }

  Widget _buildCartContent(BuildContext context, CartLoaded state) {
    return Column(
      children: [
        Expanded(
          child: ListView.separated(
            itemCount: state.items.length,
            separatorBuilder: (context, index) =>
                Divider(color: AppColors.borderLight),
            itemBuilder: (context, index) {
              final cartItem = state.items[index];
              return CartItemWidget(
                cartItem: cartItem,
                isSelected: state.selectedProductIds.contains(
                  cartItem.product.id,
                ),
                onToggleSelection: () {
                  context.read<CartBloc>().add(
                    ToggleItemSelection(cartItem.product.id),
                  );
                },
                onRemove: () => _confirmRemove(
                  context,
                  cartItem.product.name,
                  () => context.read<CartBloc>().add(
                    RemoveFromCart(cartItem.product.id),
                  ),
                ),
                onIncrement: () {
                  context.read<CartBloc>().add(
                    UpdateQuantity(
                      productId: cartItem.product.id,
                      quantity: cartItem.quantity + 1,
                    ),
                  );
                },
                onDecrement: () {
                  if (cartItem.quantity == 1) {
                    context.read<CartBloc>().add(
                      RemoveFromCart(cartItem.product.id),
                    );
                  } else {
                    context.read<CartBloc>().add(
                      UpdateQuantity(
                        productId: cartItem.product.id,
                        quantity: cartItem.quantity - 1,
                      ),
                    );
                  }
                },
              );
            },
          ),
        ),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            color: AppColors.background,
            border: Border(top: BorderSide(color: AppColors.border, width: 1)),
          ),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                OrderSummary(
                  subtotal: state.subtotal,
                  discount: state.discount,
                  total: state.totalPrice,
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Оформление заказа в разработке'),
                          backgroundColor: AppColors.info,
                        ),
                      );
                    },
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
