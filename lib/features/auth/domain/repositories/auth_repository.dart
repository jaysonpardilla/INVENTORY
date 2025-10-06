// lib/features/auth/domain/repositories/auth_repository.dart
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import '../entities/app_user.dart';

abstract class AuthRepository {
  // Streams the current authentication state (Firebase User)
  Stream<User?> get userStream;

  // Sign up and create a corresponding AppUser entity
  Future<User?> signUp(String username, String email, String password);

  // Sign in with existing credentials
  Future<User?> signIn(String email, String password);

  // Sign out the current user
  Future<void> signOut();

  // Get the currently logged-in Firebase User instance
  User? getCurrentUser();
  
  // Upload a file and return the public URL (using Cloudinary service)
  Future<String?> uploadProfilePicture(File file);

  // Get the full AppUser entity data from the database
  Future<AppUser?> getAppUser(String uid);
}