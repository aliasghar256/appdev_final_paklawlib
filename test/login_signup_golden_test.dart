import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:mocktail/mocktail.dart';
import 'package:finalproject/bloc/auth_bloc/auth_bloc.dart';
import 'package:finalproject/bloc/auth_bloc/auth_event.dart';
import 'package:finalproject/bloc/auth_bloc/auth_state.dart';
import 'package:finalproject/login_signup_page.dart';

/// MockAuthBloc
/// MockAuthBloc
/// MockAuthBloc
class MockAuthBloc extends MockBloc<AuthEvent, AuthState> implements AuthBloc {
  @override
  void add(AuthEvent event) {
    super.noSuchMethod(Invocation.method(#add, [event]));
  }

  @override
  Future<void> close() {
    // Removed extra arguments
    return super.noSuchMethod(Invocation.method(#close, []), Future.value());
  }

  @override
  Stream<AuthState> get stream {
    // Removed extra arguments
    return super.noSuchMethod(Invocation.getter(#stream), Stream.empty());
  }

  @override
  AuthState get state {
    return super.noSuchMethod(Invocation.getter(#state), AuthInitial());
  }

  @override
  void emit(AuthState state) {
    super.noSuchMethod(Invocation.method(#emit, [state]));
  }

  @override
  void on<T extends AuthEvent>(
    EventTransformer<T> transformer,
    void Function(T event, Emitter<AuthState> emit) handler,
  ) {
    super.noSuchMethod(Invocation.method(#on, [transformer, handler]));
  }

  @override
  void onEvent(AuthEvent event) {
    super.noSuchMethod(Invocation.method(#onEvent, [event]));
  }

  @override
  void onTransition(Transition<AuthEvent, AuthState> transition) {
    super.noSuchMethod(Invocation.method(#onTransition, [transition]));
  }

  @override
  void addError(Object error, [StackTrace? stackTrace]) {
    super.noSuchMethod(Invocation.method(#addError, [error, stackTrace]));
  }
}



/// Ensure fonts are loaded
Future<void> preloadMaterialFonts() async {
  final fontLoader = FontLoader('Roboto');
  fontLoader.addFont(rootBundle.load('packages/flutter/assets/Roboto-Regular.ttf'));
  fontLoader.addFont(rootBundle.load('packages/flutter/assets/Roboto-Medium.ttf'));
  await fontLoader.load();
}

void main() {
  late MockAuthBloc mockAuthBloc;

  setUpAll(() async {
    await preloadMaterialFonts();
  });

  setUp(() {
    mockAuthBloc = MockAuthBloc();
  });

  tearDown(() {
    mockAuthBloc.close();
  });

  testGoldens('Golden Test: LoginSignupPage - Login State', (WidgetTester tester) async {
    // Arrange
    when(() => mockAuthBloc.state).thenReturn(AuthInitial());

    final loginSignupWidget = MaterialApp(
      home: BlocProvider<AuthBloc>.value(
        value: mockAuthBloc,
        child: LoginSignupPage(),
      ),
    );

    // Act
    await tester.pumpWidgetBuilder(
      loginSignupWidget,
      surfaceSize: const Size(800, 1200),
    );
    await tester.pumpAndSettle();

    // Assert
    await screenMatchesGolden(tester, 'login_signup_page_login');
  });
}
