import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:modnyi_dvorik/features/home/domain/entities/product.dart';
import 'package:modnyi_dvorik/features/home/domain/repositories/product_repository.dart';
import 'package:modnyi_dvorik/features/home/domain/usecases/get_products.dart';

// Mock class
class MockProductRepository extends Mock implements ProductRepository {}

void main() {
  late GetProducts useCase;
  late MockProductRepository mockRepository;

  setUp(() {
    mockRepository = MockProductRepository();
    useCase = GetProducts(mockRepository);
  });

  group('GetProducts', () {
    const tProducts = [
      Product(
        id: '1',
        name: 'Product 1',
        price: 100.0,
        image: 'https://example.com/1.jpg',
        category: 'face',
      ),
      Product(
        id: '2',
        name: 'Product 2',
        price: 200.0,
        image: 'https://example.com/2.jpg',
        category: 'makeup',
      ),
    ];

    test('should get all products from the repository', () async {
      // Arrange
      when(() => mockRepository.getProducts())
          .thenAnswer((_) async => tProducts);

      // Act
      final result = await useCase();

      // Assert
      expect(result, tProducts);
      verify(() => mockRepository.getProducts()).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should throw exception when repository fails', () async {
      // Arrange
      when(() => mockRepository.getProducts())
          .thenThrow(Exception('Failed to load products'));

      // Act & Assert
      expect(() => useCase(), throwsException);
      verify(() => mockRepository.getProducts()).called(1);
    });
  });
}
