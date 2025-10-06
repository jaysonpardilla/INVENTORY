// lib/core/config.dart
class Config {
  static const cloudinaryUploadUrl =
      "https://api.cloudinary.com/v1_1/dkvhqzo31/image/upload";

  static const cloudinaryUploadPreset = "new-inventory"; 

  // Firestore collections
  static const usersCollection = 'users';
  static const productsCollection = 'products';
  static const categoriesCollection = 'categories';
  static const suppliersCollection = 'suppliers';
  static const transactionsCollection = 'transactions';
  static const dailySalesCollection = 'daily_sales';
  
  // 💡 NEW: Added the missing collections
  static const weeklySalesCollection = 'weekly_sales';
  static const monthlySalesCollection = 'monthly_sales';
  
  static const totalSalesCollection = 'total_sales';
}