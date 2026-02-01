# Mobile Application Implementation Plan
# Модный дворик (Modnyi Dvorik)

## WORKFLOW INSTRUCTIONS FOR CLAUDE

**Git Workflow:**
0. Dont use git merge or git rebase commands!!!
1. For each phase, create a new git branch: `git checkout -b phase_{phase_name}`
2. For each subtask completed, create a commit with descriptive message
3. After completing a subtask, mark it as `[✅]` in this file
4. After completing a phase, mark phase as `[✅]` and **STOP**
5. Wait for user command to continue to next phase
6. When continuing, checkout new branch for next phase

**Navigation:**
- Always read this `mobile/PLAN.md` file to see current progress
- Find the next uncompleted task (marked with `[ ]`)
- Complete that task, commit, and mark as `[✅]`
- Stop after each phase completion

---

## PROJECT OVERVIEW

### Web Application Analysis
**Location**: `~/development/modniy_dvorik-frontend`

**Tech Stack**: React 18.3.1 + TypeScript + Vite + Tailwind CSS

**Features**:
- Home screen (banner carousel, categories, product grid)
- Category browsing with filtering
- Product detail pages
- Shopping cart with item management
- User profile with loyalty card

**Design System**:
- Primary Color: #EF2AC1 (vibrant pink)
- Dark Foreground: #0A2240 (navy blue)
- Secondary: #005CB9 (blue)
- Font: Manrope (400, 500, 600, 700)
- Language: Russian (Cyrillic)

**Data**:
- 8 mock products (4 Face Care, 3 Makeup, 1 Hair Care)
- 4 categories
- No backend API (mock data only)

### Current Mobile App Status
**Location**: `~/development/modnyi_dvorik/mobile`

**Status**:
- Flutter 3.35.6 / Dart 3.9.2
- Default counter app (starter template)
- Clean Architecture documented but not implemented
- No features or business logic

---

## IMPLEMENTATION PHASES

### [✅] Phase 1: Foundation & Setup
**Branch**: `phase_foundation`

#### [✅] Subtask 1.1: Update Dependencies
**Files**: `pubspec.yaml`

Add dependencies:
```yaml
dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.8

  # State Management
  flutter_bloc: ^8.1.3
  bloc: ^8.1.2
  equatable: ^2.0.5

  # Navigation
  go_router: ^13.0.0

  # Network & Data
  dio: ^5.4.0
  shared_preferences: ^2.2.2

  # UI & Styling
  google_fonts: ^6.1.0
  cached_network_image: ^3.3.1

  # Utils
  intl: ^0.19.0

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^5.0.0
  bloc_test: ^9.1.5
  mocktail: ^1.0.2
```

**Actions**:
- Update `pubspec.yaml`
- Run `flutter pub get`
- Verify dependencies installed
- Commit: "Add project dependencies"

---

#### [✅] Subtask 1.2: Create Folder Structure
**Create directories**:
```
lib/
├── core/
│   ├── theme/
│   ├── constants/
│   ├── utils/
│   └── widgets/
├── features/
│   ├── home/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   ├── category/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   ├── product/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   ├── cart/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   └── profile/
│       ├── data/
│       ├── domain/
│       └── presentation/
```

**Actions**:
- Create all directories
- Add `.gitkeep` files to empty directories
- Commit: "Setup Clean Architecture folder structure"

---

#### [✅] Subtask 1.3: Create Theme System
**Files to create**:
- `lib/core/theme/app_colors.dart`
- `lib/core/theme/app_text_styles.dart`
- `lib/core/theme/app_theme.dart`

**app_colors.dart**:
```dart
class AppColors {
  // Primary brand color from web
  static const Color primary = Color(0xFFEF2AC1);
  static const Color primaryDark = Color(0xFFD625AD);

  // Dark foreground
  static const Color darkBlue = Color(0xFF0A2240);

  // Secondary
  static const Color secondary = Color(0xFF005CB9);

  // Neutrals
  static const Color background = Color(0xFFFFFFFF);
  static const Color muted = Color(0xFFF5F5F5);
  static const Color mutedForeground = Color(0xFF717182);
  static const Color border = Color(0xFFE5E5E5);

  // Semantic
  static const Color error = Color(0xFFD4183D);
  static const Color success = Color(0xFF10B981);
}
```

**app_text_styles.dart**: Define typography matching Manrope web font

**app_theme.dart**: Create Material ThemeData using colors and text styles

**Actions**:
- Create all three theme files
- Define complete color palette
- Setup text styles hierarchy
- Create light theme configuration
- Commit: "Implement app theme system"

---

#### [✅] Subtask 1.4: Update Main App
**File**: `lib/main.dart`

**Actions**:
- Remove default counter app code
- Apply app theme
- Setup MaterialApp structure
- Add placeholder home screen
- Commit: "Update main.dart with app theme"

---

**Phase 1 Complete** ✅ → STOP HERE, wait for user command

---

### [✅] Phase 2: Data Layer - Models & Mock Data
**Branch**: `phase_data_layer`

#### [✅] Subtask 2.1: Create Product Model
**Files**:
- `lib/features/home/data/models/product_model.dart`

**Model structure**:
```dart
class ProductModel {
  final String id;
  final String name;
  final double price;
  final String image;
  final String category;

  // Constructor, fromJson, toJson, copyWith, etc.
}
```

**Actions**:
- Create ProductModel class
- Add JSON serialization
- Add equatable for comparison
- Commit: "Create Product data model"

---

#### [✅] Subtask 2.2: Create Category Model
**Files**:
- `lib/features/home/data/models/category_model.dart`

**Model structure**:
```dart
class CategoryModel {
  final String id;
  final String name;
  final String icon; // emoji
}
```

**Actions**:
- Create CategoryModel class
- Add JSON serialization
- Commit: "Create Category data model"

---

#### [✅] Subtask 2.3: Create Cart Item Model
**Files**:
- `lib/features/cart/data/models/cart_item_model.dart`

**Model structure**:
```dart
class CartItemModel {
  final ProductModel product;
  final int quantity;

  double get totalPrice => product.price * quantity;
}
```

**Actions**:
- Create CartItemModel class
- Add calculated properties
- Add JSON serialization
- Commit: "Create CartItem data model"

---

#### [✅] Subtask 2.4: Create User Model
**Files**:
- `lib/features/profile/data/models/user_model.dart`

**Model structure**:
```dart
class UserModel {
  final String id;
  final String name;
  final String email;
  final int bonusPoints;
}
```

**Actions**:
- Create UserModel class
- Add JSON serialization
- Commit: "Create User data model"

---

#### [✅] Subtask 2.5: Create Mock Data
**Files**:
- `lib/core/data/mock_products.dart`
- `lib/core/data/mock_categories.dart`
- `lib/core/data/mock_user.dart`

**Mock products** (8 products from web app):
1. "Увлажняющий крем для лица" - 1299 RUB - Face Care
2. "Сыворотка с витамином С" - 1899 RUB - Face Care
3. "Ночной крем для лица" - 1499 RUB - Face Care
4. "Маска для лица" - 899 RUB - Face Care
5. "Помада красная" - 699 RUB - Makeup
6. "Тушь для ресниц" - 799 RUB - Makeup
7. "Палетка теней" - 1299 RUB - Makeup
8. "Шампунь для волос" - 599 RUB - Hair Care

**Mock categories**:
- all - Все категории - 🛍️
- face - Уход за лицом - 🧴
- makeup - Макияж - 💄
- hair - Волосы - 💇
- accessories - Аксессуары - 👜

**Mock user**:
- Name: Анна Петрова
- Email: anna.petrova@mail.ru
- Bonus Points: 1250

**Actions**:
- Create all mock data files
- Port exact data from web app
- Use Unsplash URLs for images (same as web)
- Commit: "Add mock data for products, categories, and user"

---

**Phase 2 Complete** ✅ → STOP HERE, wait for user command

---

### [✅] Phase 3: Domain Layer - Entities & Use Cases
**Branch**: `phase_domain_layer`

#### [✅] Subtask 3.1: Create Product Entity
**Files**:
- `lib/features/home/domain/entities/product.dart`

**Actions**:
- Create pure Dart Product entity
- No Flutter dependencies
- Use Equatable
- Commit: "Create Product entity"

---

#### [✅] Subtask 3.2: Create Product Repository Interface
**Files**:
- `lib/features/home/domain/repositories/product_repository.dart`

**Methods**:
```dart
abstract class ProductRepository {
  Future<List<Product>> getProducts();
  Future<Product> getProductById(String id);
  Future<List<Product>> getProductsByCategory(String category);
}
```

**Actions**:
- Create repository interface
- Define all methods
- Commit: "Create Product repository interface"

---

#### [✅] Subtask 3.3: Implement Product Repository
**Files**:
- `lib/features/home/data/repositories/product_repository_impl.dart`

**Actions**:
- Implement ProductRepository interface
- Use mock data source
- Return ProductModel as Product entity
- Commit: "Implement Product repository with mock data"

---

#### [✅] Subtask 3.4: Create Use Cases
**Files**:
- `lib/features/home/domain/usecases/get_products.dart`
- `lib/features/home/domain/usecases/get_product_by_id.dart`
- `lib/features/home/domain/usecases/get_products_by_category.dart`

**Pattern**:
```dart
class GetProducts {
  final ProductRepository repository;

  GetProducts(this.repository);

  Future<List<Product>> call() {
    return repository.getProducts();
  }
}
```

**Actions**:
- Create all three use cases
- Follow clean architecture pattern
- Commit: "Create product use cases"

---

#### [✅] Subtask 3.5: Create Cart Entities & Use Cases
**Files**:
- `lib/features/cart/domain/entities/cart_item.dart`
- `lib/features/cart/domain/repositories/cart_repository.dart`
- `lib/features/cart/data/repositories/cart_repository_impl.dart`
- `lib/features/cart/domain/usecases/add_to_cart.dart`
- `lib/features/cart/domain/usecases/remove_from_cart.dart`
- `lib/features/cart/domain/usecases/update_cart_quantity.dart`
- `lib/features/cart/domain/usecases/get_cart_items.dart`

**Actions**:
- Create CartItem entity
- Create Cart repository interface and implementation
- Implement all cart use cases
- Use shared_preferences for persistence
- Commit: "Create cart domain layer with use cases"

---

#### [✅] Subtask 3.6: Create User Entities & Use Cases
**Files**:
- `lib/features/profile/domain/entities/user.dart`
- `lib/features/profile/domain/repositories/user_repository.dart`
- `lib/features/profile/data/repositories/user_repository_impl.dart`
- `lib/features/profile/domain/usecases/get_user_profile.dart`

**Actions**:
- Create User entity
- Create User repository
- Create GetUserProfile use case
- Use mock user data
- Commit: "Create profile domain layer"

---

**Phase 3 Complete** ✅ → STOP HERE, wait for user command

---

### [✅] Phase 4: Navigation & App Structure
**Branch**: `phase_navigation`

#### [✅] Subtask 4.1: Setup Go Router
**Files**:
- `lib/core/router/app_router.dart`
- `lib/main.dart` (update)

**Routes**:
```dart
- / → HomeScreen
- /category/:id → CategoryScreen
- /product/:id → ProductDetailScreen
- /cart → CartScreen
- /profile → ProfileScreen
```

**Actions**:
- Create router configuration
- Define all routes with parameters
- Add route names constants
- Update main.dart to use router
- Commit: "Setup go_router with app routes"

---

#### [✅] Subtask 4.2: Create Bottom Navigation
**Files**:
- `lib/core/widgets/bottom_navigation_bar.dart`
- Create placeholder screens for all routes

**Navigation Items**:
1. Home (/) - Icon: home
2. Catalog (/category/all) - Icon: grid_3x3
3. Cart (/cart) - Icon: shopping_cart
4. Profile (/profile) - Icon: person

**Actions**:
- Create custom bottom navigation widget
- Implement active state highlighting (pink)
- Integrate with go_router
- Create placeholder screens
- Commit: "Create bottom navigation and placeholder screens"

---

**Phase 4 Complete** ✅ → STOP HERE, wait for user command

---

### [✅] Phase 5: Home Screen Implementation
**Branch**: `phase_home_screen`

#### [✅] Subtask 5.1: Create Home BLoC
**Files**:
- `lib/features/home/presentation/bloc/home_bloc.dart`
- `lib/features/home/presentation/bloc/home_event.dart`
- `lib/features/home/presentation/bloc/home_state.dart`

**Events**:
- LoadProducts
- SelectCategory

**States**:
- HomeInitial
- HomeLoading
- HomeLoaded (with products and selected category)
- HomeError

**Actions**:
- Create BLoC with events and states
- Implement event handlers
- Use GetProducts use case
- Filter by category
- Commit: "Create Home BLoC with state management"

---

#### [✅] Subtask 5.2: Create Product Card Widget
**Files**:
- `lib/features/home/presentation/widgets/product_card.dart`

**UI Elements**:
- Cached network image
- Product name
- Price (formatted)
- Add to cart button (pink circle with +)

**Actions**:
- Create reusable ProductCard widget
- Add hero animation tag
- Add onTap navigation to product detail
- Add onAddToCart callback
- Style matching web design
- Commit: "Create product card widget"

---

#### [✅] Subtask 5.3: Create Banner Carousel
**Files**:
- `lib/features/home/presentation/widgets/banner_carousel.dart`

**Features**:
- Auto-rotating carousel
- 3 promotional banners
- Dots indicator (pink when active)
- Swipeable

**Actions**:
- Create carousel widget
- Add auto-play functionality
- Style dots with AppColors.primary
- Commit: "Create banner carousel widget"

---

#### [✅] Subtask 5.4: Create Category Selector
**Files**:
- `lib/features/home/presentation/widgets/category_selector.dart`

**UI**:
- Horizontal scrollable list
- Category chips with emoji icons
- Selected state (pink background)
- Categories: Все, Уход за лицом, Макияж, Волосы, Аксессуары

**Actions**:
- Create category selector widget
- Implement selection state
- Emit category selection event to BLoC
- Style matching web design
- Commit: "Create category selector widget"

---

#### [✅] Subtask 5.5: Build Home Screen
**Files**:
- `lib/features/home/presentation/screens/home_screen.dart`

**Layout**:
```
AppBar: "Модный дворик" title
└─ ScrollView
   ├─ BannerCarousel
   ├─ CategorySelector
   └─ Product Grid (2 columns)
```

**Actions**:
- Create HomeScreen widget
- Wire BLoC to UI
- Implement loading/error states
- Add product grid
- Handle add to cart
- Commit: "Implement Home screen UI"

---

**Phase 5 Complete** ✅ → STOP HERE, wait for user command

---

### [✅] Phase 6: Category Screen Implementation
**Branch**: `phase_category_screen`

#### [✅] Subtask 6.1: Create Category BLoC
**Files**:
- `lib/features/category/presentation/bloc/category_bloc.dart`
- `lib/features/category/presentation/bloc/category_event.dart`
- `lib/features/category/presentation/bloc/category_state.dart`

**Events**:
- LoadCategoryProducts(categoryId)

**States**:
- CategoryLoading
- CategoryLoaded(products, categoryName)
- CategoryError

**Actions**:
- Create Category BLoC
- Use GetProductsByCategory use case
- Commit: "Create Category BLoC"

---

#### [✅] Subtask 6.2: Build Category Screen
**Files**:
- `lib/features/category/presentation/screens/category_screen.dart`

**Layout**:
```
AppBar: Category name + back button
└─ Product Grid (2 columns)
```

**Actions**:
- Create CategoryScreen widget
- Get categoryId from route params
- Wire BLoC to UI
- Reuse ProductCard widget
- Show empty state if no products
- Commit: "Implement Category screen UI"

---

**Phase 6 Complete** ✅ → STOP HERE, wait for user command

---

### [✅] Phase 7: Product Detail Screen Implementation
**Branch**: `phase_product_detail`

#### [✅] Subtask 7.1: Create Product Detail Cubit
**Files**:
- `lib/features/product/presentation/cubit/product_detail_cubit.dart`
- `lib/features/product/presentation/cubit/product_detail_state.dart`

**State**:
```dart
class ProductDetailState {
  final Product? product;
  final int quantity;
  final bool isFavorite;
  final bool isLoading;
  final String? error;
}
```

**Methods**:
- loadProduct(String id)
- incrementQuantity()
- decrementQuantity()
- toggleFavorite()

**Actions**:
- Create ProductDetailCubit
- Use GetProductById use case
- Manage quantity state
- Commit: "Create Product Detail Cubit"

---

#### [✅] Subtask 7.2: Create Quantity Selector Widget
**Files**:
- `lib/features/product/presentation/widgets/quantity_selector.dart`

**UI**:
```
[−] [count] [+]
```

**Actions**:
- Create quantity selector widget
- Style buttons
- Handle min quantity (1)
- Commit: "Create quantity selector widget"

---

#### [✅] Subtask 7.3: Build Product Detail Screen
**Files**:
- `lib/features/product/presentation/screens/product_detail_screen.dart`

**Layout**:
```
AppBar: Back button
└─ ScrollView
   ├─ Hero Image (full width)
   ├─ Product Name (h2)
   ├─ Price (large, pink)
   ├─ Description section
   ├─ Features section
   ├─ Specifications section
   ├─ Quantity Selector
   └─ Add to Cart Button (full width, pink)
```

**Actions**:
- Create ProductDetailScreen
- Get productId from route params
- Wire Cubit to UI
- Add hero animation for image
- Implement add to cart with quantity
- Show total price on button: "В корзину • {price} ₽"
- Commit: "Implement Product Detail screen UI"

---

**Phase 7 Complete** ✅ → STOP HERE, wait for user command

---

### [✅] Phase 8: Shopping Cart Implementation
**Branch**: `phase_shopping_cart`

#### [✅] Subtask 8.1: Create Cart BLoC
**Files**:
- `lib/features/cart/presentation/bloc/cart_bloc.dart`
- `lib/features/cart/presentation/bloc/cart_event.dart`
- `lib/features/cart/presentation/bloc/cart_state.dart`

**Events**:
- LoadCart
- AddToCart(Product, quantity)
- RemoveFromCart(productId)
- UpdateQuantity(productId, quantity)
- ClearCart

**State**:
```dart
class CartState {
  final List<CartItem> items;
  final double totalPrice;
  final bool isLoading;
  final String? error;
}
```

**Actions**:
- Create Cart BLoC
- Use cart use cases
- Implement persistence with shared_preferences
- Calculate totals
- Commit: "Create Cart BLoC with persistence"

---

#### [✅] Subtask 8.2: Create Cart Item Widget
**Files**:
- `lib/features/cart/presentation/widgets/cart_item_widget.dart`

**UI**:
```
[Image] Product Name        [Trash]
        Price per unit
        [−] [qty] [+]
```

**Actions**:
- Create CartItemWidget
- Show product image, name, price
- Quantity controls
- Remove button
- Emit events to BLoC
- Commit: "Create cart item widget"

---

#### [✅] Subtask 8.3: Create Order Summary Widget
**Files**:
- `lib/features/cart/presentation/widgets/order_summary.dart`

**UI**:
```
Стоимость товаров    xxx ₽
Скидка               -xx ₽
────────────────────────
Итого                xxx ₽
```

**Actions**:
- Create OrderSummary widget
- Calculate discount (if any)
- Show total
- Commit: "Create order summary widget"

---

#### [✅] Subtask 8.4: Build Cart Screen
**Files**:
- `lib/features/cart/presentation/screens/cart_screen.dart`

**Layout**:
```
AppBar: "Ваша корзина"
└─ If empty:
   └─ Empty state with illustration
   Else:
   ├─ Cart Items List
   ├─ Order Summary Card
   └─ Checkout Button
```

**Actions**:
- Create CartScreen
- Wire BLoC to UI
- Show empty state
- Show cart items list
- Add order summary
- Add checkout button (placeholder action)
- Commit: "Implement Cart screen UI"

---

**Phase 8 Complete** ✅ → STOP HERE, wait for user command

---

### [ ] Phase 9: Profile Screen Implementation
**Branch**: `phase_profile_screen`

#### [✅] Subtask 9.1: Create Profile Cubit
**Files**:
- `lib/features/profile/presentation/cubit/profile_cubit.dart`
- `lib/features/profile/presentation/cubit/profile_state.dart`

**State**:
```dart
class ProfileState {
  final User? user;
  final bool isLoading;
  final String? error;
}
```

**Actions**:
- Create ProfileCubit
- Use GetUserProfile use case
- Load mock user data
- Commit: "Create Profile Cubit"

---

#### [✅] Subtask 9.2: Create Loyalty Card Widget
**Files**:
- `lib/features/profile/presentation/widgets/loyalty_card.dart`

**UI**:
```
╔══════════════════════════╗
║ Модный Дворик           ║
║ [MD Logo]               ║
║                         ║
║ 1,250 баллов           ║
╚══════════════════════════╝
```

**Styling**:
- Pink gradient background (primary to primaryDark)
- White text
- Rounded corners
- Shadow

**Actions**:
- Create LoyaltyCard widget
- Apply gradient
- Show bonus points
- Commit: "Create loyalty card widget"

---

#### [✅] Subtask 9.3: Create Profile Menu Items
**Files**:
- `lib/features/profile/presentation/widgets/profile_menu_item.dart`

**Menu Items**:
1. Мои заказы (My Orders)
2. Адреса доставки (Delivery Addresses)
3. Избранное (Favorites)
4. Настройки (Settings)
5. Выйти (Logout)

**Actions**:
- Create ProfileMenuItem widget
- Add icons for each item
- Add navigation placeholders
- Commit: "Create profile menu items"

---

#### [ ] Subtask 9.4: Build Profile Screen
**Files**:
- `lib/features/profile/presentation/screens/profile_screen.dart`

**Layout**:
```
AppBar: "Профиль"
└─ ScrollView
   ├─ User Avatar & Name
   ├─ Email
   ├─ Loyalty Card
   └─ Menu Items List
```

**Actions**:
- Create ProfileScreen
- Wire Cubit to UI
- Show user info
- Add loyalty card
- Add menu items
- Commit: "Implement Profile screen UI"

---

**Phase 9 Complete** ✅ → STOP HERE, wait for user command

---

### [ ] Phase 10: Polish & Refinements
**Branch**: `phase_polish`

#### [ ] Subtask 10.1: Create Shared Widgets
**Files**:
- `lib/core/widgets/custom_button.dart`
- `lib/core/widgets/loading_indicator.dart`
- `lib/core/widgets/error_widget.dart`
- `lib/core/widgets/empty_state_widget.dart`

**Actions**:
- Create reusable button component
- Create consistent loading indicator
- Create error display widget
- Create empty state widget
- Commit: "Create shared UI widgets"

---

#### [ ] Subtask 10.2: Add Animations
**Files**: Update existing screens

**Animations to add**:
- Hero animation for product images (Home → Product Detail)
- Page transitions
- Cart item add/remove animations
- Bottom nav tab transitions

**Actions**:
- Add hero tags to product images
- Add page transition animations in router
- Add cart item slide/fade animations
- Commit: "Add UI animations"

---

#### [ ] Subtask 10.3: Implement Price Formatter Utility
**Files**:
- `lib/core/utils/price_formatter.dart`

**Functionality**:
- Format numbers to Russian price format
- Add ₽ symbol
- Handle decimal places

**Actions**:
- Create PriceFormatter utility
- Use intl package for formatting
- Apply throughout app
- Commit: "Add price formatting utility"

---

#### [ ] Subtask 10.4: Handle Edge Cases
**Updates**: Various screen files

**Edge cases**:
- Empty product lists
- Network errors (future)
- Missing images (placeholder)
- Cart operations (max quantity, duplicate items)
- Invalid product IDs

**Actions**:
- Add error handling throughout
- Add placeholder images
- Add empty states
- Add validation
- Commit: "Handle edge cases and errors"

---

#### [ ] Subtask 10.5: Responsive Design Improvements
**Updates**: Screen and widget files

**Improvements**:
- Safe area handling
- Different screen sizes
- Tablet support
- Landscape orientation

**Actions**:
- Add safe area widgets
- Test on different screen sizes
- Adjust layouts for tablets
- Commit: "Improve responsive design"

---

**Phase 10 Complete** ✅ → STOP HERE, wait for user command

---

### [ ] Phase 11: Testing
**Branch**: `phase_testing`

#### [ ] Subtask 11.1: Unit Tests - Home Feature
**Files**:
- `test/features/home/presentation/bloc/home_bloc_test.dart`
- `test/features/home/domain/usecases/get_products_test.dart`

**Tests**:
- Home BLoC events and states
- Use case functionality
- Repository mock implementation

**Actions**:
- Create unit tests for Home feature
- Test BLoC state transitions
- Test use cases
- Use bloc_test and mocktail
- Commit: "Add unit tests for Home feature"

---

#### [ ] Subtask 11.2: Unit Tests - Cart Feature
**Files**:
- `test/features/cart/presentation/bloc/cart_bloc_test.dart`
- `test/features/cart/domain/usecases/add_to_cart_test.dart`

**Tests**:
- Cart BLoC operations (add, remove, update)
- Cart calculations
- Persistence functionality

**Actions**:
- Create unit tests for Cart feature
- Test all cart operations
- Test total calculations
- Test persistence
- Commit: "Add unit tests for Cart feature"

---

#### [ ] Subtask 11.3: Widget Tests
**Files**:
- `test/features/home/presentation/widgets/product_card_test.dart`
- `test/features/cart/presentation/widgets/cart_item_widget_test.dart`

**Tests**:
- ProductCard rendering
- CartItemWidget interactions
- Button actions
- State updates

**Actions**:
- Create widget tests for key components
- Test user interactions
- Test UI rendering
- Commit: "Add widget tests"

---

#### [ ] Subtask 11.4: Integration Tests (Optional)
**Files**:
- `integration_test/app_test.dart`

**Tests**:
- Complete user flows
- Navigation between screens
- Add to cart flow
- End-to-end scenarios

**Actions**:
- Create integration test file
- Test complete user journeys
- Test navigation
- Commit: "Add integration tests"

---

**Phase 11 Complete** ✅ → STOP HERE, wait for user command

---

## COMPLETION CHECKLIST

### Functionality Verification
- [ ] App launches without errors
- [ ] Home screen displays banner and products
- [ ] Category filtering works
- [ ] Product detail shows correct information
- [ ] Add to cart functionality works
- [ ] Cart displays items correctly
- [ ] Cart quantity controls work
- [ ] Cart persists across app restarts
- [ ] Profile displays user info and loyalty card
- [ ] Bottom navigation works correctly
- [ ] All routes navigate properly

### Visual Verification
- [ ] Colors match web design (#EF2AC1 primary)
- [ ] Manrope font displays correctly
- [ ] Russian text renders properly
- [ ] Product images load and display
- [ ] Layouts are responsive
- [ ] Animations are smooth
- [ ] Loading states display correctly
- [ ] Error states display correctly

### Code Quality
- [ ] No lint errors
- [ ] Code follows Clean Architecture
- [ ] BLoC pattern implemented correctly
- [ ] All features have tests
- [ ] Git history is clean with descriptive commits

---

## FINAL MERGE

After all phases complete:

```bash
# Merge all phase branches to main
git checkout main
git merge phase_foundation
git merge phase_data_layer
git merge phase_domain_layer
git merge phase_navigation
git merge phase_home_screen
git merge phase_category_screen
git merge phase_product_detail
git merge phase_shopping_cart
git merge phase_profile_screen
git merge phase_polish
git merge phase_testing

# Tag release
git tag v1.0.0
git push origin main --tags
```

---

## STATUS TRACKING

**Current Phase**: Phase 6 Complete
**Current Subtask**: All Phase 6 subtasks complete
**Last Completed**: Phase 6: Category Screen Implementation

**Progress**: 6/11 phases completed

---

## NOTES

- All text in Russian (matching web app)
- Use mock data (no API integration yet)
- Prepare data layer for future API
- Keep domain layer pure (no Flutter dependencies)
- Follow Clean Architecture strictly
- Create meaningful commit messages
- Stop after each phase and wait for user command

---

**Ready to begin Phase 1!** 🚀
