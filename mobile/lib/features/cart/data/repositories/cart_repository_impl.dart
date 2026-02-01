import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../home/domain/entities/product.dart';
import '../../domain/entities/cart_item.dart';
import '../../domain/repositories/cart_repository.dart';
import '../models/cart_item_model.dart';
import '../../../home/data/models/product_model.dart';

/// Cart repository implementation with shared_preferences for persistence
class CartRepositoryImpl implements CartRepository {
  static const String _cartKey = 'shopping_cart';
  final SharedPreferences _prefs;

  CartRepositoryImpl(this._prefs);

  @override
  Future<List<CartItem>> getCartItems() async {
    final cartJson = _prefs.getString(_cartKey);
    if (cartJson == null || cartJson.isEmpty) {
      return [];
    }

    try {
      final List<dynamic> cartList = json.decode(cartJson);
      final cartModels = cartList
          .map((item) => CartItemModel.fromJson(item as Map<String, dynamic>))
          .toList();

      return cartModels.map((model) => _mapToEntity(model)).toList();
    } catch (e) {
      // If there's an error parsing, return empty cart
      return [];
    }
  }

  @override
  Future<void> addToCart(Product product, int quantity) async {
    final cartItems = await getCartItems();

    // Check if product already exists in cart
    final existingIndex = cartItems.indexWhere(
      (item) => item.product.id == product.id,
    );

    List<CartItemModel> cartModels;
    if (existingIndex != -1) {
      // Update existing item quantity
      cartModels = cartItems.map((item) {
        if (item.product.id == product.id) {
          return CartItemModel(
            product: _mapProductToModel(product),
            quantity: item.quantity + quantity,
          );
        }
        return _mapToModel(item);
      }).toList();
    } else {
      // Add new item
      cartModels = [
        ...cartItems.map(_mapToModel),
        CartItemModel(
          product: _mapProductToModel(product),
          quantity: quantity,
        ),
      ];
    }

    await _saveCart(cartModels);
  }

  @override
  Future<void> removeFromCart(String productId) async {
    final cartItems = await getCartItems();
    final updatedItems = cartItems
        .where((item) => item.product.id != productId)
        .map(_mapToModel)
        .toList();

    await _saveCart(updatedItems);
  }

  @override
  Future<void> updateCartQuantity(String productId, int quantity) async {
    if (quantity <= 0) {
      await removeFromCart(productId);
      return;
    }

    final cartItems = await getCartItems();
    final updatedItems = cartItems.map((item) {
      if (item.product.id == productId) {
        return CartItemModel(
          product: _mapProductToModel(item.product),
          quantity: quantity,
        );
      }
      return _mapToModel(item);
    }).toList();

    await _saveCart(updatedItems);
  }

  @override
  Future<void> clearCart() async {
    await _prefs.remove(_cartKey);
  }

  @override
  Future<int> getCartItemCount() async {
    final cartItems = await getCartItems();
    return cartItems.fold<int>(0, (sum, item) => sum + item.quantity);
  }

  @override
  Future<double> getCartTotal() async {
    final cartItems = await getCartItems();
    return cartItems.fold<double>(0.0, (sum, item) => sum + item.totalPrice);
  }

  /// Save cart to shared preferences
  Future<void> _saveCart(List<CartItemModel> cartModels) async {
    final cartJson = json.encode(
      cartModels.map((model) => model.toJson()).toList(),
    );
    await _prefs.setString(_cartKey, cartJson);
  }

  /// Map CartItem entity to CartItemModel
  CartItemModel _mapToModel(CartItem entity) {
    return CartItemModel(
      product: _mapProductToModel(entity.product),
      quantity: entity.quantity,
    );
  }

  /// Map CartItemModel to CartItem entity
  CartItem _mapToEntity(CartItemModel model) {
    return CartItem(
      product: Product(
        id: model.product.id,
        name: model.product.name,
        price: model.product.price,
        image: model.product.image,
        category: model.product.category,
      ),
      quantity: model.quantity,
    );
  }

  /// Map Product entity to ProductModel
  ProductModel _mapProductToModel(Product entity) {
    return ProductModel(
      id: entity.id,
      name: entity.name,
      price: entity.price,
      image: entity.image,
      category: entity.category,
    );
  }
}
