import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../data/repositories/user_repository_impl.dart';
import '../../domain/usecases/get_user_profile.dart';
import '../../domain/usecases/update_user_profile.dart';
import '../cubit/settings_cubit.dart';
import '../cubit/settings_state.dart';

/// Settings screen for editing user profile data
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final repository = UserRepositoryImpl();
        final getUserProfile = GetUserProfile(repository);
        final updateUserProfile = UpdateUserProfile(repository);
        return SettingsCubit(
          getUserProfile: getUserProfile,
          updateUserProfile: updateUserProfile,
        )..loadSettings();
      },
      child: const _SettingsScreenView(),
    );
  }
}

class _SettingsScreenView extends StatefulWidget {
  const _SettingsScreenView();

  @override
  State<_SettingsScreenView> createState() => _SettingsScreenViewState();
}

class _SettingsScreenViewState extends State<_SettingsScreenView> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Настройки')),
      body: BlocConsumer<SettingsCubit, SettingsState>(
        listener: (context, state) {
          if (state is SettingsLoaded) {
            _nameController.text = state.user.name;
            _phoneController.text = state.user.phone;
            _addressController.text = state.user.address;
            _passwordController.text = state.user.password;
          }
          if (state is SettingsSaved) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Настройки сохранены'),
                backgroundColor: AppColors.success,
              ),
            );
            context.pop();
          }
          if (state is SettingsError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.error,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is SettingsLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }

          final isSaving = state is SettingsSaving;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLabel('Имя'),
                  const SizedBox(height: 8),
                  _buildTextField(
                    controller: _nameController,
                    hintText: 'Введите имя',
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Введите имя';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  _buildLabel('Телефон'),
                  const SizedBox(height: 8),
                  _buildTextField(
                    controller: _phoneController,
                    hintText: '+7 (___) ___-__-__',
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Введите номер телефона';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  _buildLabel('Адрес'),
                  const SizedBox(height: 8),
                  _buildTextField(
                    controller: _addressController,
                    hintText: 'Введите адрес',
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Введите адрес';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  _buildLabel('Пароль'),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    decoration: InputDecoration(
                      hintText: 'Введите пароль',
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: AppColors.mutedForeground,
                        ),
                        onPressed: () {
                          setState(
                            () => _obscurePassword = !_obscurePassword,
                          );
                        },
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: AppColors.border),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: AppColors.border),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: AppColors.primary,
                          width: 2,
                        ),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: AppColors.error),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: AppColors.error,
                          width: 2,
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Введите пароль';
                      }
                      if (value.length < 6) {
                        return 'Пароль должен быть не менее 6 символов';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 32),

                  SizedBox(
                    width: double.infinity,
                    child: CustomButton.primary(
                      text: 'Сохранить',
                      isLoading: isSaving,
                      onPressed: isSaving ? null : _saveSettings,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.darkBlue,
          ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: AppColors.primary,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: AppColors.error,
            width: 2,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
      ),
      validator: validator,
    );
  }

  void _saveSettings() {
    if (_formKey.currentState!.validate()) {
      context.read<SettingsCubit>().saveSettings(
            name: _nameController.text.trim(),
            phone: _phoneController.text.trim(),
            address: _addressController.text.trim(),
            password: _passwordController.text,
          );
    }
  }
}
