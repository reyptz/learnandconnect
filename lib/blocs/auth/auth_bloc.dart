import 'package:flutter_bloc/flutter_bloc.dart';
import 'auth_event.dart';
import 'auth_state.dart';
import '../../core/services/auth_service.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthService _authService;

  AuthBloc(this._authService) : super(AuthInitial());

  @override
  Stream<AuthState> mapEventToState(AuthEvent event) async* {
    if (event is AuthSignIn) {
      yield AuthLoading();
      try {
        final user = await _authService.signIn(event.email, event.password);
        if (user != null) {
          yield AuthSuccess(user: user);
        } else {
          yield AuthFailure(message: 'Connexion échouée. Veuillez réessayer.');
        }
      } catch (e) {
        yield AuthFailure(message: e.toString());
      }
    } else if (event is AuthSignOut) {
      await _authService.signOut();
      yield AuthInitial();
    }
  }
}
