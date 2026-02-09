import 'package:equatable/equatable.dart';
import '../../domain/entities/cart_item.dart';

/// Base class for all cart states
abstract class CartState extends Equatable {
  const CartState();

  @override
  List<Object?> get props => [];
}

/// Initial state when cart is first created
class CartInitial extends CartState {
  const CartInitial();
}

/// State when cart is loading
class CartLoading extends CartState {
  const CartLoading();
}

/// State when cart is loaded successfully
class CartLoaded extends CartState {
  final List<CartItem> items;
  final double totalPrice;
  final double discount;
  final Set<String> selectedProductIds;

  const CartLoaded({
    required this.items,
    required this.totalPrice,
    this.discount = 0.0,
    this.selectedProductIds = const {},
  });

  /// Calculate subtotal (before discount) for selected items only
  double get subtotal => items
      .where((item) => selectedProductIds.contains(item.product.id))
      .fold<double>(0.0, (sum, item) => sum + item.totalPrice);

  /// Total number of items in cart
  int get itemCount => items.fold<int>(
        0,
        (sum, item) => sum + item.quantity,
      );

  /// Check if cart is empty
  bool get isEmpty => items.isEmpty;

  /// Whether all items are currently selected
  bool get allSelected =>
      items.isNotEmpty &&
      items.every((item) => selectedProductIds.contains(item.product.id));

  /// Number of selected items
  int get selectedCount => selectedProductIds.length;

  @override
  List<Object?> get props => [items, totalPrice, discount, selectedProductIds];

  /// Create a copy of this state with updated values
  CartLoaded copyWith({
    List<CartItem>? items,
    double? totalPrice,
    double? discount,
    Set<String>? selectedProductIds,
  }) {
    return CartLoaded(
      items: items ?? this.items,
      totalPrice: totalPrice ?? this.totalPrice,
      discount: discount ?? this.discount,
      selectedProductIds: selectedProductIds ?? this.selectedProductIds,
    );
  }
}

/// State when there's an error with cart operations
class CartError extends CartState {
  final String message;

  const CartError(this.message);

  @override
  List<Object?> get props => [message];
}
