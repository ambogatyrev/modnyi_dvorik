import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:modnyi_dvorik/features/cart/domain/repositories/cart_repository.dart';
import 'package:modnyi_dvorik/features/cart/domain/usecases/add_to_cart.dart';
import 'package:modnyi_dvorik/features/home/domain/entities/product.dart';

// Mock class
class MockCartRepository extends Mock implements CartRepository {}

void main() {
  late AddToCart useCase;
  late MockCartRepository mockRepository;

  setUp(() {
    mockRepository = MockCartRepository();
    useCase = AddToCart(mockRepository);
  });

  setUpAll(() {
    registerFallbackValue(
      const Product(
        id: '1',
        name: 'Test',
        price: 100.0,
        image: 'url',
        category: 'face',
      ),
    );
  });

  group('AddToCart', () {
    const tProduct = Product(
      id: '1',
      name: 'Test Product',
      price: 1299.0,
      image: 'https://example.com/test.jpg',
      category: 'face',
    );

    const tQuantity = 2;

    test('should add product to cart through repository', () async {
      // Arrange
      when(() => mockRepository.addToCart(any(), any()))
          .thenAnswer((_) async => {});

      // Act
      await useCase(tProduct, tQuantity);

      // Assert
      verify(() => mockRepository.addToCart(tProduct, tQuantity)).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should throw exception when quantity is zero or negative', () async {
      // Act & Assert
      expect(() => useCase(tProduct, 0), throwsArgumentError);
      expect(() => useCase(tProduct, -1), throwsArgumentError);
      verifyNever(() => mockRepository.addToCart(any(), any()));
    });

    test('should add product with quantity of 1', () async {
      // Arrange
      when(() => mockRepository.addToCart(any(), any()))
          .thenAnswer((_) async => {});

      // Act
      await useCase(tProduct, 1);

      // Assert
      verify(() => mockRepository.addToCart(tProduct, 1)).called(1);
    });

    test('should propagate repository exceptions', () async {
      // Arrange
      when(() => mockRepository.addToCart(any(), any()))
          .thenThrow(Exception('Cart error'));

      // Act & Assert
      expect(() => useCase(tProduct, tQuantity), throwsException);
      verify(() => mockRepository.addToCart(tProduct, tQuantity)).called(1);
    });
  });
}
