import 'package:apnamall_ecommerce_app/features/profile/bloc/profile_event.dart';
import 'package:apnamall_ecommerce_app/features/profile/bloc/profile_state.dart';
import 'package:apnamall_ecommerce_app/features/profile/data/profile_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileRepository profileRepository;

  ProfileBloc({required this.profileRepository}) : super(ProfileInitial()) {
    on<LoadUserProfileEvent>((event, emit) async {
      emit(ProfileLoading());
      try {
        final profile = await profileRepository.fetchUserProfile();
        emit(ProfileLoaded(profile));
      } catch (e) {
        emit(ProfileError(e.toString()));
      }
    });
  }
}
