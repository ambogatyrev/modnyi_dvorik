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
    on<ToggleItemSelection>(_onToggleItemSelection);
    on<SelectAllItems>(_onSelectAllItems);
    on<DeselectAllItems>(_onDeselectAllItems);
    on<RemoveSelectedItems>(_onRemoveSelectedItems);
  }

  /// Handle LoadCart event
  Future<void> _onLoadCart(
    LoadCart event,
    Emitter<CartState> emit,
  ) async {
    try {
      emit(const CartLoading());

      final items = await getCartItems();
      final selectedIds = items.map((item) => item.product.id).toSet();
      final totalPrice = _calculateTotalPrice(items, selectedIds);

      emit(CartLoaded(
        items: items,
        totalPrice: totalPrice,
        selectedProductIds: selectedIds,
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
      final currentSelected = state is CartLoaded
          ? (state as CartLoaded).selectedProductIds
          : <String>{};
      final selectedIds = {...currentSelected, event.product.id};
      final totalPrice = _calculateTotalPrice(items, selectedIds);

      emit(CartLoaded(
        items: items,
        totalPrice: totalPrice,
        selectedProductIds: selectedIds,
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
      final currentSelected = state is CartLoaded
          ? (state as CartLoaded).selectedProductIds
          : <String>{};
      final selectedIds = {...currentSelected}..remove(event.productId);
      final totalPrice = _calculateTotalPrice(items, selectedIds);

      emit(CartLoaded(
        items: items,
        totalPrice: totalPrice,
        selectedProductIds: selectedIds,
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
      final currentSelected = state is CartLoaded
          ? (state as CartLoaded).selectedProductIds
          : <String>{};
      final selectedIds = event.quantity <= 0
          ? ({...currentSelected}..remove(event.productId))
          : {...currentSelected};
      final totalPrice = _calculateTotalPrice(items, selectedIds);

      emit(CartLoaded(
        items: items,
        totalPrice: totalPrice,
        selectedProductIds: selectedIds,
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

  /// Handle ToggleItemSelection event
  void _onToggleItemSelection(
    ToggleItemSelection event,
    Emitter<CartState> emit,
  ) {
    if (state is! CartLoaded) return;
    final currentState = state as CartLoaded;

    final selectedIds = {...currentState.selectedProductIds};
    if (selectedIds.contains(event.productId)) {
      selectedIds.remove(event.productId);
    } else {
      selectedIds.add(event.productId);
    }

    final totalPrice = _calculateTotalPrice(currentState.items, selectedIds);
    emit(currentState.copyWith(
      selectedProductIds: selectedIds,
      totalPrice: totalPrice,
    ));
  }

  /// Handle SelectAllItems event
  void _onSelectAllItems(
    SelectAllItems event,
    Emitter<CartState> emit,
  ) {
    if (state is! CartLoaded) return;
    final currentState = state as CartLoaded;

    final selectedIds = currentState.items.map((item) => item.product.id).toSet();
    final totalPrice = _calculateTotalPrice(currentState.items, selectedIds);
    emit(currentState.copyWith(
      selectedProductIds: selectedIds,
      totalPrice: totalPrice,
    ));
  }

  /// Handle DeselectAllItems event
  void _onDeselectAllItems(
    DeselectAllItems event,
    Emitter<CartState> emit,
  ) {
    if (state is! CartLoaded) return;
    final currentState = state as CartLoaded;

    emit(currentState.copyWith(
      selectedProductIds: <String>{},
      totalPrice: 0.0,
    ));
  }

  /// Handle RemoveSelectedItems event
  Future<void> _onRemoveSelectedItems(
    RemoveSelectedItems event,
    Emitter<CartState> emit,
  ) async {
    if (state is! CartLoaded) return;
    final currentState = state as CartLoaded;

    try {
      for (final productId in currentState.selectedProductIds) {
        await removeFromCart(productId);
      }

      final items = await getCartItems();
      final selectedIds = <String>{};
      final totalPrice = _calculateTotalPrice(items, selectedIds);

      emit(CartLoaded(
        items: items,
        totalPrice: totalPrice,
        selectedProductIds: selectedIds,
      ));
    } catch (e) {
      emit(CartError('Не удалось удалить выбранные товары: ${e.toString()}'));
    }
  }

  /// Calculate total price from selected cart items only
  double _calculateTotalPrice(List items, Set<String> selectedProductIds) {
    return items
        .where((item) => selectedProductIds.contains(item.product.id))
        .fold<double>(0.0, (sum, item) => sum + item.totalPrice);
  }
}
