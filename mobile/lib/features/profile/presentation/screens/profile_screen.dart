import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../data/repositories/user_repository_impl.dart';
import '../../domain/usecases/get_user_profile.dart';
import '../cubit/profile_cubit.dart';
import '../cubit/profile_state.dart';
import '../widgets/loyalty_card.dart';
import '../widgets/profile_menu_item.dart';

/// Profile Screen - displays user profile information and settings
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        // Create repository and use case
        final repository = UserRepositoryImpl();
        final getUserProfile = GetUserProfile(repository);

        // Create and initialize Cubit
        return ProfileCubit(
          getUserProfile: getUserProfile,
        )..loadProfile();
      },
      child: const _ProfileScreenView(),
    );
  }
}

class _ProfileScreenView extends StatelessWidget {
  const _ProfileScreenView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.muted,
      appBar: AppBar(
        title: const Text('Профиль'),
        centerTitle: false,
      ),
      body: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) {
          if (state is ProfileLoading) {
            return const Center(
              child: CircularProgressIndicator(
                color: AppColors.primary,
              ),
            );
          }

          if (state is ProfileError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 64,
                    color: AppColors.error,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    state.message,
                    style: Theme.of(context).textTheme.bodyLarge,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      context.read<ProfileCubit>().loadProfile();
                    },
                    child: const Text('Повторить'),
                  ),
                ],
              ),
            );
          }

          if (state is ProfileLoaded) {
            final user = state.user;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // User Avatar and Info
                  _buildUserHeader(context, user.name, user.email),
                  const SizedBox(height: 24),

                  // Loyalty Card
                  LoyaltyCard(bonusPoints: user.bonusPoints),
                  const SizedBox(height: 24),

                  // Menu Items Section
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        ProfileMenuItem(
                          icon: Icons.shopping_bag_outlined,
                          label: 'Мои заказы',
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Раздел "Мои заказы" в разработке'),
                                backgroundColor: AppColors.info,
                              ),
                            );
                          },
                        ),
                        ProfileMenuItem(
                          icon: Icons.location_on_outlined,
                          label: 'Адреса доставки',
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Раздел "Адреса доставки" в разработке',
                                ),
                                backgroundColor: AppColors.info,
                              ),
                            );
                          },
                        ),
                        ProfileMenuItem(
                          icon: Icons.favorite_outline,
                          label: 'Избранное',
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Раздел "Избранное" в разработке'),
                                backgroundColor: AppColors.info,
                              ),
                            );
                          },
                        ),
                        ProfileMenuItem(
                          icon: Icons.settings_outlined,
                          label: 'Настройки',
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Раздел "Настройки" в разработке'),
                                backgroundColor: AppColors.info,
                              ),
                            );
                          },
                        ),
                        ProfileMenuItem(
                          icon: Icons.logout,
                          label: 'Выйти',
                          iconColor: AppColors.error,
                          onTap: () {
                            _showLogoutDialog(context);
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildUserHeader(BuildContext context, String name, String email) {
    return Row(
      children: [
        // Avatar
        Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.primary,
                AppColors.primaryDark,
              ],
            ),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              name.isNotEmpty ? name[0].toUpperCase() : 'U',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
            ),
          ),
        ),
        const SizedBox(width: 16),

        // Name and Email
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: AppColors.darkBlue,
                      fontWeight: FontWeight.w700,
                    ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                email,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Выйти из аккаунта?'),
        content: const Text('Вы уверены, что хотите выйти?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Отмена'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Функция выхода в разработке'),
                  backgroundColor: AppColors.info,
                ),
              );
            },
            child: Text(
              'Выйти',
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }
}
