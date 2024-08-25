import 'package:flutter_bloc/flutter_bloc.dart';
import 'profile_event.dart';
import 'profile_state.dart';
import '../../core/services/firestore_service.dart';
import '../../data/models/user_model.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final FirestoreService _firestoreService;

  ProfileBloc(this._firestoreService) : super(ProfileInitial());

  @override
  Stream<ProfileState> mapEventToState(ProfileEvent event) async* {
    if (event is LoadUserProfile) {
      yield ProfileLoading();
      try {
        final user = await _firestoreService.getUserById(event.userId);
        if (user != null) {
          yield ProfileLoaded(user: user);
        } else {
          yield ProfileError(message: 'Profil utilisateur non trouvé.');
        }
      } catch (e) {
        yield ProfileError(message: e.toString());
      }
    } else if (event is UpdateUserProfile) {
      yield ProfileLoading();
      try {
        await _firestoreService.updateUser(event.user);
        yield ProfileUpdated();
      } catch (e) {
        yield ProfileError(message: e.toString());
      }
    }
  }
}
