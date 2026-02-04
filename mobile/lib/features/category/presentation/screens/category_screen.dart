import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/data/mock_categories.dart';
import '../../../../core/data/mock_brands.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../home/presentation/widgets/search_app_bar_title.dart';

/// Category screen - displays all categories and brands in tabs
/// Users can tap on a category or brand to view products
class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen>
    with SingleTickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  late TabController _tabController;
  double _scrollOffset = 0.0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    setState(() {
      _scrollOffset = _scrollController.offset;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: SearchAppBarTitle(scrollOffset: _scrollOffset),
        titleSpacing: 16,
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.textSecondary,
          indicatorColor: AppColors.primary,
          indicatorWeight: 3,
          labelStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
          unselectedLabelStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
          tabs: const [
            Tab(text: 'Категории'),
            Tab(text: 'Бренды'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _CategoriesTab(scrollController: _scrollController),
          _BrandsTab(scrollController: _scrollController),
        ],
      ),
    );
  }
}

/// Categories Tab - displays all categories in a grid
class _CategoriesTab extends StatelessWidget {
  final ScrollController scrollController;

  const _CategoriesTab({required this.scrollController});

  @override
  Widget build(BuildContext context) {
    final categories = mockCategories;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: GridView.builder(
        controller: scrollController,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1.2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          return _ItemCard(
            icon: category.icon,
            name: category.name,
            onTap: () => context.push(AppRoutes.categoryRoute(category.id)),
          );
        },
      ),
    );
  }
}

/// Brands Tab - displays all brands in a grid
class _BrandsTab extends StatelessWidget {
  final ScrollController scrollController;

  const _BrandsTab({required this.scrollController});

  @override
  Widget build(BuildContext context) {
    final brands = mockBrands;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: GridView.builder(
        controller: scrollController,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1.2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemCount: brands.length,
        itemBuilder: (context, index) {
          final brand = brands[index];
          return _ItemCard(
            icon: brand['logo']!,
            name: brand['name']!,
            onTap: () {
              // TODO: Navigate to brand products screen
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Показать товары бренда ${brand['name']}'),
                  duration: const Duration(seconds: 2),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

/// Item card widget for grid display (used for both categories and brands)
class _ItemCard extends StatelessWidget {
  final String icon;
  final String name;
  final VoidCallback onTap;

  const _ItemCard({
    required this.icon,
    required this.name,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.muted,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border, width: 1),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(icon, style: const TextStyle(fontSize: 48)),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  name,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
