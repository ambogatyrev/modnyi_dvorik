import '../../features/home/data/models/category_model.dart';

/// Mock category data matching the web application
/// All categories with emoji icons
final List<CategoryModel> mockCategories = [
  const CategoryModel(id: 'face', name: 'Уход за лицом', icon: '🧴'),
  const CategoryModel(id: 'makeup', name: 'Макияж', icon: '💄'),
  const CategoryModel(id: 'hair', name: 'Волосы', icon: '💇'),
  const CategoryModel(id: 'accessories', name: 'Аксессуары', icon: '👜'),
  const CategoryModel(id: 'perfume', name: 'Парфюмерия', icon: '🌸'),
  const CategoryModel(id: 'body', name: 'Уход за телом', icon: '🛁'),
  const CategoryModel(id: 'nails', name: 'Маникюр', icon: '💅'),
  const CategoryModel(id: 'jewelry', name: 'Бижутерия', icon: '💎'),
  const CategoryModel(id: 'makeup_remover', name: 'Средства для снятия макияжа', icon: '🧼'),
  const CategoryModel(id: 'sun_care', name: 'Средства для загара', icon: '☀️'),
  const CategoryModel(id: 'gifts', name: 'Подарочные наборы', icon: '🎁'),
  const CategoryModel(id: 'organic', name: 'Органическая косметика', icon: '🌿'),
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
