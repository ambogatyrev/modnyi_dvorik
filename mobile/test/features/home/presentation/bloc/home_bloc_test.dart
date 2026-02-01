import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:modnyi_dvorik/features/home/domain/entities/product.dart';
import 'package:modnyi_dvorik/features/home/domain/usecases/get_products.dart';
import 'package:modnyi_dvorik/features/home/domain/usecases/get_products_by_category.dart';
import 'package:modnyi_dvorik/features/home/presentation/bloc/home_bloc.dart';
import 'package:modnyi_dvorik/features/home/presentation/bloc/home_event.dart';
import 'package:modnyi_dvorik/features/home/presentation/bloc/home_state.dart';

// Mock classes
class MockGetProducts extends Mock implements GetProducts {}

class MockGetProductsByCategory extends Mock
    implements GetProductsByCategory {}

void main() {
  late HomeBloc homeBloc;
  late MockGetProducts mockGetProducts;
  late MockGetProductsByCategory mockGetProductsByCategory;

  setUp(() {
    mockGetProducts = MockGetProducts();
    mockGetProductsByCategory = MockGetProductsByCategory();
    homeBloc = HomeBloc(
      getProducts: mockGetProducts,
      getProductsByCategory: mockGetProductsByCategory,
    );
  });

  tearDown(() {
    homeBloc.close();
  });

  group('HomeBloc', () {
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

    const tProducts = [tProduct1, tProduct2];

    test('initial state should be HomeInitial', () {
      expect(homeBloc.state, equals(const HomeInitial()));
    });

    group('LoadProducts', () {
      blocTest<HomeBloc, HomeState>(
        'emits [HomeLoading, HomeLoaded] when LoadProducts is successful',
        build: () {
          when(() => mockGetProducts()).thenAnswer((_) async => tProducts);
          return homeBloc;
        },
        act: (bloc) => bloc.add(const LoadProducts()),
        expect: () => [
          const HomeLoading(),
          const HomeLoaded(products: tProducts, selectedCategory: 'all'),
        ],
        verify: (_) {
          verify(() => mockGetProducts()).called(1);
        },
      );

      blocTest<HomeBloc, HomeState>(
        'emits [HomeLoading, HomeError] when LoadProducts fails',
        build: () {
          when(() => mockGetProducts()).thenThrow(Exception('Failed to load'));
          return homeBloc;
        },
        act: (bloc) => bloc.add(const LoadProducts()),
        expect: () => [
          const HomeLoading(),
          isA<HomeError>(),
        ],
        verify: (_) {
          verify(() => mockGetProducts()).called(1);
        },
      );
    });

    group('SelectCategory', () {
      blocTest<HomeBloc, HomeState>(
        'emits [HomeLoaded] with filtered products when SelectCategory is successful',
        build: () {
          when(() => mockGetProductsByCategory('face'))
              .thenAnswer((_) async => [tProduct1]);
          return homeBloc;
        },
        act: (bloc) => bloc.add(const SelectCategory('face')),
        expect: () => [
          const HomeLoading(),
          const HomeLoaded(products: [tProduct1], selectedCategory: 'face'),
        ],
        verify: (_) {
          verify(() => mockGetProductsByCategory('face')).called(1);
        },
      );

      blocTest<HomeBloc, HomeState>(
        'emits [HomeError] when SelectCategory fails',
        build: () {
          when(() => mockGetProductsByCategory('face'))
              .thenThrow(Exception('Failed to load'));
          return homeBloc;
        },
        act: (bloc) => bloc.add(const SelectCategory('face')),
        expect: () => [
          const HomeLoading(),
          isA<HomeError>(),
        ],
        verify: (_) {
          verify(() => mockGetProductsByCategory('face')).called(1);
        },
      );

      blocTest<HomeBloc, HomeState>(
        'emits [HomeLoaded] with all products when "all" category is selected',
        build: () {
          when(() => mockGetProductsByCategory('all'))
              .thenAnswer((_) async => tProducts);
          return homeBloc;
        },
        act: (bloc) => bloc.add(const SelectCategory('all')),
        expect: () => [
          const HomeLoading(),
          const HomeLoaded(products: tProducts, selectedCategory: 'all'),
        ],
        verify: (_) {
          verify(() => mockGetProductsByCategory('all')).called(1);
        },
      );
    });
  });
}
