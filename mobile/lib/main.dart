import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/theme/app_theme.dart';
import 'core/router/app_router.dart';
import 'features/cart/data/repositories/cart_repository_impl.dart';
import 'features/cart/domain/usecases/add_to_cart.dart' as usecases;
import 'features/cart/domain/usecases/get_cart_items.dart';
import 'features/cart/domain/usecases/remove_from_cart.dart' as usecases;
import 'features/cart/domain/usecases/update_cart_quantity.dart';
import 'features/cart/presentation/bloc/cart_bloc.dart';
import 'features/cart/presentation/bloc/cart_event.dart';
import 'features/favorites/data/repositories/favorites_repository_impl.dart';
import 'features/favorites/domain/usecases/add_to_favorites.dart';
import 'features/favorites/domain/usecases/get_favorites.dart';
import 'features/favorites/domain/usecases/remove_from_favorites.dart';
import 'features/favorites/presentation/cubit/favorites_cubit.dart';

void main() {
  runApp(const ModnyiDvorikApp());
}

class ModnyiDvorikApp extends StatelessWidget {
  const ModnyiDvorikApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Create cart repository and use cases (MVP - in-memory storage)
    final cartRepository = CartRepositoryImpl();
    final getCartItems = GetCartItems(cartRepository);
    final addToCart = usecases.AddToCart(cartRepository);
    final removeFromCart = usecases.RemoveFromCart(cartRepository);
    final updateCartQuantity = UpdateCartQuantity(cartRepository);

    // Create favorites repository and use cases (MVP - in-memory storage)
    final favoritesRepository = FavoritesRepositoryImpl();
    final getFavorites = GetFavorites(favoritesRepository);
    final addToFavorites = AddToFavorites(favoritesRepository);
    final removeFromFavorites = RemoveFromFavorites(favoritesRepository);

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => CartBloc(
            getCartItems: getCartItems,
            addToCart: addToCart,
            removeFromCart: removeFromCart,
            updateCartQuantity: updateCartQuantity,
          )..add(const LoadCart()),
        ),
        BlocProvider(
          create: (context) => FavoritesCubit(
            getFavorites: getFavorites,
            addToFavorites: addToFavorites,
            removeFromFavorites: removeFromFavorites,
          )..loadFavorites(),
        ),
      ],
      child: MaterialApp.router(
        title: 'Модный дворик',
        theme: AppTheme.lightTheme,
        debugShowCheckedModeBanner: false,
        routerConfig: AppRouter.router,
      ),
    );
  }
}
