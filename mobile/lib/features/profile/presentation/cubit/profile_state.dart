import 'package:equatable/equatable.dart';
import '../../domain/entities/user.dart';

/// Base class for all profile states
abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object?> get props => [];
}

/// Initial state when profile is first created
class ProfileInitial extends ProfileState {
  const ProfileInitial();
}

/// State when profile is loading
class ProfileLoading extends ProfileState {
  const ProfileLoading();
}

/// State when profile is loaded successfully
class ProfileLoaded extends ProfileState {
  final User user;

  const ProfileLoaded(this.user);

  @override
  List<Object?> get props => [user];

  /// Create a copy of this state with updated user
  ProfileLoaded copyWith({User? user}) {
    return ProfileLoaded(user ?? this.user);
  }
}

/// State when there's an error loading profile
class ProfileError extends ProfileState {
  final String message;

  const ProfileError(this.message);

  @override
  List<Object?> get props => [message];
}
