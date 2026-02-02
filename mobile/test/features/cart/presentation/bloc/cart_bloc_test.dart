import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:modnyi_dvorik/features/cart/domain/entities/cart_item.dart';
import 'package:modnyi_dvorik/features/cart/domain/usecases/add_to_cart.dart' as usecases;
import 'package:modnyi_dvorik/features/cart/domain/usecases/get_cart_items.dart';
import 'package:modnyi_dvorik/features/cart/domain/usecases/remove_from_cart.dart' as usecases;
import 'package:modnyi_dvorik/features/cart/domain/usecases/update_cart_quantity.dart';
import 'package:modnyi_dvorik/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:modnyi_dvorik/features/cart/presentation/bloc/cart_event.dart';
import 'package:modnyi_dvorik/features/cart/presentation/bloc/cart_state.dart';
import 'package:modnyi_dvorik/features/home/domain/entities/product.dart';

// Mock classes
class MockGetCartItems extends Mock implements GetCartItems {}

class MockAddToCart extends Mock implements usecases.AddToCart {}

class MockRemoveFromCart extends Mock implements usecases.RemoveFromCart {}

class MockUpdateCartQuantity extends Mock implements UpdateCartQuantity {}

void main() {
  late CartBloc cartBloc;
  late MockGetCartItems mockGetCartItems;
  late MockAddToCart mockAddToCart;
  late MockRemoveFromCart mockRemoveFromCart;
  late MockUpdateCartQuantity mockUpdateCartQuantity;

  setUp(() {
    mockGetCartItems = MockGetCartItems();
    mockAddToCart = MockAddToCart();
    mockRemoveFromCart = MockRemoveFromCart();
    mockUpdateCartQuantity = MockUpdateCartQuantity();

    cartBloc = CartBloc(
      getCartItems: mockGetCartItems,
      addToCart: mockAddToCart,
      removeFromCart: mockRemoveFromCart,
      updateCartQuantity: mockUpdateCartQuantity,
    );
  });

  tearDown(() {
    cartBloc.close();
  });

  group('CartBloc', () {
    const tProduct1 = Product(
      id: '1',
      name: 'Test Product 1',
      price: 100.0,
      image: 'https://example.com/1.jpg',
      category: 'face',
    );

    const tProduct2 = Product(
      id: '2',
      name: 'Test Product 2',
      price: 200.0,
      image: 'https://example.com/2.jpg',
      category: 'makeup',
    );

    const tCartItem1 = CartItem(product: tProduct1, quantity: 2);
    const tCartItem2 = CartItem(product: tProduct2, quantity: 1);
    const tCartItems = [tCartItem1, tCartItem2];

    test('initial state should be CartInitial', () {
      expect(cartBloc.state, equals(const CartInitial()));
    });

    group('LoadCart', () {
      blocTest<CartBloc, CartState>(
        'emits [CartLoading, CartLoaded] when LoadCart is successful',
        build: () {
          when(() => mockGetCartItems()).thenAnswer((_) async => tCartItems);
          return cartBloc;
        },
        act: (bloc) => bloc.add(const LoadCart()),
        expect: () => [
          const CartLoading(),
          const CartLoaded(
            items: tCartItems,
            totalPrice: 400.0, // (100 * 2) + (200 * 1)
          ),
        ],
        verify: (_) {
          verify(() => mockGetCartItems()).called(1);
        },
      );

      blocTest<CartBloc, CartState>(
        'emits [CartLoading, CartLoaded] with empty cart',
        build: () {
          when(() => mockGetCartItems()).thenAnswer((_) async => []);
          return cartBloc;
        },
        act: (bloc) => bloc.add(const LoadCart()),
        expect: () => [
          const CartLoading(),
          const CartLoaded(items: [], totalPrice: 0.0),
        ],
      );

      blocTest<CartBloc, CartState>(
        'emits [CartLoading, CartError] when LoadCart fails',
        build: () {
          when(() => mockGetCartItems())
              .thenThrow(Exception('Failed to load cart'));
          return cartBloc;
        },
        act: (bloc) => bloc.add(const LoadCart()),
        expect: () => [
          const CartLoading(),
          isA<CartError>(),
        ],
      );
    });

    group('AddToCart', () {
      blocTest<CartBloc, CartState>(
        'emits [CartLoaded] with updated items after adding product',
        build: () {
          when(() => mockAddToCart(any(), any()))
              .thenAnswer((_) async => {});
          when(() => mockGetCartItems()).thenAnswer((_) async => tCartItems);
          return cartBloc;
        },
        act: (bloc) => bloc.add(const AddToCart(product: tProduct1, quantity: 1)),
        expect: () => [
          const CartLoaded(items: tCartItems, totalPrice: 400.0),
        ],
        verify: (_) {
          verify(() => mockAddToCart(tProduct1, 1)).called(1);
          verify(() => mockGetCartItems()).called(1);
        },
      );

      blocTest<CartBloc, CartState>(
        'emits [CartError] when AddToCart fails',
        build: () {
          when(() => mockAddToCart(any(), any()))
              .thenThrow(Exception('Failed to add to cart'));
          return cartBloc;
        },
        act: (bloc) => bloc.add(const AddToCart(product: tProduct1, quantity: 1)),
        expect: () => [
          isA<CartError>(),
        ],
      );
    });

    group('RemoveFromCart', () {
      blocTest<CartBloc, CartState>(
        'emits [CartLoaded] with item removed',
        build: () {
          when(() => mockRemoveFromCart(any()))
              .thenAnswer((_) async => {});
          when(() => mockGetCartItems()).thenAnswer((_) async => [tCartItem2]);
          return cartBloc;
        },
        act: (bloc) => bloc.add(const RemoveFromCart('1')),
        expect: () => [
          const CartLoaded(items: [tCartItem2], totalPrice: 200.0),
        ],
        verify: (_) {
          verify(() => mockRemoveFromCart('1')).called(1);
          verify(() => mockGetCartItems()).called(1);
        },
      );

      blocTest<CartBloc, CartState>(
        'emits [CartError] when RemoveFromCart fails',
        build: () {
          when(() => mockRemoveFromCart(any()))
              .thenThrow(Exception('Failed to remove from cart'));
          return cartBloc;
        },
        act: (bloc) => bloc.add(const RemoveFromCart('1')),
        expect: () => [
          isA<CartError>(),
        ],
      );
    });

    group('UpdateQuantity', () {
      blocTest<CartBloc, CartState>(
        'emits [CartLoaded] with updated quantity',
        build: () {
          when(() => mockUpdateCartQuantity(any(), any()))
              .thenAnswer((_) async => {});
          when(() => mockGetCartItems())
              .thenAnswer((_) async => [
            const CartItem(product: tProduct1, quantity: 3),
            tCartItem2,
          ]);
          return cartBloc;
        },
        act: (bloc) => bloc.add(const UpdateQuantity(productId: '1', quantity: 3)),
        expect: () => [
          const CartLoaded(
            items: [
              CartItem(product: tProduct1, quantity: 3),
              tCartItem2,
            ],
            totalPrice: 500.0, // (100 * 3) + (200 * 1)
          ),
        ],
        verify: (_) {
          verify(() => mockUpdateCartQuantity('1', 3)).called(1);
          verify(() => mockGetCartItems()).called(1);
        },
      );

      blocTest<CartBloc, CartState>(
        'removes item when quantity is 0',
        build: () {
          when(() => mockRemoveFromCart(any()))
              .thenAnswer((_) async => {});
          when(() => mockGetCartItems()).thenAnswer((_) async => [tCartItem2]);
          return cartBloc;
        },
        act: (bloc) => bloc.add(const UpdateQuantity(productId: '1', quantity: 0)),
        expect: () => [
          const CartLoaded(items: [tCartItem2], totalPrice: 200.0),
        ],
        verify: (_) {
          verify(() => mockRemoveFromCart('1')).called(1);
          verify(() => mockGetCartItems()).called(1);
        },
      );

      blocTest<CartBloc, CartState>(
        'emits [CartError] when UpdateQuantity fails',
        build: () {
          when(() => mockUpdateCartQuantity(any(), any()))
              .thenThrow(Exception('Failed to update quantity'));
          return cartBloc;
        },
        act: (bloc) => bloc.add(const UpdateQuantity(productId: '1', quantity: 3)),
        expect: () => [
          isA<CartError>(),
        ],
      );
    });

    group('ClearCart', () {
      blocTest<CartBloc, CartState>(
        'emits [CartLoaded] with empty items after clearing cart',
        build: () {
          when(() => mockGetCartItems()).thenAnswer((_) async => tCartItems);
          when(() => mockRemoveFromCart(any()))
              .thenAnswer((_) async => {});
          return cartBloc;
        },
        act: (bloc) => bloc.add(const ClearCart()),
        expect: () => [
          const CartLoaded(items: [], totalPrice: 0.0),
        ],
        verify: (_) {
          verify(() => mockGetCartItems()).called(1);
          verify(() => mockRemoveFromCart(any())).called(2); // Once for each item
        },
      );
    });

    group('Total Calculations', () {
      test('CartLoaded calculates correct subtotal', () {
        const state = CartLoaded(
          items: tCartItems,
          totalPrice: 400.0,
        );

        expect(state.subtotal, equals(400.0));
      });

      test('CartLoaded calculates correct item count', () {
        const state = CartLoaded(
          items: tCartItems,
          totalPrice: 400.0,
        );

        expect(state.itemCount, equals(3)); // 2 + 1
      });

      test('CartLoaded isEmpty is false when items exist', () {
        const state = CartLoaded(
          items: tCartItems,
          totalPrice: 400.0,
        );

        expect(state.isEmpty, equals(false));
      });

      test('CartLoaded isEmpty is true when no items', () {
        const state = CartLoaded(
          items: [],
          totalPrice: 0.0,
        );

        expect(state.isEmpty, equals(true));
      });
    });
  });
}
