import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_user_profile.dart';
import 'profile_state.dart';

/// Cubit for managing user profile state
/// Handles loading and updating user profile data
class ProfileCubit extends Cubit<ProfileState> {
  final GetUserProfile getUserProfile;

  ProfileCubit({
    required this.getUserProfile,
  }) : super(const ProfileInitial());

  /// Load user profile data
  Future<void> loadProfile() async {
    try {
      emit(const ProfileLoading());

      final user = await getUserProfile();

      emit(ProfileLoaded(user));
    } catch (e) {
      emit(ProfileError('Не удалось загрузить профиль: ${e.toString()}'));
    }
  }

  /// Refresh profile data
  Future<void> refreshProfile() async {
    await loadProfile();
  }
}
