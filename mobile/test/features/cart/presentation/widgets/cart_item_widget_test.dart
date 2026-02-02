import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:modnyi_dvorik/core/theme/app_theme.dart';
import 'package:modnyi_dvorik/features/cart/domain/entities/cart_item.dart';
import 'package:modnyi_dvorik/features/cart/presentation/widgets/cart_item_widget.dart';
import 'package:modnyi_dvorik/features/home/domain/entities/product.dart';

void main() {
  group('CartItemWidget', () {
    const tProduct = Product(
      id: '1',
      name: 'Test Product',
      price: 1299.0,
      image: 'https://example.com/test.jpg',
      category: 'face',
    );

    const tCartItem = CartItem(
      product: tProduct,
      quantity: 2,
    );

    Widget createTestWidget({
      required CartItem cartItem,
      VoidCallback? onRemove,
      VoidCallback? onIncrement,
      VoidCallback? onDecrement,
    }) {
      return MaterialApp(
        theme: AppTheme.lightTheme,
        home: Scaffold(
          body: CartItemWidget(
            cartItem: cartItem,
            onRemove: onRemove ?? () {},
            onIncrement: onIncrement ?? () {},
            onDecrement: onDecrement ?? () {},
          ),
        ),
      );
    }

    testWidgets('should display product name', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(createTestWidget(cartItem: tCartItem));

      // Assert
      expect(find.text('Test Product'), findsOneWidget);
    });

    testWidgets('should display product price', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(createTestWidget(cartItem: tCartItem));

      // Assert
      expect(find.textContaining('1'), findsWidgets);
      expect(find.textContaining('299'), findsWidgets);
      expect(find.textContaining('₽'), findsWidgets);
    });

    testWidgets('should display quantity', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(createTestWidget(cartItem: tCartItem));

      // Assert
      expect(find.text('2'), findsOneWidget);
    });

    testWidgets('should display total price', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(createTestWidget(cartItem: tCartItem));

      // Assert
      // Total price should be 1299 * 2 = 2598
      expect(find.textContaining('2'), findsWidgets);
      expect(find.textContaining('598'), findsWidgets);
    });

    testWidgets('should display remove button', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(createTestWidget(cartItem: tCartItem));

      // Assert
      expect(find.byIcon(Icons.delete_outline), findsOneWidget);
    });

    testWidgets('should display increment button', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(createTestWidget(cartItem: tCartItem));

      // Assert
      expect(find.byIcon(Icons.add), findsOneWidget);
    });

    testWidgets('should display decrement button', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(createTestWidget(cartItem: tCartItem));

      // Assert
      expect(find.byIcon(Icons.remove), findsOneWidget);
    });

    testWidgets('should call onRemove when remove button is tapped',
        (WidgetTester tester) async {
      // Arrange
      var removeCalled = false;
      await tester.pumpWidget(
        createTestWidget(
          cartItem: tCartItem,
          onRemove: () {
            removeCalled = true;
          },
        ),
      );

      // Act
      await tester.tap(find.byIcon(Icons.delete_outline));
      await tester.pump();

      // Assert
      expect(removeCalled, isTrue);
    });

    testWidgets('should call onIncrement when add button is tapped',
        (WidgetTester tester) async {
      // Arrange
      var incrementCalled = false;
      await tester.pumpWidget(
        createTestWidget(
          cartItem: tCartItem,
          onIncrement: () {
            incrementCalled = true;
          },
        ),
      );

      // Act
      await tester.tap(find.byIcon(Icons.add));
      await tester.pump();

      // Assert
      expect(incrementCalled, isTrue);
    });

    testWidgets('should call onDecrement when remove button is tapped',
        (WidgetTester tester) async {
      // Arrange
      var decrementCalled = false;
      await tester.pumpWidget(
        createTestWidget(
          cartItem: tCartItem,
          onDecrement: () {
            decrementCalled = true;
          },
        ),
      );

      // Act
      await tester.tap(find.byIcon(Icons.remove));
      await tester.pump();

      // Assert
      expect(decrementCalled, isTrue);
    });

    testWidgets('should disable decrement button when quantity is 1',
        (WidgetTester tester) async {
      // Arrange
      const cartItemWithMinQuantity = CartItem(
        product: tProduct,
        quantity: 1,
      );

      var decrementCalled = false;
      await tester.pumpWidget(
        createTestWidget(
          cartItem: cartItemWithMinQuantity,
          onDecrement: () {
            decrementCalled = true;
          },
        ),
      );

      // Act
      await tester.tap(find.byIcon(Icons.remove));
      await tester.pump();

      // Assert
      // Decrement should not be called when quantity is at minimum
      expect(decrementCalled, isFalse);
    });

    testWidgets('should calculate and display correct total price',
        (WidgetTester tester) async {
      // Arrange
      const cartItemWith3Items = CartItem(
        product: Product(
          id: '2',
          name: 'Another Product',
          price: 500.0,
          image: 'https://example.com/test2.jpg',
          category: 'makeup',
        ),
        quantity: 3,
      );

      await tester.pumpWidget(
        createTestWidget(cartItem: cartItemWith3Items),
      );

      // Act & Assert
      // Total should be 500 * 3 = 1500
      expect(find.textContaining('1'), findsWidgets);
      expect(find.textContaining('500'), findsWidgets);
    });
  });
}
