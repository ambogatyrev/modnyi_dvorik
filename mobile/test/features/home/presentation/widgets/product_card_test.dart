import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:modnyi_dvorik/core/theme/app_theme.dart';
import 'package:modnyi_dvorik/features/home/domain/entities/product.dart';
import 'package:modnyi_dvorik/features/home/presentation/widgets/product_card.dart';

void main() {
  group('ProductCard Widget', () {
    const tProduct = Product(
      id: '1',
      name: 'Test Product',
      price: 1299.0,
      image: 'https://example.com/test.jpg',
      category: 'face',
    );

    Widget createTestWidget({
      required Product product,
      VoidCallback? onAddToCart,
    }) {
      return MaterialApp(
        theme: AppTheme.lightTheme,
        home: Scaffold(
          body: ProductCard(
            product: product,
            onAddToCart: onAddToCart,
          ),
        ),
      );
    }

    testWidgets('should display product name', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(createTestWidget(product: tProduct));

      // Assert
      expect(find.text('Test Product'), findsOneWidget);
    });

    testWidgets('should display product price formatted',
        (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(createTestWidget(product: tProduct));

      // Assert
      expect(find.textContaining('1'), findsWidgets);
      expect(find.textContaining('299'), findsWidgets);
      expect(find.textContaining('₽'), findsWidgets);
    });

    testWidgets('should display add to cart button',
        (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(createTestWidget(product: tProduct));

      // Assert
      expect(find.byIcon(Icons.add), findsOneWidget);
    });

    testWidgets('should call onAddToCart when add button is tapped',
        (WidgetTester tester) async {
      // Arrange
      var callbackCalled = false;
      await tester.pumpWidget(
        createTestWidget(
          product: tProduct,
          onAddToCart: () {
            callbackCalled = true;
          },
        ),
      );

      // Act
      await tester.tap(find.byIcon(Icons.add));
      await tester.pump();

      // Assert
      expect(callbackCalled, isTrue);
    });

    testWidgets('should be wrapped in a Card widget',
        (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(createTestWidget(product: tProduct));

      // Assert
      expect(find.byType(Card), findsOneWidget);
    });

    testWidgets('should have hero animation tag',
        (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(createTestWidget(product: tProduct));

      // Assert
      expect(find.byType(Hero), findsOneWidget);
      final hero = tester.widget<Hero>(find.byType(Hero));
      expect(hero.tag, equals('product-1'));
    });

    testWidgets('should truncate long product names',
        (WidgetTester tester) async {
      // Arrange
      const longNameProduct = Product(
        id: '2',
        name: 'This is a very long product name that should be truncated',
        price: 999.0,
        image: 'https://example.com/test.jpg',
        category: 'face',
      );

      // Act
      await tester.pumpWidget(createTestWidget(product: longNameProduct));

      // Assert
      final textWidget = tester.widget<Text>(
        find.text(
          'This is a very long product name that should be truncated',
        ),
      );
      expect(textWidget.maxLines, equals(2));
      expect(textWidget.overflow, equals(TextOverflow.ellipsis));
    });
  });
}
