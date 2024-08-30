import 'package:bloc/bloc.dart';
import 'profile_event.dart';
import 'profile_state.dart';
import '../../core/services/firestore_service.dart';
import '../../data/models/user_model.dart';
import '../../data/repositories/user_repository.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final UserRepository userRepository;

  ProfileBloc({required this.userRepository}) : super(ProfileLoading()) {
    on<LoadUserProfile>((event, emit) async {
      try {
        final user = await userRepository.getUserById(event.userId) as User;
        emit(ProfileLoaded(user: user));
      } catch (error) {
        emit(ProfileError(error: error.toString()));
      }
    });

    on<UpdateUserProfile>((event, emit) async {
      try {
        await userRepository.updateUser(event.user);
        emit(ProfileLoaded(user: event.user));
      } catch (error) {
        emit(ProfileError(error: error.toString()));
      }
    });
  }
}
