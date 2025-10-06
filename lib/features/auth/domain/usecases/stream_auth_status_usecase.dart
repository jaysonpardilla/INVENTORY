// lib/features/auth/domain/usecases/stream_auth_status_usecase.dart
import 'package:firebase_auth/firebase_auth.dart';
import '../repositories/auth_repository.dart';

class StreamAuthStatusUsecase {
  final AuthRepository repository;
  StreamAuthStatusUsecase(this.repository);

  // Directly exposes the stream from the repository (Data Layer)
  Stream<User?> call() {
    return repository.userStream;
  }
}