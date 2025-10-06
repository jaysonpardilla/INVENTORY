import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:inventory_app/features/categories/data/datasources/category_datasource.dart';
import 'package:provider/provider.dart';
import '../../../auth/data/datasources/auth_service.dart';
//import '../../services/firestore_service.dart';
import '../../../auth/data/datasources/cloudinary_service.dart';
import '../../domain/entities/category.dart';
import 'package:uuid/uuid.dart';

class CategoryFormScreen extends StatefulWidget {
  final Category? category;
  const CategoryFormScreen({super.key, this.category});

  @override
  State<CategoryFormScreen> createState() => _CategoryFormScreenState();
}

class _CategoryFormScreenState extends State<CategoryFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  File? _imageFile;
  bool _saving = false;

  final _cloudinary = CloudinaryService();
  final Uuid uuid = const Uuid();

  @override
  void initState() {
    super.initState();
    if (widget.category != null) {
      _nameController.text = widget.category!.name;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _imageFile = File(picked.path);
      });
    }
  }

  Future<void> _saveCategory() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _saving = true);
    final categoryFirestore = Provider.of<CategoryDataSource>(context, listen: false);
    final auth = Provider.of<AuthService>(context, listen: false);
    final userId = auth.currentUser!.uid;
    String imageUrl = widget.category?.imageUrl ?? '';

    try {
      // 1. Upload image if a new one is selected
      if (_imageFile != null) {
        final url = await _cloudinary.uploadFile(_imageFile!);
        if (url != null) {
          imageUrl = url;
        }
      }

      final newCategory = Category(
        id: widget.category?.id ?? uuid.v4(),
        name: _nameController.text.trim(),
        imageUrl: imageUrl,
        ownerId: userId,
      );

      // 2. Add or Update to Firestore
      if (widget.category == null) {
        await categoryFirestore.addCategory(newCategory);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Category created successfully')));
        }
      } else {
        await categoryFirestore.updateCategory(newCategory);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Category updated successfully')));
        }
      }

      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        setState(() => _saving = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving category: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.category == null ? "Create Category" : "Edit Category",
          style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Card(
              elevation: 8,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // 🔹 Image Picker Area
                      _ImagePickerArea(
                        currentImageUrl: widget.category?.imageUrl,
                        imageFile: _imageFile,
                        onPickImage: _pickImage,
                      ),
                      const SizedBox(height: 24),

                      // 🔹 Category Name Field
                      TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          labelText: "Category Name",
                          border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                          prefixIcon: Icon(Icons.folder),
                        ),
                        validator: (value) => value!.trim().isEmpty ? 'Category name is required' : null,
                      ),
                      const SizedBox(height: 30),

                      // 🔹 Save Button
                      ElevatedButton(
                        onPressed: _saving ? null : _saveCategory,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: _saving
                            ? const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: 18,
                                    height: 18,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Text("Saving..."),
                                ],
                              )
                            : const Text("Save"),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Extracted Reusable Widget for Image Picker
class _ImagePickerArea extends StatelessWidget {
  final String? currentImageUrl;
  final File? imageFile;
  final VoidCallback onPickImage;

  const _ImagePickerArea({
    this.currentImageUrl,
    this.imageFile,
    required this.onPickImage,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 50,
          backgroundColor: Colors.grey.shade200,
          backgroundImage: imageFile != null
              ? FileImage(imageFile!) as ImageProvider
              : (currentImageUrl != null && currentImageUrl!.isNotEmpty
                  ? NetworkImage(currentImageUrl!) as ImageProvider
                  : null),
          child: imageFile == null &&
                  (currentImageUrl == null || currentImageUrl!.isEmpty)
              ? const Icon(Icons.photo, size: 40, color: Colors.grey)
              : null,
        ),
        TextButton.icon(
          onPressed: onPickImage,
          icon: const Icon(Icons.photo_library),
          label: const Text('Select Image'),
        ),
      ],
    );
  }
}
