import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/data/mock_categories.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';

/// Category selector widget
/// Horizontal scrollable list of category chips
/// Navigates to category page when tapped
class CategorySelector extends StatelessWidget {
  const CategorySelector({super.key});

  @override
  Widget build(BuildContext context) {
    // Skip "all" category since home page already shows all products
    final categories = mockCategories.where((cat) => cat.id != 'all').toList();

    return SizedBox(
      height: 48,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: categories.length,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final category = categories[index];

          return _buildCategoryChip(
            context: context,
            icon: category.icon,
            label: category.name,
            onTap: () => context.push(AppRoutes.categoryRoute(category.id)),
          );
        },
      ),
    );
  }

  Widget _buildCategoryChip({
    required BuildContext context,
    required String icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.muted,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                icon,
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w500,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
