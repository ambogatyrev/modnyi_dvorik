import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
      bool isSelected = true,
      VoidCallback? onToggleSelection,
      VoidCallback? onRemove,
      VoidCallback? onIncrement,
      VoidCallback? onDecrement,
    }) {
      return MaterialApp(
        theme: AppTheme.lightTheme,
        home: Scaffold(
          body: CartItemWidget(
            cartItem: cartItem,
            isSelected: isSelected,
            onToggleSelection: onToggleSelection ?? () {},
            onRemove: onRemove ?? () {},
            onIncrement: onIncrement ?? () {},
            onDecrement: onDecrement ?? () {},
          ),
        ),
      );
    }

    testWidgets('should display product name', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(cartItem: tCartItem));
      expect(find.text('Test Product'), findsOneWidget);
    });

    testWidgets('should display product price', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(cartItem: tCartItem));
      expect(find.textContaining('1'), findsWidgets);
      expect(find.textContaining('299'), findsWidgets);
      expect(find.textContaining('₽'), findsWidgets);
    });

    testWidgets('should display quantity', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(cartItem: tCartItem));
      expect(find.text('2'), findsOneWidget);
    });

    testWidgets('should display total price', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(cartItem: tCartItem));
      expect(find.textContaining('2'), findsWidgets);
      expect(find.textContaining('598'), findsWidgets);
    });

    testWidgets('should display trash SVG icon', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(cartItem: tCartItem));
      final svgFinder = find.byWidgetPredicate(
        (widget) => widget is SvgPicture,
      );
      expect(svgFinder, findsWidgets);
    });

    testWidgets('should show checkbox when selected',
        (WidgetTester tester) async {
      await tester.pumpWidget(
          createTestWidget(cartItem: tCartItem, isSelected: true));
      expect(find.byIcon(Icons.check), findsOneWidget);
    });

    testWidgets('should not show check icon when deselected',
        (WidgetTester tester) async {
      await tester.pumpWidget(
          createTestWidget(cartItem: tCartItem, isSelected: false));
      expect(find.byIcon(Icons.check), findsNothing);
    });

    testWidgets('should call onToggleSelection when checkbox is tapped',
        (WidgetTester tester) async {
      var toggleCalled = false;
      await tester.pumpWidget(
        createTestWidget(
          cartItem: tCartItem,
          onToggleSelection: () {
            toggleCalled = true;
          },
        ),
      );

      await tester.tap(find.byIcon(Icons.check));
      await tester.pump();
      expect(toggleCalled, isTrue);
    });

    testWidgets('should call onRemove when trash button is tapped',
        (WidgetTester tester) async {
      var removeCalled = false;
      await tester.pumpWidget(
        createTestWidget(
          cartItem: tCartItem,
          onRemove: () {
            removeCalled = true;
          },
        ),
      );

      final trashIcon = find.byWidgetPredicate(
        (widget) =>
            widget is SvgPicture &&
            widget.bytesLoader is SvgAssetLoader &&
            (widget.bytesLoader as SvgAssetLoader).assetName ==
                'assets/icons/trach.svg',
      );
      await tester.tap(trashIcon);
      await tester.pump();
      expect(removeCalled, isTrue);
    });

    testWidgets('should call onIncrement when plus button is tapped',
        (WidgetTester tester) async {
      var incrementCalled = false;
      await tester.pumpWidget(
        createTestWidget(
          cartItem: tCartItem,
          onIncrement: () {
            incrementCalled = true;
          },
        ),
      );

      final plusIcon = find.byWidgetPredicate(
        (widget) =>
            widget is SvgPicture &&
            widget.bytesLoader is SvgAssetLoader &&
            (widget.bytesLoader as SvgAssetLoader).assetName ==
                'assets/icons/plus.svg',
      );
      await tester.tap(plusIcon);
      await tester.pump();
      expect(incrementCalled, isTrue);
    });

    testWidgets('should call onDecrement when minus button is tapped',
        (WidgetTester tester) async {
      var decrementCalled = false;
      await tester.pumpWidget(
        createTestWidget(
          cartItem: tCartItem,
          onDecrement: () {
            decrementCalled = true;
          },
        ),
      );

      final minusIcon = find.byWidgetPredicate(
        (widget) =>
            widget is SvgPicture &&
            widget.bytesLoader is SvgAssetLoader &&
            (widget.bytesLoader as SvgAssetLoader).assetName ==
                'assets/icons/minus.svg',
      );
      await tester.tap(minusIcon);
      await tester.pump();
      expect(decrementCalled, isTrue);
    });

    testWidgets('should disable decrement button when quantity is at minimum',
        (WidgetTester tester) async {
      const cartItemWithMinQuantity = CartItem(
        product: tProduct,
        quantity: 0,
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

      final minusIcon = find.byWidgetPredicate(
        (widget) =>
            widget is SvgPicture &&
            widget.bytesLoader is SvgAssetLoader &&
            (widget.bytesLoader as SvgAssetLoader).assetName ==
                'assets/icons/minus.svg',
      );
      await tester.tap(minusIcon);
      await tester.pump();
      expect(decrementCalled, isFalse);
    });

    testWidgets('should calculate and display correct total price',
        (WidgetTester tester) async {
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

      expect(find.textContaining('1'), findsWidgets);
      expect(find.textContaining('500'), findsWidgets);
    });
  });
}
