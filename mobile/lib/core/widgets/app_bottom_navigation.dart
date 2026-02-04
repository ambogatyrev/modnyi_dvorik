import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import '../router/app_router.dart';
import '../theme/app_colors.dart';

/// Application bottom navigation bar
/// Provides navigation to main app sections
class AppBottomNavigation extends StatelessWidget {
  final Widget child;

  const AppBottomNavigation({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: _buildBottomNavigationBar(context),
    );
  }

  Widget _buildBottomNavigationBar(BuildContext context) {
    final currentLocation = GoRouterState.of(context).uri.toString();
    final selectedIndex = _getSelectedIndex(currentLocation);

    return BottomNavigationBar(
      currentIndex: selectedIndex,
      onTap: (index) => _onItemTapped(context, index),
      type: BottomNavigationBarType.fixed,
      selectedItemColor: AppColors.primary,
      unselectedItemColor: AppColors.darkBlue,
      selectedFontSize: 12,
      unselectedFontSize: 12,
      items: [
        BottomNavigationBarItem(
          icon: _buildSvgIcon('assets/icons/home.svg', AppColors.darkBlue),
          activeIcon: _buildSvgIcon('assets/icons/home.svg', AppColors.primary),
          label: 'Главная',
        ),
        BottomNavigationBarItem(
          icon: _buildSvgIcon('assets/icons/catalog.svg', AppColors.darkBlue),
          activeIcon: _buildSvgIcon(
            'assets/icons/catalog.svg',
            AppColors.primary,
          ),
          label: 'Каталог',
        ),
        BottomNavigationBarItem(
          icon: _buildSvgIcon('assets/icons/shop_cart.svg', AppColors.darkBlue),
          activeIcon: _buildSvgIcon(
            'assets/icons/shop_cart.svg',
            AppColors.primary,
          ),
          label: 'Корзина',
        ),
        BottomNavigationBarItem(
          icon: _buildSvgIcon('assets/icons/user.svg', AppColors.darkBlue),
          activeIcon: _buildSvgIcon('assets/icons/user.svg', AppColors.primary),
          label: 'Профиль',
        ),
      ],
    );
  }

  Widget _buildSvgIcon(String assetPath, Color color) {
    return SvgPicture.asset(
      assetPath,
      width: 24,
      height: 24,
      colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
    );
  }

  int _getSelectedIndex(String location) {
    if (location == AppRoutes.home) {
      return 0;
    } else if (location == AppRoutes.categories || location.startsWith('/category')) {
      return 1;
    } else if (location == AppRoutes.cart) {
      return 2;
    } else if (location == AppRoutes.profile) {
      return 3;
    }
    return 0; // Default to home
  }

  void _onItemTapped(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go(AppRoutes.home);
        break;
      case 1:
        context.go(AppRoutes.categories);
        break;
      case 2:
        context.go(AppRoutes.cart);
        break;
      case 3:
        context.go(AppRoutes.profile);
        break;
    }
  }
}
