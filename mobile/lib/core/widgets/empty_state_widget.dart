import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Empty state widget for displaying when lists are empty
class EmptyStateWidget extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;
  final VoidCallback? onAction;
  final String? actionLabel;

  const EmptyStateWidget({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    this.onAction,
    this.actionLabel,
  });

  /// Empty cart variant
  const EmptyStateWidget.cart({
    super.key,
    this.onAction,
    this.actionLabel = 'К покупкам',
  })  : icon = Icons.shopping_cart_outlined,
        title = 'Корзина пуста',
        message = 'Добавьте товары в корзину,\nчтобы оформить заказ';

  /// Empty favorites variant
  const EmptyStateWidget.favorites({
    super.key,
    this.onAction,
    this.actionLabel = 'К покупкам',
  })  : icon = Icons.favorite_outline,
        title = 'Нет избранных товаров',
        message = 'Добавьте товары в избранное,\nчтобы не потерять их';

  /// Empty search results variant
  const EmptyStateWidget.search({
    super.key,
    this.onAction,
    this.actionLabel,
  })  : icon = Icons.search_off,
        title = 'Ничего не найдено',
        message = 'Попробуйте изменить\nпараметры поиска';

  /// Empty orders variant
  const EmptyStateWidget.orders({
    super.key,
    this.onAction,
    this.actionLabel = 'К покупкам',
  })  : icon = Icons.shopping_bag_outlined,
        title = 'У вас пока нет заказов',
        message = 'Оформите первый заказ\nи он появится здесь';

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 120,
              color: AppColors.mutedForeground,
            ),
            const SizedBox(height: 24),
            Text(
              title,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.darkBlue,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppColors.textSecondary,
                  ),
            ),
            if (onAction != null && actionLabel != null) ...[
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: onAction,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.textOnPrimary,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  actionLabel!,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
