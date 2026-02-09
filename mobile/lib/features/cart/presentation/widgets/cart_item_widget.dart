import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../product/presentation/widgets/quantity_selector.dart';
import '../../domain/entities/cart_item.dart';

/// Widget to display a single cart item
/// Shows product image, name, price, quantity controls, and remove button
class CartItemWidget extends StatelessWidget {
  final CartItem cartItem;
  final bool isSelected;
  final VoidCallback onToggleSelection;
  final VoidCallback onRemove;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  const CartItemWidget({
    super.key,
    required this.cartItem,
    required this.isSelected,
    required this.onToggleSelection,
    required this.onRemove,
    required this.onIncrement,
    required this.onDecrement,
  });

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat('#,###', 'ru_RU');
    final product = cartItem.product;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
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
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.darkBlue,
                                ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),

                    // Price per unit
                    Text(
                      '${formatter.format(product.price)} ₽',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppColors.secondary,
                      ),
                    ),
                  ],
                ),
              ),
              // Selection Checkbox
              GestureDetector(
                onTap: onToggleSelection,
                child: Container(
                  width: 20,
                  height: 20,
                  margin: const EdgeInsets.only(top: 4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: isSelected
                          ? AppColors.secondary
                          : AppColors.border,
                      width: isSelected ? 2 : 1.5,
                    ),
                    color: isSelected
                        ? AppColors.secondary
                        : Colors.transparent,
                  ),
                  child: isSelected
                      ? const Icon(Icons.check, size: 16, color: Colors.white)
                      : null,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Quantity Controls and Total Price
          SizedBox(
            height: 32,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              spacing: 8,
              children: [
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    color: AppColors.surface,
                  ),
                  child: SvgPicture.asset(
                    'assets/icons/favorite.svg',
                    width: 18,
                    height: 18,
                    colorFilter: ColorFilter.mode(
                      AppColors.primary,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: onRemove,
                  child: Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      color: AppColors.surface,
                    ),
                    child: SvgPicture.asset(
                      'assets/icons/trach.svg',
                      width: 18,
                      height: 18,
                      colorFilter: ColorFilter.mode(
                        AppColors.primary,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ),
                // Quantity Controls
                QuantitySelector(
                  quantity: cartItem.quantity,
                  onIncrement: onIncrement,
                  onDecrement: onDecrement,
                  minQuantity: 0,
                ),
                Spacer(),
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
          ),
        ],
      ),
    );
  }
}
