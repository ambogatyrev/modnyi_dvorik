import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

/// A key-value specification entry.
class Specification {
  final String label;
  final String value;

  const Specification({required this.label, required this.value});
}

/// Displays specifications as label–value rows separated by dividers.
class SpecificationList extends StatelessWidget {
  final String title;
  final List<Specification> specs;

  const SpecificationList({
    super.key,
    required this.title,
    required this.specs,
  });

  @override
  Widget build(BuildContext context) {
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
        ...List.generate(specs.length, (index) {
          final spec = specs[index];
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  children: [
                    Text(
                      spec.label,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      spec.value,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppColors.darkBlue,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              if (index < specs.length - 1)
                Divider(
                  height: 1,
                  color: AppColors.darkBlue.withValues(alpha: 0.1),
                ),
            ],
          );
        }),
      ],
    );
  }
}
