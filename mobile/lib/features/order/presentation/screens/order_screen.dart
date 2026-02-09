import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../cart/domain/entities/cart_item.dart';
import '../../../cart/presentation/bloc/cart_bloc.dart';
import '../../../cart/presentation/bloc/cart_event.dart';
import '../../../cart/presentation/bloc/cart_state.dart';
import '../../domain/entities/delivery_method.dart';
import '../widgets/order_item_tile.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  DeliveryMethod _deliveryMethod = DeliveryMethod.courier;
  bool _removeFromCart = true;
  final _addressController = TextEditingController();

  late final List<CartItem> _selectedItems;
  late final double _total;

  @override
  void initState() {
    super.initState();
    final cartState = context.read<CartBloc>().state;
    if (cartState is CartLoaded) {
      _selectedItems = cartState.items
          .where(
            (item) => cartState.selectedProductIds.contains(item.product.id),
          )
          .toList();
      _total = cartState.subtotal;
    } else {
      _selectedItems = [];
      _total = 0;
    }
  }

  @override
  void dispose() {
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat('#,###', 'ru_RU');

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Оформление заказа')),
      body: _selectedItems.isEmpty
          ? Center(
              child: Text(
                'Нет выбранных товаров',
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(color: AppColors.textSecondary),
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Delivery method
                  Text(
                    'Способ доставки',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.darkBlue,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildDeliveryMethodSelector(),
                  const SizedBox(height: 24),

                  // Address (hidden for pickup)
                  if (_deliveryMethod != DeliveryMethod.pickup) ...[
                    Text(
                      'Адрес доставки',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.darkBlue,
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _addressController,
                      decoration: InputDecoration(
                        hintText: 'Введите адрес',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: AppColors.border),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: AppColors.border),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: AppColors.primary,
                            width: 2,
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],

                  // Order items
                  Text(
                    'Ваш заказ',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.darkBlue,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ...List.generate(_selectedItems.length, (index) {
                    return OrderItemTile(cartItem: _selectedItems[index]);
                  }),
                  const SizedBox(height: 12),
                  // Remove from cart checkbox
                  GestureDetector(
                    onTap: () =>
                        setState(() => _removeFromCart = !_removeFromCart),
                    child: Row(
                      children: [
                        Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color: _removeFromCart
                                  ? AppColors.secondary
                                  : AppColors.border,
                              width: _removeFromCart ? 2 : 1.5,
                            ),
                            color: _removeFromCart
                                ? AppColors.secondary
                                : Colors.transparent,
                          ),
                          child: _removeFromCart
                              ? const Icon(
                                  Icons.check,
                                  size: 16,
                                  color: Colors.white,
                                )
                              : null,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Удалить товары из корзины после оформления',
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(color: AppColors.textSecondary),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Divider(color: AppColors.border),
                  const SizedBox(height: 12),
                  // Total
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Итого',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: AppColors.darkBlue,
                        ),
                      ),
                      Text(
                        '${formatter.format(_total)} ₽',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: AppColors.secondary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
      bottomNavigationBar: _selectedItems.isNotEmpty
          ? Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: AppColors.background,
                border: Border(
                  top: BorderSide(color: AppColors.border, width: 1),
                ),
              ),
              child: SafeArea(
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _placeOrder,
                    child: const Text(
                      'Оформить заказ',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            )
          : null,
    );
  }

  Widget _buildDeliveryMethodSelector() {
    return Row(
      children: DeliveryMethod.values.map((method) {
        final isSelected = _deliveryMethod == method;
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(
              right: method != DeliveryMethod.values.last ? 8 : 0,
            ),
            child: GestureDetector(
              onTap: () => setState(() => _deliveryMethod = method),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary : AppColors.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected ? AppColors.primary : AppColors.border,
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  method.label,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: isSelected
                        ? AppColors.textOnPrimary
                        : AppColors.darkBlue,
                  ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  void _placeOrder() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: const Text('Заказ оформлен'),
        content: const Text(
          'Спасибо за заказ! Мы свяжемся с вами в ближайшее время.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              if (_removeFromCart) {
                context.read<CartBloc>().add(const RemoveSelectedItems());
              }
              context.go('/');
            },
            child: const Text('Ок'),
          ),
        ],
      ),
    );
  }
}
