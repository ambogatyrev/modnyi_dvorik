import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/user.dart';
import '../../domain/usecases/get_user_profile.dart';
import '../../domain/usecases/update_user_profile.dart';
import 'settings_state.dart';

/// Cubit for managing user settings state
class SettingsCubit extends Cubit<SettingsState> {
  final GetUserProfile getUserProfile;
  final UpdateUserProfile updateUserProfile;

  SettingsCubit({
    required this.getUserProfile,
    required this.updateUserProfile,
  }) : super(const SettingsInitial());

  /// Load current user settings
  Future<void> loadSettings() async {
    try {
      emit(const SettingsLoading());
      final user = await getUserProfile();
      emit(SettingsLoaded(user));
    } catch (e) {
      emit(SettingsError('Не удалось загрузить настройки: ${e.toString()}'));
    }
  }

  /// Save updated user settings
  Future<void> saveSettings({
    required String name,
    required String phone,
    required String address,
    required String password,
  }) async {
    final currentState = state;
    if (currentState is! SettingsLoaded) return;

    try {
      final updatedUser = User(
        id: currentState.user.id,
        name: name,
        phone: phone,
        address: address,
        bonusPoints: currentState.user.bonusPoints,
        password: password,
      );

      emit(SettingsSaving(updatedUser));
      await updateUserProfile(updatedUser);
      emit(SettingsSaved(updatedUser));
    } catch (e) {
      emit(SettingsError('Не удалось сохранить настройки: ${e.toString()}'));
    }
  }
}
