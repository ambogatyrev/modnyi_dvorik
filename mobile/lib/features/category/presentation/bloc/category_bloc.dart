import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/data/mock_categories.dart';
import '../../../home/domain/usecases/get_products_by_category.dart';
import 'category_event.dart';
import 'category_state.dart';

/// Category BLoC for managing category screen state
class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final GetProductsByCategory getProductsByCategory;

  CategoryBloc({
    required this.getProductsByCategory,
  }) : super(const CategoryInitial()) {
    on<LoadCategoryProducts>(_onLoadCategoryProducts);
  }

  /// Handle LoadCategoryProducts event
  Future<void> _onLoadCategoryProducts(
    LoadCategoryProducts event,
    Emitter<CategoryState> emit,
  ) async {
    try {
      emit(const CategoryLoading());

      // Get products by category
      final products = await getProductsByCategory(event.categoryId);

      // Get category name
      final categoryName = getCategoryName(event.categoryId);

      emit(CategoryLoaded(
        products: products,
        categoryId: event.categoryId,
        categoryName: categoryName,
      ));
    } catch (e) {
      emit(CategoryError('Не удалось загрузить товары: ${e.toString()}'));
    }
  }
}
