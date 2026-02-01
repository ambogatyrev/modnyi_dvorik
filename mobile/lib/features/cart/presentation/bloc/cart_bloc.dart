import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/add_to_cart.dart' as usecases;
import '../../domain/usecases/get_cart_items.dart';
import '../../domain/usecases/remove_from_cart.dart' as usecases;
import '../../domain/usecases/update_cart_quantity.dart';
import 'cart_event.dart';
import 'cart_state.dart';

/// BLoC for managing shopping cart state
/// Handles cart operations and persists data using repository
class CartBloc extends Bloc<CartEvent, CartState> {
  final GetCartItems getCartItems;
  final usecases.AddToCart addToCart;
  final usecases.RemoveFromCart removeFromCart;
  final UpdateCartQuantity updateCartQuantity;

  CartBloc({
    required this.getCartItems,
    required this.addToCart,
    required this.removeFromCart,
    required this.updateCartQuantity,
  }) : super(const CartInitial()) {
    // Register event handlers
    on<LoadCart>(_onLoadCart);
    on<AddToCart>(_onAddToCart);
    on<RemoveFromCart>(_onRemoveFromCart);
    on<UpdateQuantity>(_onUpdateQuantity);
    on<ClearCart>(_onClearCart);
  }

  /// Handle LoadCart event
  Future<void> _onLoadCart(
    LoadCart event,
    Emitter<CartState> emit,
  ) async {
    try {
      emit(const CartLoading());

      final items = await getCartItems();
      final totalPrice = _calculateTotalPrice(items);

      emit(CartLoaded(
        items: items,
        totalPrice: totalPrice,
      ));
    } catch (e) {
      emit(CartError('Не удалось загрузить корзину: ${e.toString()}'));
    }
  }

  /// Handle AddToCart event
  Future<void> _onAddToCart(
    AddToCart event,
    Emitter<CartState> emit,
  ) async {
    try {
      await addToCart(event.product, event.quantity);

      // Reload cart after adding
      final items = await getCartItems();
      final totalPrice = _calculateTotalPrice(items);

      emit(CartLoaded(
        items: items,
        totalPrice: totalPrice,
      ));
    } catch (e) {
      emit(CartError('Не удалось добавить товар в корзину: ${e.toString()}'));
    }
  }

  /// Handle RemoveFromCart event
  Future<void> _onRemoveFromCart(
    RemoveFromCart event,
    Emitter<CartState> emit,
  ) async {
    try {
      await removeFromCart(event.productId);

      // Reload cart after removing
      final items = await getCartItems();
      final totalPrice = _calculateTotalPrice(items);

      emit(CartLoaded(
        items: items,
        totalPrice: totalPrice,
      ));
    } catch (e) {
      emit(CartError('Не удалось удалить товар из корзины: ${e.toString()}'));
    }
  }

  /// Handle UpdateQuantity event
  Future<void> _onUpdateQuantity(
    UpdateQuantity event,
    Emitter<CartState> emit,
  ) async {
    try {
      if (event.quantity <= 0) {
        // If quantity is 0 or less, remove the item
        await removeFromCart(event.productId);
      } else {
        await updateCartQuantity(event.productId, event.quantity);
      }

      // Reload cart after updating
      final items = await getCartItems();
      final totalPrice = _calculateTotalPrice(items);

      emit(CartLoaded(
        items: items,
        totalPrice: totalPrice,
      ));
    } catch (e) {
      emit(CartError(
          'Не удалось обновить количество товара: ${e.toString()}'));
    }
  }

  /// Handle ClearCart event
  Future<void> _onClearCart(
    ClearCart event,
    Emitter<CartState> emit,
  ) async {
    try {
      // Get current items and remove them all
      final items = await getCartItems();
      for (final item in items) {
        await removeFromCart(item.product.id);
      }

      emit(const CartLoaded(
        items: [],
        totalPrice: 0.0,
      ));
    } catch (e) {
      emit(CartError('Не удалось очистить корзину: ${e.toString()}'));
    }
  }

  /// Calculate total price from cart items
  double _calculateTotalPrice(List items) {
    return items.fold<double>(
      0.0,
      (sum, item) => sum + item.totalPrice,
    );
  }
}
