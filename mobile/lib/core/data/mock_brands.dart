/// Mock brand data for the application
/// Represents popular cosmetic and beauty brands
final List<Map<String, String>> mockBrands = [
  {'id': 'dior', 'name': 'Dior', 'logo': '💎'},
  {'id': 'chanel', 'name': 'Chanel', 'logo': '🌹'},
  {'id': 'loreal', 'name': "L'Oréal", 'logo': '✨'},
  {'id': 'maybelline', 'name': 'Maybelline', 'logo': '💄'},
  {'id': 'mac', 'name': 'MAC', 'logo': '🎨'},
  {'id': 'estee_lauder', 'name': 'Estée Lauder', 'logo': '👑'},
  {'id': 'clinique', 'name': 'Clinique', 'logo': '🧪'},
  {'id': 'lancome', 'name': 'Lancôme', 'logo': '🌸'},
];

/// Get all brands
List<Map<String, String>> getAllBrands() {
  return mockBrands;
}

/// Get brand by ID
Map<String, String>? getBrandById(String id) {
  try {
    return mockBrands.firstWhere((brand) => brand['id'] == id);
  } catch (e) {
    return null;
  }
}

/// Get brand name by ID
String getBrandName(String id) {
  final brand = getBrandById(id);
  return brand?['name'] ?? 'Неизвестный бренд';
}
