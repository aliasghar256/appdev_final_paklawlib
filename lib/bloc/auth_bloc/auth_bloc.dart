import 'package:bloc/bloc.dart';
import 'auth_event.dart';
import 'auth_state.dart';
import '../../managers/auth_manger.dart';
import '../../models/user_model.dart';
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthManager auth;

  AuthBloc({required this.auth}) : super(AuthInitial()) {
    // Handle Signup Event
    on<AuthSignupEvent>((event, emit) async {
      emit(AuthLoading());
      try {
        // Call AuthManager signup
        final result = await auth.signUp(email: event.email, password: event.password);

        if (result['success'] == true) {
          // Emit success state with user info
          final user = result['user'] as User;
          final result2 = await auth.login(email: event.email, password: event.password);
          if (result['success'] == true) {
          // Emit success state with user info
          final user = result['user'] as User;

          emit(AuthLoggedIn(user: user));
        }
          else {
            // Emit failure state with message
            emit(AuthError(message: result['message']));
          }
        } else {
          // Emit failure state with message
          emit(AuthError(message: result['message']));
        }
      } catch (e) {
        emit(AuthError(message: 'Signup error: $e'));
      }
    });

    // Handle Login Event
    on<AuthLoginEvent>((event, emit) async {
      emit(AuthLoading());
      try {
        // Call AuthManager login
        final result = await auth.login(email: event.email, password: event.password);

        if (result['success'] == true) {
          // Emit success state with user info
          final user = result['user'] as User;

          emit(AuthLoggedIn(user: user));
        } else {
          // Emit failure state with message
          emit(AuthError(message: result['message']));
        }
      } catch (e) {
        emit(AuthError(message: 'Login error: $e'));
      }
    });

    // Handle Signout Event
    on<AuthSignoutEvent>((event, emit) async {
      emit(AuthLoading());
      try {
        // No specific sign-out logic in AuthManager, so reset state
        emit(AuthInitial());
      } catch (e) {
        emit(AuthError(message: 'Signout error: $e'));
      }
    });
  }
}
