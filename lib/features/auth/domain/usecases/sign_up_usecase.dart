// lib/features/auth/domain/usecases/sign_up_usecase.dart

import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../core/failures/failures.dart';
import '../repositories/auth_repository.dart';

class SignUpUsecase {
  final AuthRepository repository;

  SignUpUsecase(this.repository);

  Future<Either<Failure, User?>> call(
      String username, String email, String password) async {
    try {
      final user = await repository.signUp(username, email, password);
      
      if (user == null) {
        return const Left(AuthFailure(message: 'Registration failed unexpectedly.'));
      }
      return Right(user);
      
    } on AuthFailure catch (e) {
      // ✅ Clean: Catches the specific AuthFailure THROWN by the Repository (e.g., "Email already in use.")
      return Left(e);

    } catch (e) {
      // ✅ Clean: Catches all other unexpected exceptions
      return Left(ServerFailure(message: 'An unexpected error occurred: ${e.toString()}'));
    }
  }
}