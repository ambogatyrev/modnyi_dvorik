import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';

/// Generic AppBar title with optional logo and search field
/// Logo fades out and search field expands as user scrolls (when showLogo is true)
class SearchAppBarTitle extends StatelessWidget {
  final double scrollOffset;
  final bool showLogo;

  const SearchAppBarTitle({
    super.key,
    this.scrollOffset = 0.0,
    this.showLogo = true,
  });

  @override
  Widget build(BuildContext context) {
    // Calculate animation progress (0.0 to 1.0)
    // Logo starts fading at 50px scroll, completely gone by 100px
    final fadeProgress = showLogo ? (scrollOffset / 100).clamp(0.0, 1.0) : 1.0;
    final logoOpacity = 1.0 - fadeProgress;

    // Logo size shrinks as it fades
    final logoSize = 40.0 - (fadeProgress * 10);

    return Row(
      children: [
        // Animated Logo (only shown if showLogo is true)
        if (showLogo && logoOpacity > 0)
          AnimatedOpacity(
            opacity: logoOpacity,
            duration: const Duration(milliseconds: 150),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              width: logoSize,
              height: logoSize,
              margin: const EdgeInsets.only(right: 12),
              decoration: BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
              child: ClipOval(
                child: Padding(
                  padding: const EdgeInsets.all(6),
                  child: Image.asset(
                    'assets/images/logo/logo.png',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ),

        // Animated Search Field
        Expanded(
          child: GestureDetector(
            onTap: () => context.push(AppRoutes.search),
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.muted,
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  SvgPicture.asset(
                    'assets/icons/search.svg',
                    width: 20,
                    height: 20,
                    colorFilter: ColorFilter.mode(
                      AppColors.mutedForeground,
                      BlendMode.srcIn,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Поиск товаров...',
                    style: TextStyle(
                      color: AppColors.mutedForeground,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
