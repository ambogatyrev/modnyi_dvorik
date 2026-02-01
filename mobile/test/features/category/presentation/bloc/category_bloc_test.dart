import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:modnyi_dvorik/features/category/presentation/bloc/category_bloc.dart';
import 'package:modnyi_dvorik/features/category/presentation/bloc/category_event.dart';
import 'package:modnyi_dvorik/features/category/presentation/bloc/category_state.dart';
import 'package:modnyi_dvorik/features/home/domain/entities/product.dart';
import 'package:modnyi_dvorik/features/home/domain/usecases/get_products_by_category.dart';

// Mock classes
class MockGetProductsByCategory extends Mock
    implements GetProductsByCategory {}

void main() {
  late CategoryBloc categoryBloc;
  late MockGetProductsByCategory mockGetProductsByCategory;

  setUp(() {
    mockGetProductsByCategory = MockGetProductsByCategory();
    categoryBloc = CategoryBloc(
      getProductsByCategory: mockGetProductsByCategory,
    );
  });

  tearDown(() {
    categoryBloc.close();
  });

  group('CategoryBloc', () {
    const tProduct1 = Product(
      id: '1',
      name: 'Face Cream',
      price: 1299.0,
      image: 'https://example.com/1.jpg',
      category: 'face',
    );

    const tProduct2 = Product(
      id: '2',
      name: 'Face Serum',
      price: 1899.0,
      image: 'https://example.com/2.jpg',
      category: 'face',
    );

    const tProducts = [tProduct1, tProduct2];
    const tCategoryId = 'face';

    test('initial state should be CategoryInitial', () {
      expect(categoryBloc.state, equals(const CategoryInitial()));
    });

    group('LoadCategoryProducts', () {
      blocTest<CategoryBloc, CategoryState>(
        'emits [CategoryLoading, CategoryLoaded] when loading products is successful',
        build: () {
          when(() => mockGetProductsByCategory(tCategoryId))
              .thenAnswer((_) async => tProducts);
          return categoryBloc;
        },
        act: (bloc) => bloc.add(const LoadCategoryProducts(tCategoryId)),
        expect: () => [
          const CategoryLoading(),
          const CategoryLoaded(
            products: tProducts,
            categoryId: tCategoryId,
            categoryName: 'Уход за лицом',
          ),
        ],
        verify: (_) {
          verify(() => mockGetProductsByCategory(tCategoryId)).called(1);
        },
      );

      blocTest<CategoryBloc, CategoryState>(
        'emits [CategoryLoading, CategoryError] when loading products fails',
        build: () {
          when(() => mockGetProductsByCategory(tCategoryId))
              .thenThrow(Exception('Failed to load'));
          return categoryBloc;
        },
        act: (bloc) => bloc.add(const LoadCategoryProducts(tCategoryId)),
        expect: () => [
          const CategoryLoading(),
          isA<CategoryError>(),
        ],
        verify: (_) {
          verify(() => mockGetProductsByCategory(tCategoryId)).called(1);
        },
      );

      blocTest<CategoryBloc, CategoryState>(
        'emits CategoryLoaded with empty products list when category has no products',
        build: () {
          when(() => mockGetProductsByCategory('accessories'))
              .thenAnswer((_) async => []);
          return categoryBloc;
        },
        act: (bloc) => bloc.add(const LoadCategoryProducts('accessories')),
        expect: () => [
          const CategoryLoading(),
          const CategoryLoaded(
            products: [],
            categoryId: 'accessories',
            categoryName: 'Аксессуары',
          ),
        ],
        verify: (_) {
          verify(() => mockGetProductsByCategory('accessories')).called(1);
        },
      );

      blocTest<CategoryBloc, CategoryState>(
        'loads all products when category is "all"',
        build: () {
          when(() => mockGetProductsByCategory('all'))
              .thenAnswer((_) async => tProducts);
          return categoryBloc;
        },
        act: (bloc) => bloc.add(const LoadCategoryProducts('all')),
        expect: () => [
          const CategoryLoading(),
          const CategoryLoaded(
            products: tProducts,
            categoryId: 'all',
            categoryName: 'Все категории',
          ),
        ],
        verify: (_) {
          verify(() => mockGetProductsByCategory('all')).called(1);
        },
      );
    });
  });
}
