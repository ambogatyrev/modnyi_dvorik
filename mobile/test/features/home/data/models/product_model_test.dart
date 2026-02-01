import 'package:flutter_test/flutter_test.dart';
import 'package:modnyi_dvorik/features/home/data/models/product_model.dart';

void main() {
  group('ProductModel', () {
    const tProductModel = ProductModel(
      id: '1',
      name: 'Test Product',
      price: 1299.0,
      image: 'https://example.com/test.jpg',
      category: 'face',
    );

    const tJson = {
      'id': '1',
      'name': 'Test Product',
      'price': 1299.0,
      'image': 'https://example.com/test.jpg',
      'category': 'face',
    };

    test('should create ProductModel from JSON', () {
      // Act
      final result = ProductModel.fromJson(tJson);

      // Assert
      expect(result, equals(tProductModel));
      expect(result.id, equals('1'));
      expect(result.name, equals('Test Product'));
      expect(result.price, equals(1299.0));
      expect(result.image, equals('https://example.com/test.jpg'));
      expect(result.category, equals('face'));
    });

    test('should convert ProductModel to JSON', () {
      // Act
      final result = tProductModel.toJson();

      // Assert
      expect(result, equals(tJson));
    });

    test('should handle integer price and convert to double', () {
      // Arrange
      final jsonWithIntPrice = {
        'id': '1',
        'name': 'Test Product',
        'price': 1299, // Integer instead of double
        'image': 'https://example.com/test.jpg',
        'category': 'face',
      };

      // Act
      final result = ProductModel.fromJson(jsonWithIntPrice);

      // Assert
      expect(result.price, equals(1299.0));
      expect(result.price, isA<double>());
    });

    test('should create a copy with modified fields', () {
      // Act
      final result = tProductModel.copyWith(
        name: 'Updated Product',
        price: 1599.0,
      );

      // Assert
      expect(result.id, equals('1'));
      expect(result.name, equals('Updated Product'));
      expect(result.price, equals(1599.0));
      expect(result.image, equals('https://example.com/test.jpg'));
      expect(result.category, equals('face'));
    });

    test('should maintain equality for identical models', () {
      // Arrange
      const model1 = ProductModel(
        id: '1',
        name: 'Test',
        price: 100.0,
        image: 'url',
        category: 'face',
      );

      const model2 = ProductModel(
        id: '1',
        name: 'Test',
        price: 100.0,
        image: 'url',
        category: 'face',
      );

      // Assert
      expect(model1, equals(model2));
    });

    test('should have different equality for different models', () {
      // Arrange
      const model1 = ProductModel(
        id: '1',
        name: 'Test',
        price: 100.0,
        image: 'url',
        category: 'face',
      );

      const model2 = ProductModel(
        id: '2',
        name: 'Test',
        price: 100.0,
        image: 'url',
        category: 'face',
      );

      // Assert
      expect(model1, isNot(equals(model2)));
    });

    test('should generate correct toString', () {
      // Act
      final result = tProductModel.toString();

      // Assert
      expect(result, contains('ProductModel'));
      expect(result, contains('id: 1'));
      expect(result, contains('name: Test Product'));
      expect(result, contains('price: 1299.0'));
    });
  });
}
