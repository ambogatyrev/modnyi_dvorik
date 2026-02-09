import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../home/domain/usecases/get_product_by_id.dart';
import 'product_detail_state.dart';

/// Product detail Cubit for managing product detail screen state
class ProductDetailCubit extends Cubit<ProductDetailState> {
  final GetProductById getProductById;

  ProductDetailCubit({
    required this.getProductById,
  }) : super(ProductDetailState.initial());

  /// Load product by ID
  Future<void> loadProduct(String productId) async {
    try {
      emit(ProductDetailState.loading());

      final product = await getProductById(productId);

      if (product == null) {
        emit(ProductDetailState.error('Товар не найден'));
        return;
      }

      emit(ProductDetailState.loaded(product));
    } catch (e) {
      emit(ProductDetailState.error('Не удалось загрузить товар: ${e.toString()}'));
    }
  }

  /// Increment quantity
  void incrementQuantity() {
    if (state.product != null) {
      emit(state.copyWith(quantity: state.quantity + 1));
    }
  }

  /// Decrement quantity (minimum 1)
  void decrementQuantity() {
    if (state.product != null && state.quantity > 1) {
      emit(state.copyWith(quantity: state.quantity - 1));
    }
  }

}
