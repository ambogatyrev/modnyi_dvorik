import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/theme/app_colors.dart';

/// Quantity selector widget for product detail screen
class QuantitySelector extends StatelessWidget {
  final int quantity;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final int minQuantity;

  const QuantitySelector({
    super.key,
    required this.quantity,
    required this.onIncrement,
    required this.onDecrement,
    this.minQuantity = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: AppColors.surface,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Decrement button
          _QuantityButton(
            svgAsset: 'assets/icons/minus.svg',
            onPressed: quantity > minQuantity ? onDecrement : null,
          ),

          // Quantity display
          Container(
            constraints: const BoxConstraints(minWidth: 48),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              quantity.toString(),
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
              textAlign: TextAlign.center,
            ),
          ),

          // Increment button
          _QuantityButton(
            svgAsset: 'assets/icons/plus.svg',
            onPressed: onIncrement,
          ),
        ],
      ),
    );
  }
}

class _QuantityButton extends StatelessWidget {
  final String svgAsset;
  final VoidCallback? onPressed;

  const _QuantityButton({required this.svgAsset, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final color = onPressed != null
        ? AppColors.primary
        : AppColors.mutedForeground;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          width: 40,
          height: 40,
          alignment: Alignment.center,
          child: SvgPicture.asset(
            svgAsset,
            width: 25,
            height: 25,
            colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
          ),
        ),
      ),
    );
  }
}
