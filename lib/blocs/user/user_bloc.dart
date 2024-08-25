import 'package:flutter_bloc/flutter_bloc.dart';
import 'user_event.dart';
import 'user_state.dart';
import '../../core/services/user_service.dart';
import '../../data/models/user_model.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserService _userService;

  UserBloc(this._userService) : super(UserInitial());

  @override
  Stream<UserState> mapEventToState(UserEvent event) async* {
    if (event is LoadUsers) {
      yield UserLoading();
      try {
        final users = await _userService.getAllUsers();
        yield UserLoaded(users: users);
      } catch (e) {
        yield UserError(message: e.toString());
      }
    } else if (event is AddUser) {
      try {
        await _userService.addUser(event.user);
        add(LoadUsers());  // Recharge les utilisateurs après ajout
      } catch (e) {
        yield UserError(message: e.toString());
      }
    } else if (event is UpdateUser) {
      try {
        await _userService.updateUser(event.user);
        add(LoadUsers());  // Recharge les utilisateurs après mise à jour
      } catch (e) {
        yield UserError(message: e.toString());
      }
    } else if (event is DeleteUser) {
      try {
        await _userService.deleteUser(event.userId);
        add(LoadUsers());  // Recharge les utilisateurs après suppression
      } catch (e) {
        yield UserError(message: e.toString());
      }
    }
  }
}
