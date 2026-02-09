/// Mock in-memory favorites storage for MVP stage
/// This simulates a persistent storage but data is lost when app restarts
class MockFavoritesStorage {
  // Singleton pattern for shared favorites storage across the app
  static final MockFavoritesStorage _instance =
      MockFavoritesStorage._internal();
  factory MockFavoritesStorage() => _instance;
  MockFavoritesStorage._internal();

  // In-memory favorites storage (set of product IDs)
  final Set<String> _favoriteIds = {};

  /// Get all favorite product IDs
  Set<String> getFavoriteIds() {
    return Set.unmodifiable(_favoriteIds);
  }

  /// Add a product to favorites
  void add(String productId) {
    _favoriteIds.add(productId);
  }

  /// Remove a product from favorites
  void remove(String productId) {
    _favoriteIds.remove(productId);
  }

  /// Check if a product is in favorites
  bool isFavorite(String productId) {
    return _favoriteIds.contains(productId);
  }

  /// Clear all favorites
  void clear() {
    _favoriteIds.clear();
  }

  /// Check if favorites is empty
  bool get isEmpty => _favoriteIds.isEmpty;

  /// Get number of favorites
  int get length => _favoriteIds.length;
}
