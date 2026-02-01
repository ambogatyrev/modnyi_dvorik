import 'package:equatable/equatable.dart';
import '../../../home/domain/entities/product.dart';

/// Product detail screen state
class ProductDetailState extends Equatable {
  final Product? product;
  final int quantity;
  final bool isFavorite;
  final bool isLoading;
  final String? error;

  const ProductDetailState({
    this.product,
    this.quantity = 1,
    this.isFavorite = false,
    this.isLoading = false,
    this.error,
  });

  /// Initial state
  factory ProductDetailState.initial() {
    return const ProductDetailState();
  }

  /// Loading state
  factory ProductDetailState.loading() {
    return const ProductDetailState(isLoading: true);
  }

  /// Loaded state
  factory ProductDetailState.loaded(Product product) {
    return ProductDetailState(
      product: product,
      quantity: 1,
      isFavorite: false,
      isLoading: false,
    );
  }

  /// Error state
  factory ProductDetailState.error(String message) {
    return ProductDetailState(error: message);
  }

  /// Create a copy with modified fields
  ProductDetailState copyWith({
    Product? product,
    int? quantity,
    bool? isFavorite,
    bool? isLoading,
    String? error,
  }) {
    return ProductDetailState(
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
      isFavorite: isFavorite ?? this.isFavorite,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [product, quantity, isFavorite, isLoading, error];
}
