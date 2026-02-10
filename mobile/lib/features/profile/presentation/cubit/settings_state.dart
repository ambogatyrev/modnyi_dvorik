import 'package:equatable/equatable.dart';

import '../../domain/entities/user.dart';

/// Base class for all settings states
abstract class SettingsState extends Equatable {
  const SettingsState();

  @override
  List<Object?> get props => [];
}

/// Initial state when settings is first created
class SettingsInitial extends SettingsState {
  const SettingsInitial();
}

/// State when settings data is loading
class SettingsLoading extends SettingsState {
  const SettingsLoading();
}

/// State when settings data is loaded successfully
class SettingsLoaded extends SettingsState {
  final User user;

  const SettingsLoaded(this.user);

  @override
  List<Object?> get props => [user];
}

/// State when settings are being saved
class SettingsSaving extends SettingsState {
  final User user;

  const SettingsSaving(this.user);

  @override
  List<Object?> get props => [user];
}

/// State when settings saved successfully
class SettingsSaved extends SettingsState {
  final User user;

  const SettingsSaved(this.user);

  @override
  List<Object?> get props => [user];
}

/// State when there's an error in settings
class SettingsError extends SettingsState {
  final String message;

  const SettingsError(this.message);

  @override
  List<Object?> get props => [message];
}
