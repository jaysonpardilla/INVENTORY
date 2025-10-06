// lib/features/auth/domain/usecases/sign_in_usecase.dart

import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../core/failures/failures.dart';
import '../repositories/auth_repository.dart';

class SignInUsecase {
  final AuthRepository repository;

  SignInUsecase(this.repository);

  Future<Either<Failure, User?>> call(String email, String password) async {
    try {
      final user = await repository.signIn(email, password);
      
      // Handle the unexpected case where the repository returns null without throwing
      if (user == null) {
        return const Left(AuthFailure(message: 'Invalid credentials or user not found.'));
      }
      return Right(user);

    } on AuthFailure catch (e) {
      // ✅ Clean: Catches the specific AuthFailure THROWN by the Repository (e.g., "Wrong password.")
      return Left(e); 
      
    } catch (e) {
      // ✅ Clean: Catches all other unexpected exceptions (e.g., network issues)
      return Left(ServerFailure(message: 'An unexpected error occurred: ${e.toString()}'));
    }
  }
}