import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stream_transform/stream_transform.dart';
import '../../domain/usecases/get_popular_products.dart';
import '../../domain/usecases/search_products.dart';
import 'search_event.dart';
import 'search_state.dart';

/// Custom transformer for debouncing events
EventTransformer<Event> debounce<Event>(Duration duration) {
  return (events, mapper) => events.debounce(duration).switchMap(mapper);
}

/// Search BLoC for managing search screen state
class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final SearchProducts searchProducts;
  final GetPopularProducts getPopularProducts;

  SearchBloc({
    required this.searchProducts,
    required this.getPopularProducts,
  }) : super(const SearchInitial()) {
    on<LoadPopularProducts>(_onLoadPopularProducts);
    on<SearchQueryChanged>(
      _onSearchQueryChanged,
      transformer: debounce(const Duration(milliseconds: 300)),
    );
    on<ClearSearch>(_onClearSearch);
  }

  /// Handle LoadPopularProducts event
  Future<void> _onLoadPopularProducts(
    LoadPopularProducts event,
    Emitter<SearchState> emit,
  ) async {
    try {
      final products = await getPopularProducts();
      emit(SearchInitial(popularProducts: products));
    } catch (e) {
      emit(SearchError('Не удалось загрузить популярные товары: ${e.toString()}'));
    }
  }

  /// Handle SearchQueryChanged event with debouncing
  Future<void> _onSearchQueryChanged(
    SearchQueryChanged event,
    Emitter<SearchState> emit,
  ) async {
    final query = event.query.trim();

    // If query is empty, show initial state with popular products
    if (query.isEmpty) {
      try {
        final products = await getPopularProducts();
        emit(SearchInitial(popularProducts: products));
      } catch (e) {
        emit(SearchError('Не удалось загрузить популярные товары: ${e.toString()}'));
      }
      return;
    }

    try {
      emit(const SearchLoading());

      // Perform search
      final products = await searchProducts(query);

      if (products.isEmpty) {
        emit(SearchEmpty(query));
      } else {
        emit(SearchLoaded(products: products, query: query));
      }
    } catch (e) {
      emit(SearchError('Ошибка поиска: ${e.toString()}'));
    }
  }

  /// Handle ClearSearch event
  Future<void> _onClearSearch(
    ClearSearch event,
    Emitter<SearchState> emit,
  ) async {
    try {
      final products = await getPopularProducts();
      emit(SearchInitial(popularProducts: products));
    } catch (e) {
      emit(SearchError('Не удалось загрузить популярные товары: ${e.toString()}'));
    }
  }
}
