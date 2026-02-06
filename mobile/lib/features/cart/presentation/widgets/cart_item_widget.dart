import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/cart_item.dart';

/// Widget to display a single cart item
/// Shows product image, name, price, quantity controls, and remove button
class CartItemWidget extends StatelessWidget {
  final CartItem cartItem;
  final VoidCallback onRemove;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  const CartItemWidget({
    super.key,
    required this.cartItem,
    required this.onRemove,
    required this.onIncrement,
    required this.onDecrement,
  });

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat('#,###', 'ru_RU');
    final product = cartItem.product;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.border,
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product Image
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: CachedNetworkImage(
              imageUrl: product.image,
              width: 80,
              height: 80,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                color: AppColors.muted,
                child: const Center(
                  child: CircularProgressIndicator(
                    color: AppColors.primary,
                    strokeWidth: 2,
                  ),
                ),
              ),
              errorWidget: (context, url, error) => Container(
                color: AppColors.muted,
                child: const Icon(
                  Icons.image_not_supported,
                  size: 32,
                  color: AppColors.mutedForeground,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),

          // Product Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product Name and Remove Button
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        product.name,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: AppColors.darkBlue,
                            ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Remove Button
                    InkWell(
                      onTap: onRemove,
                      borderRadius: BorderRadius.circular(4),
                      child: Padding(
                        padding: const EdgeInsets.all(4),
                        child: Icon(
                          Icons.delete_outline,
                          size: 20,
                          color: AppColors.error,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),

                // Price per unit
                Text(
                  '${formatter.format(product.price)} ₽',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                ),
                const SizedBox(height: 12),

                // Quantity Controls and Total Price
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Quantity Controls
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: AppColors.border,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Decrement button
                          _QuantityButton(
                            icon: Icons.remove,
                            onPressed: onDecrement,
                          ),

                          // Quantity display
                          Container(
                            constraints: const BoxConstraints(minWidth: 40),
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Text(
                              cartItem.quantity.toString(),
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall
                                  ?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                              textAlign: TextAlign.center,
                            ),
                          ),

                          // Increment button
                          _QuantityButton(
                            icon: Icons.add,
                            onPressed: onIncrement,
                          ),
                        ],
                      ),
                    ),

                    // Total Price for this item
                    Text(
                      '${formatter.format(cartItem.totalPrice)} ₽',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
                          ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Internal widget for quantity control buttons
class _QuantityButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;

  const _QuantityButton({
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          width: 32,
          height: 32,
          alignment: Alignment.center,
          child: Icon(
            icon,
            size: 16,
            color: onPressed != null
                ? AppColors.primary
                : AppColors.mutedForeground,
          ),
        ),
      ),
    );
  }
}
