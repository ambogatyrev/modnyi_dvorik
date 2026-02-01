import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';

/// Widget to display order summary with pricing breakdown
/// Shows subtotal, discount, and total price
class OrderSummary extends StatelessWidget {
  final double subtotal;
  final double discount;
  final double total;

  const OrderSummary({
    super.key,
    required this.subtotal,
    this.discount = 0.0,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat('#,###', 'ru_RU');

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.border,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Text(
            'Итого',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.darkBlue,
                ),
          ),
          const SizedBox(height: 16),

          // Subtotal (Goods price)
          _buildPriceRow(
            context,
            label: 'Стоимость товаров',
            value: '${formatter.format(subtotal)} ₽',
            isRegular: true,
          ),

          // Discount (if any)
          if (discount > 0) ...[
            const SizedBox(height: 8),
            _buildPriceRow(
              context,
              label: 'Скидка',
              value: '−${formatter.format(discount)} ₽',
              isDiscount: true,
            ),
          ],

          const SizedBox(height: 12),

          // Divider
          const Divider(
            color: AppColors.border,
            thickness: 1,
          ),

          const SizedBox(height: 12),

          // Total
          _buildPriceRow(
            context,
            label: 'Итого',
            value: '${formatter.format(total)} ₽',
            isTotal: true,
          ),
        ],
      ),
    );
  }

  Widget _buildPriceRow(
    BuildContext context, {
    required String label,
    required String value,
    bool isRegular = false,
    bool isDiscount = false,
    bool isTotal = false,
  }) {
    final labelStyle = isTotal
        ? Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: AppColors.darkBlue,
            )
        : Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: AppColors.textSecondary,
            );

    final valueStyle = isTotal
        ? Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
              color: AppColors.primary,
            )
        : isDiscount
            ? Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppColors.success,
                  fontWeight: FontWeight.w600,
                )
            : Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppColors.darkBlue,
                  fontWeight: FontWeight.w600,
                );

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: labelStyle),
        Text(value, style: valueStyle),
      ],
    );
  }
}
