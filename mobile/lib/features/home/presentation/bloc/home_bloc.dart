import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_products.dart';
import '../../domain/usecases/get_products_by_category.dart';
import 'home_event.dart';
import 'home_state.dart';

/// Home BLoC for managing home screen state
class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final GetProducts getProducts;
  final GetProductsByCategory getProductsByCategory;

  HomeBloc({
    required this.getProducts,
    required this.getProductsByCategory,
  }) : super(const HomeInitial()) {
    on<LoadProducts>(_onLoadProducts);
    on<SelectCategory>(_onSelectCategory);
  }

  /// Handle LoadProducts event
  Future<void> _onLoadProducts(
    LoadProducts event,
    Emitter<HomeState> emit,
  ) async {
    try {
      emit(const HomeLoading());

      // Get all products
      final products = await getProducts();

      emit(HomeLoaded(
        products: products,
        selectedCategory: 'all',
      ));
    } catch (e) {
      emit(HomeError('Не удалось загрузить товары: ${e.toString()}'));
    }
  }

  /// Handle SelectCategory event
  Future<void> _onSelectCategory(
    SelectCategory event,
    Emitter<HomeState> emit,
  ) async {
    try {
      // Show loading if state is not already loaded
      if (state is! HomeLoaded) {
        emit(const HomeLoading());
      }

      // Get products by category
      final products = await getProductsByCategory(event.categoryId);

      emit(HomeLoaded(
        products: products,
        selectedCategory: event.categoryId,
      ));
    } catch (e) {
      emit(HomeError('Не удалось загрузить товары: ${e.toString()}'));
    }
  }
}
