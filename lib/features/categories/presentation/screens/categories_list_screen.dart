import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../auth/data/datasources/auth_service.dart';
import '../../data/datasources/category_datasource.dart';
import '../../domain/entities/category.dart';
import 'category_form_screen.dart';

class CategoriesListScreen extends StatefulWidget {
  const CategoriesListScreen({super.key});

  @override
  State<CategoriesListScreen> createState() => _CategoriesListScreenState();
}

class _CategoriesListScreenState extends State<CategoriesListScreen> {
  String searchQuery = "";
  String filter = "none";
  int itemsToShow = 10; // pagination count

  String _filterLabel(String filter) {
    switch (filter) {
      case "asc":
        return "Sorted by: Ascending (A–Z)";
      case "desc":
        return "Sorted by: Descending (Z–A)";
      default:
        return "";
    }
  }

  List<Category> _sortAndFilterCategories(List<Category> categories) {
    List<Category> filteredList = categories
        .where((cat) =>
            cat.name.toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();

    switch (filter) {
      case "asc":
        filteredList.sort((a, b) => a.name.compareTo(b.name));
        break;
      case "desc":
        filteredList.sort((a, b) => b.name.compareTo(a.name));
        break;
    }
    return filteredList;
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthService>(context, listen: false);
    final categoryFirestore = Provider.of<CategoryDataSource>(context, listen: false);
    final user = auth.currentUser!;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Categories"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_box_outlined),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const CategoryFormScreen()),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // 🔹 Search and Filter Bar
          _SearchFilterBar(
            searchQuery: searchQuery,
            filterLabel: _filterLabel(filter),
            onSearchChanged: (value) {
              setState(() {
                searchQuery = value;
                itemsToShow = 10; // Reset pagination on search
              });
            },
            onFilterSelected: (newFilter) {
              setState(() {
                filter = newFilter;
              });
            },
          ),

          // 🔹 Category List Stream
          Expanded(
            child: StreamBuilder<List<Category>>(
              stream: categoryFirestore.streamCategories(user.uid),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                final allCategories = snapshot.data ?? [];
                if (allCategories.isEmpty) {
                  return const Center(child: Text("No categories found. Add one now!"));
                }

                final filteredCategories = _sortAndFilterCategories(allCategories);
                final categoriesToShow = filteredCategories.take(itemsToShow).toList();

                return Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: categoriesToShow.length,
                        itemBuilder: (context, index) {
                          final cat = categoriesToShow[index];
                          return _CategoryListTile(
                            category: cat,
                            onEdit: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => CategoryFormScreen(category: cat)),
                            ),
                            onDelete: () => _confirmDelete(context, categoryFirestore, cat),
                          );
                        },
                      ),
                    ),
                    if (itemsToShow < filteredCategories.length)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              itemsToShow += 10;
                            });
                          },
                          child: const Text("Load More"),
                        ),
                      ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmDelete(
      BuildContext context, CategoryDataSource categoryFirestore, Category cat) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text("Delete Category: ${cat.name}"),
        content: const Text(
            "Are you sure you want to delete this category? This action cannot be undone."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
    if (confirm == true) {
      await categoryFirestore.deleteCategory(cat.id);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Category deleted successfully")),
        );
      }
    }
  }
}

// Extracted Widget for Search and Filter
class _SearchFilterBar extends StatelessWidget {
  final String searchQuery;
  final String filterLabel;
  final ValueChanged<String> onSearchChanged;
  final ValueChanged<String> onFilterSelected;

  const _SearchFilterBar({
    required this.searchQuery,
    required this.filterLabel,
    required this.onSearchChanged,
    required this.onFilterSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            onChanged: onSearchChanged,
            decoration: InputDecoration(
              hintText: "Search categories...",
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.grey.shade200,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                filterLabel.isNotEmpty ? filterLabel : "No sorting applied",
                style: const TextStyle(color: Colors.grey),
              ),
              PopupMenuButton<String>(
                onSelected: onFilterSelected,
                itemBuilder: (context) => [
                  const PopupMenuItem(value: "none", child: Text("None")),
                  const PopupMenuItem(value: "asc", child: Text("Name: A-Z")),
                  const PopupMenuItem(value: "desc", child: Text("Name: Z-A")),
                ],
                icon: const Icon(Icons.sort),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Extracted Widget for Category List Tile
class _CategoryListTile extends StatelessWidget {
  final Category category;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _CategoryListTile({
    required this.category,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      elevation: 2,
      child: ListTile(
        leading: category.imageUrl.isNotEmpty
            ? CircleAvatar(
                backgroundImage: NetworkImage(category.imageUrl),
              )
            : const CircleAvatar(child: Icon(Icons.folder_open)),
        title: Text(
          category.name,
          style: GoogleFonts.lora(fontWeight: FontWeight.bold),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.blue),
              onPressed: onEdit,
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}
