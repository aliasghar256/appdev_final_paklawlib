import 'package:bloc_test/bloc_test.dart';
import 'package:finalproject/bloc/auth_bloc/auth_bloc.dart';
import 'package:finalproject/bloc/auth_bloc/auth_event.dart';
import 'package:finalproject/bloc/auth_bloc/auth_state.dart';
import 'package:finalproject/managers/auth_manger.dart';
import 'package:finalproject/models/user_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthManager extends Mock implements AuthManager {}
class MockUser extends Mock implements User {}

void main() {
  late MockAuthManager mockAuthManager;
  late AuthBloc authBloc;

  setUp(() {
    mockAuthManager = MockAuthManager();
    authBloc = AuthBloc(auth: mockAuthManager);
  });

  tearDown(() {
    authBloc.close();
  });

  // Register a fallback value for the User class (if needed for mocktail)
  setUpAll(() {
  registerFallbackValue(MockUser());
  });


  blocTest<AuthBloc, AuthState>(
    'emits [AuthLoading, AuthLoggedIn] when signup is successful',
    build: () {
      when(() => mockAuthManager.signUp(email: any(named: 'email'), password: any(named: 'password')))
          .thenAnswer((_) async => {'success': true, 'user': User(id: '1', email: 'test@example.com')});
      when(() => mockAuthManager.login(email: any(named: 'email'), password: any(named: 'password')))
          .thenAnswer((_) async => {'success': true, 'user': User(id: '1', email: 'test@example.com')});
      return authBloc;
    },
    act: (bloc) => bloc.add(AuthSignupEvent(email: 'test@example.com', password: 'password123')),
    expect: () => [
      AuthLoading(),
      AuthLoggedIn(user: User(id: '1', email: 'test@example.com')),
    ],
  );

  blocTest<AuthBloc, AuthState>(
    'emits [AuthLoading, AuthError] when signup fails',
    build: () {
      when(() => mockAuthManager.signUp(email: any(named: 'email'), password: any(named: 'password')))
          .thenAnswer((_) async => {'success': false, 'message': 'Signup failed'});
      return authBloc;
    },
    act: (bloc) => bloc.add(AuthSignupEvent(email: 'test@example.com', password: 'password123')),
    expect: () => [
      AuthLoading(),
      AuthError(message: 'Signup failed'),
    ],
  );

  blocTest<AuthBloc, AuthState>(
    'emits [AuthLoading, AuthLoggedIn] when login is successful',
    build: () {
      when(() => mockAuthManager.login(email: any(named: 'email'), password: any(named: 'password')))
          .thenAnswer((_) async => {'success': true, 'user': User(id: '1', email: 'test@example.com')});
      return authBloc;
    },
    act: (bloc) => bloc.add(AuthLoginEvent(email: 'test@example.com', password: 'password123')),
    expect: () => [
      AuthLoading(),
      AuthLoggedIn(user: User(id: '1', email: 'test@example.com')),
    ],
  );

  blocTest<AuthBloc, AuthState>(
    'emits [AuthLoading, AuthError] when login fails',
    build: () {
      when(() => mockAuthManager.login(email: any(named: 'email'), password: any(named: 'password')))
          .thenAnswer((_) async => {'success': false, 'message': 'Login failed'});
      return authBloc;
    },
    act: (bloc) => bloc.add(AuthLoginEvent(email: 'test@example.com', password: 'password123')),
    expect: () => [
      AuthLoading(),
      AuthError(message: 'Login failed'),
    ],
  );

  blocTest<AuthBloc, AuthState>(
    'emits [AuthLoading, AuthInitial] when logout is successful',
    build: () {
      return authBloc;
    },
    act: (bloc) => bloc.add(AuthSignoutEvent()),
    expect: () => [
      AuthLoading(),
      AuthInitial(),
    ],
  );
}
