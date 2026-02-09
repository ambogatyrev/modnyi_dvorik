import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../data/repositories/search_repository_impl.dart';
import '../../domain/usecases/get_popular_products.dart';
import '../../domain/usecases/search_products.dart';
import '../bloc/search_bloc.dart';
import '../bloc/search_event.dart';
import '../bloc/search_state.dart';
import '../widgets/search_app_bar.dart';
import '../widgets/search_results_grid.dart';

/// Search screen with animated search bar and results
class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  late final SearchBloc _searchBloc;
  late final AnimationController _slideController;
  late final Animation<Offset> _slideAnimation;
  late final Animation<double> _fadeAnimation;
  bool _hasPlayedInitialAnimation = false;

  @override
  void initState() {
    super.initState();

    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.15), end: Offset.zero).animate(
          CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
        );
    _fadeAnimation = CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOut,
    );

    // Initialize repository and use cases
    final repository = SearchRepositoryImpl();
    final searchProducts = SearchProducts(repository);
    final getPopularProducts = GetPopularProducts(repository);

    // Initialize SearchBloc
    _searchBloc = SearchBloc(
      searchProducts: searchProducts,
      getPopularProducts: getPopularProducts,
    );

    // Load popular products on init
    _searchBloc.add(const LoadPopularProducts());
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchBloc.close();
    _slideController.dispose();
    super.dispose();
  }

  void _handleQueryChanged(String query) {
    _searchBloc.add(SearchQueryChanged(query));
  }

  void _handleCancel() {
    _searchBloc.add(const ClearSearch());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _searchBloc,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: SearchAppBar(
          controller: _searchController,
          onQueryChanged: _handleQueryChanged,
          onCancel: _handleCancel,
        ),
        body: BlocBuilder<SearchBloc, SearchState>(
          builder: (context, state) {
            if (state is SearchInitial) {
              return _buildInitialState(state);
            } else if (state is SearchLoading) {
              return _buildLoadingState();
            } else if (state is SearchLoaded) {
              return _buildLoadedState(state);
            } else if (state is SearchEmpty) {
              return _buildEmptyState(state);
            } else if (state is SearchError) {
              return _buildErrorState(state);
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  /// Build initial state showing popular products
  Widget _buildInitialState(SearchInitial state) {
    if (state.popularProducts.isEmpty) {
      return Center(
        child: Text(
          'Введите запрос для поиска',
          style: TextStyle(fontSize: 16, color: AppColors.mutedForeground),
        ),
      );
    }

    if (!_hasPlayedInitialAnimation) {
      _hasPlayedInitialAnimation = true;
      _slideController.forward(from: 0);
    }

    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: SearchResultsGrid(products: state.popularProducts)),
          ],
        ),
      ),
    );
  }

  /// Build loading state
  Widget _buildLoadingState() {
    return const Center(child: CircularProgressIndicator());
  }

  /// Build loaded state with search results
  Widget _buildLoadedState(SearchLoaded state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(
            'Найдено: ${state.products.length}',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(color: AppColors.mutedForeground),
          ),
        ),
        Expanded(child: SearchResultsGrid(products: state.products)),
      ],
    );
  }

  /// Build empty state when no results found
  Widget _buildEmptyState(SearchEmpty state) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 64, color: AppColors.mutedForeground),
          const SizedBox(height: 16),
          Text(
            'Ничего не найдено',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Text(
            'Попробуйте изменить запрос',
            style: TextStyle(fontSize: 16, color: AppColors.mutedForeground),
          ),
        ],
      ),
    );
  }

  /// Build error state
  Widget _buildErrorState(SearchError state) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: AppColors.error),
          const SizedBox(height: 16),
          Text(
            'Ошибка',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              state.message,
              style: TextStyle(fontSize: 16, color: AppColors.mutedForeground),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
