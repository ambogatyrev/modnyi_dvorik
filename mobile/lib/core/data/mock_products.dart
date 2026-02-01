import '../../features/home/data/models/product_model.dart';

/// Mock product data matching the web application
/// All 8 products from the web app with Unsplash image URLs
final List<ProductModel> mockProducts = [
  // Face Care products (4 items)
  const ProductModel(
    id: '1',
    name: 'Увлажняющий крем для лица',
    price: 1299.0,
    image: 'https://images.unsplash.com/photo-1556229010-aa62e6e1e4d8?w=400',
    category: 'face',
  ),
  const ProductModel(
    id: '2',
    name: 'Сыворотка с витамином С',
    price: 1899.0,
    image: 'https://images.unsplash.com/photo-1620916566398-39f1143ab7be?w=400',
    category: 'face',
  ),
  const ProductModel(
    id: '3',
    name: 'Ночной крем для лица',
    price: 1499.0,
    image: 'https://images.unsplash.com/photo-1571875257727-256c39da42af?w=400',
    category: 'face',
  ),
  const ProductModel(
    id: '4',
    name: 'Маска для лица',
    price: 899.0,
    image: 'https://images.unsplash.com/photo-1608248543803-ba4f8c70ae0b?w=400',
    category: 'face',
  ),

  // Makeup products (3 items)
  const ProductModel(
    id: '5',
    name: 'Помада красная',
    price: 699.0,
    image: 'https://images.unsplash.com/photo-1586495777744-4413f21062fa?w=400',
    category: 'makeup',
  ),
  const ProductModel(
    id: '6',
    name: 'Тушь для ресниц',
    price: 799.0,
    image: 'https://images.unsplash.com/photo-1631214524020-7e18db9a8f92?w=400',
    category: 'makeup',
  ),
  const ProductModel(
    id: '7',
    name: 'Палетка теней',
    price: 1299.0,
    image: 'https://images.unsplash.com/photo-1512496015851-a90fb38ba796?w=400',
    category: 'makeup',
  ),

  // Hair Care products (1 item)
  const ProductModel(
    id: '8',
    name: 'Шампунь для волос',
    price: 599.0,
    image: 'https://images.unsplash.com/photo-1535585209827-a15fcdbc4c2d?w=400',
    category: 'hair',
  ),
];

/// Get all products
List<ProductModel> getAllProducts() {
  return mockProducts;
}

/// Get product by ID
ProductModel? getProductById(String id) {
  try {
    return mockProducts.firstWhere((product) => product.id == id);
  } catch (e) {
    return null;
  }
}

/// Get products by category
List<ProductModel> getProductsByCategory(String category) {
  if (category == 'all') {
    return mockProducts;
  }
  return mockProducts.where((product) => product.category == category).toList();
}
