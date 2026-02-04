import 'package:equatable/equatable.dart';

/// Search screen events
abstract class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  List<Object?> get props => [];
}

/// Event to load popular products on screen init
class LoadPopularProducts extends SearchEvent {
  const LoadPopularProducts();
}

/// Event when user types in search field
class SearchQueryChanged extends SearchEvent {
  final String query;

  const SearchQueryChanged(this.query);

  @override
  List<Object?> get props => [query];
}

/// Event to clear search and return to initial state
class ClearSearch extends SearchEvent {
  const ClearSearch();
}
