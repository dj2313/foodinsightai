import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'auth_providers.dart';
import 'auth_repository.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(
    auth: ref.watch(firebaseAuthProvider),
    firestore: ref.watch(firestoreProvider),
  );
});

class AuthState {
  const AuthState({this.isLoading = false, this.errorMessage});

  final bool isLoading;
  final String? errorMessage;

  AuthState copyWith({bool? isLoading, String? errorMessage}) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}

final authControllerProvider = StateNotifierProvider<AuthController, AuthState>(
  (ref) {
    final repo = ref.watch(authRepositoryProvider);
    return AuthController(repo);
  },
);

class AuthController extends StateNotifier<AuthState> {
  AuthController(this._repo) : super(const AuthState());

  final AuthRepository _repo;

  Future<bool> signUp({
    required String email,
    required String password,
    required String displayName,
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      await _repo.signUpWithEmail(
        email: email,
        password: password,
        displayName: displayName,
      );
      // After signup, sign out to force explicit login flow.
      await _repo.signOut();
      return true;
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
      return false;
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<bool> signIn({required String email, required String password}) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      await _repo.signInWithEmail(email: email, password: password);
      return true;
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
      return false;
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> signOut() async {
    await _repo.signOut();
  }
}
