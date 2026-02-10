import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../widgets/app_bottom_navigation.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/category/presentation/screens/category_screen.dart';
import '../../features/category/presentation/screens/category_products_screen.dart';
import '../../features/product/presentation/screens/product_detail_screen.dart';
import '../../features/cart/presentation/screens/cart_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../../features/favorites/presentation/screens/favorites_screen.dart';
import '../../features/order/presentation/screens/order_screen.dart';
import '../../features/orders/presentation/screens/my_orders_screen.dart';
import '../../features/profile/presentation/screens/settings_screen.dart';
import '../../features/search/presentation/screens/search_screen.dart';

/// Route names constants
class AppRoutes {
  static const String home = '/';
  static const String categories = '/categories';
  static const String category = '/category/:id';
  static const String product = '/product/:id';
  static const String cart = '/cart';
  static const String profile = '/profile';
  static const String search = '/search';
  static const String order = '/order';
  static const String favorites = '/favorites';
  static const String orders = '/orders';
  static const String settings = '/settings';

  // Helper methods to build routes with parameters
  static String categoryRoute(String id) => '/category/$id';
  static String productRoute(String id) => '/product/$id';
}

/// Application router configuration using go_router
class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: AppRoutes.home,
    routes: [
      // Shell route for screens with bottom navigation
      ShellRoute(
        builder: (context, state, child) {
          return AppBottomNavigation(child: child);
        },
        routes: [
          GoRoute(
            path: AppRoutes.home,
            name: 'home',
            pageBuilder: (context, state) =>
                NoTransitionPage(child: const HomeScreen()),
          ),
          GoRoute(
            path: AppRoutes.categories,
            name: 'categories',
            pageBuilder: (context, state) =>
                NoTransitionPage(child: const CategoryScreen()),
          ),
          GoRoute(
            path: AppRoutes.category,
            name: 'category',
            pageBuilder: (context, state) {
              final categoryId = state.pathParameters['id'] ?? 'all';
              return NoTransitionPage(
                child: CategoryProductsScreen(categoryId: categoryId),
              );
            },
          ),
          GoRoute(
            path: AppRoutes.cart,
            name: 'cart',
            pageBuilder: (context, state) =>
                NoTransitionPage(child: const CartScreen()),
          ),
          GoRoute(
            path: AppRoutes.profile,
            name: 'profile',
            pageBuilder: (context, state) =>
                NoTransitionPage(child: const ProfileScreen()),
          ),
        ],
      ),
      // Product detail route without bottom navigation
      GoRoute(
        path: AppRoutes.product,
        name: 'product',
        pageBuilder: (context, state) {
          final productId = state.pathParameters['id'] ?? '';
          final extra = state.extra is Map ? state.extra as Map : null;
          final imageUrl = extra?['imageUrl'] as String?;
          final heroTag = extra?['heroTag'] as String?;
          return MaterialPage(
            child: ProductDetailScreen(
              productId: productId,
              imageUrl: imageUrl,
              heroTag: heroTag,
            ),
          );
        },
      ),
      // Order/checkout route without bottom navigation
      GoRoute(
        path: AppRoutes.order,
        name: 'order',
        pageBuilder: (context, state) =>
            const MaterialPage(child: OrderScreen()),
      ),
      // Favorites route without bottom navigation
      GoRoute(
        path: AppRoutes.favorites,
        name: 'favorites',
        pageBuilder: (context, state) =>
            const MaterialPage(child: FavoritesScreen()),
      ),
      // My orders route without bottom navigation
      GoRoute(
        path: AppRoutes.orders,
        name: 'orders',
        pageBuilder: (context, state) =>
            const MaterialPage(child: MyOrdersScreen()),
      ),
      // Settings route without bottom navigation
      GoRoute(
        path: AppRoutes.settings,
        name: 'settings',
        pageBuilder: (context, state) =>
            const MaterialPage(child: SettingsScreen()),
      ),
      // Search route without bottom navigation
      GoRoute(
        path: AppRoutes.search,
        name: 'search',
        pageBuilder: (context, state) =>
            const NoTransitionPage(child: SearchScreen()),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      appBar: AppBar(title: const Text('Ошибка')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              'Страница не найдена',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              state.uri.toString(),
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    ),
  );
}
