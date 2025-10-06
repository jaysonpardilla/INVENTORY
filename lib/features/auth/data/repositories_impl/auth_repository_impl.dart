// lib/features/auth/data/repositories_impl/auth_repository_impl.dart

import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';

// Data Sources (The dependencies this layer relies on)
import '../datasources/auth_service.dart';
import '../datasources/cloudinary_service.dart';

// Domain Layer Contracts and Entities
import '../../domain/repositories/auth_repository.dart';
import '../../domain/entities/app_user.dart';
import '../../../../core/failures/failures.dart'; // Import Failure for potential error handling

class AuthRepositoryImpl implements AuthRepository {
  final AuthService authService;
  final CloudinaryService cloudinaryService;

  AuthRepositoryImpl({
    required this.authService,
    required this.cloudinaryService,
  });

  @override
  Stream<User?> get userStream => authService.userStream;

  @override
  User? getCurrentUser() => authService.currentUser;

  @override
  Future<User?> signUp(String username, String email, String password) async {
    try {
      return await authService.registerWithEmail(username, email, password);
    } on FirebaseAuthException catch (e) {
      String message = 'Sign up failed.';
      switch (e.code) {
        case 'email-already-in-use':
          message = "This email is already registered.";
          break;
        case 'weak-password':
          message = "Password is too weak. Try something stronger.";
          break;
        case 'invalid-email':
          message = "The email address is badly formatted.";
          break;
        default:
          message = e.message ?? 'Sign up failed.';
      }
      // Throw the mapped failure, which Usecase will catch.
      throw AuthFailure(message: message);
    }
  }

  @override
  Future<User?> signIn(String email, String password) async {
    try {
      return await authService.signInWithEmail(email, password);
    } on FirebaseAuthException catch (e) {
      String message = 'Sign in failed.';
      switch (e.code) {
        case 'user-not-found':
          message = "No user found for this email.";
          break;
        case 'wrong-password':
        case 'invalid-credential':
          message = "Wrong password. Please try again.";
          break;
        case 'invalid-email':
          message = "The email address is badly formatted.";
          break;
        case 'too-many-requests':
          message = "Access temporarily blocked due to too many failed attempts.";
          break;
        default:
          message = e.message ?? 'Sign in failed.';
      }
      // Throw the mapped failure, which Usecase will catch.
      throw AuthFailure(message: message);
    }
  }

  @override
  Future<void> signOut() async {
    await authService.signOut();
  }
  
  @override
  Future<String?> uploadProfilePicture(File file) async {
    return await cloudinaryService.uploadFile(file);
  }

  @override
  Future<AppUser?> getAppUser(String uid) async {
    return null; 
  }
}



