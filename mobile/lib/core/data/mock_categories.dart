import '../../features/home/data/models/category_model.dart';

/// Mock category data matching the web application
/// All categories with emoji icons
final List<CategoryModel> mockCategories = [
  const CategoryModel(
    id: 'all',
    name: 'Все категории',
    icon: '🛍️',
  ),
  const CategoryModel(
    id: 'face',
    name: 'Уход за лицом',
    icon: '🧴',
  ),
  const CategoryModel(
    id: 'makeup',
    name: 'Макияж',
    icon: '💄',
  ),
  const CategoryModel(
    id: 'hair',
    name: 'Волосы',
    icon: '💇',
  ),
  const CategoryModel(
    id: 'accessories',
    name: 'Аксессуары',
    icon: '👜',
  ),
];

/// Get all categories
List<CategoryModel> getAllCategories() {
  return mockCategories;
}

/// Get category by ID
CategoryModel? getCategoryById(String id) {
  try {
    return mockCategories.firstWhere((category) => category.id == id);
  } catch (e) {
    return null;
  }
}

/// Get category name by ID
String getCategoryName(String id) {
  final category = getCategoryById(id);
  return category?.name ?? 'Неизвестная категория';
}
