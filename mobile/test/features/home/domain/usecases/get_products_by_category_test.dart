import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:modnyi_dvorik/features/home/domain/entities/product.dart';
import 'package:modnyi_dvorik/features/home/domain/repositories/product_repository.dart';
import 'package:modnyi_dvorik/features/home/domain/usecases/get_products_by_category.dart';

// Mock class
class MockProductRepository extends Mock implements ProductRepository {}

void main() {
  late GetProductsByCategory useCase;
  late MockProductRepository mockRepository;

  setUp(() {
    mockRepository = MockProductRepository();
    useCase = GetProductsByCategory(mockRepository);
  });

  group('GetProductsByCategory', () {
    const tCategoryId = 'face';
    const tProducts = [
      Product(
        id: '1',
        name: 'Face Cream',
        price: 1299.0,
        image: 'https://example.com/1.jpg',
        category: 'face',
      ),
      Product(
        id: '2',
        name: 'Face Serum',
        price: 1899.0,
        image: 'https://example.com/2.jpg',
        category: 'face',
      ),
    ];

    test('should get products filtered by category from the repository',
        () async {
      // Arrange
      when(() => mockRepository.getProductsByCategory(tCategoryId))
          .thenAnswer((_) async => tProducts);

      // Act
      final result = await useCase(tCategoryId);

      // Assert
      expect(result, tProducts);
      verify(() => mockRepository.getProductsByCategory(tCategoryId)).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return all products when category is "all"', () async {
      // Arrange
      const allProducts = [
        Product(
          id: '1',
          name: 'Face Cream',
          price: 1299.0,
          image: 'https://example.com/1.jpg',
          category: 'face',
        ),
        Product(
          id: '2',
          name: 'Lipstick',
          price: 699.0,
          image: 'https://example.com/2.jpg',
          category: 'makeup',
        ),
      ];

      when(() => mockRepository.getProductsByCategory('all'))
          .thenAnswer((_) async => allProducts);

      // Act
      final result = await useCase('all');

      // Assert
      expect(result, allProducts);
      verify(() => mockRepository.getProductsByCategory('all')).called(1);
    });

    test('should return empty list when category has no products', () async {
      // Arrange
      when(() => mockRepository.getProductsByCategory('accessories'))
          .thenAnswer((_) async => []);

      // Act
      final result = await useCase('accessories');

      // Assert
      expect(result, isEmpty);
      verify(() => mockRepository.getProductsByCategory('accessories'))
          .called(1);
    });

    test('should throw exception when repository fails', () async {
      // Arrange
      when(() => mockRepository.getProductsByCategory(tCategoryId))
          .thenThrow(Exception('Failed to load products'));

      // Act & Assert
      expect(() => useCase(tCategoryId), throwsException);
      verify(() => mockRepository.getProductsByCategory(tCategoryId)).called(1);
    });
  });
}
