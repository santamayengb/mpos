import 'package:mpos/common/models/category.model.dart';
import 'package:mpos/core/config/objectbox.helper.dart';
import 'package:mpos/services/user.service.dart';

class CategoryService {
  /// Create a new category
  static int createCategory(String name) {
    final category = Category(
      name: name,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    category.createdBy.target = UserService.currentUser;
    category.updatedBy.target = UserService.currentUser;
    return categoryBox.put(category);
  }

  /// Get a category by ID
  static Category? getCategory(int id) {
    return categoryBox.get(id);
  }

  /// Get all categories
  static List<Category> getAllCategories() {
    return categoryBox.getAll();
  }

  /// Update an existing category
  static bool updateCategory(int id, {String? name}) {
    final category = categoryBox.get(id);
    if (category == null) return false;

    if (name != null) category.name = name;
    category.updatedBy.target = currentUser;
    category.updatedAt = DateTime.now();

    categoryBox.put(category);
    return true;
  }

  /// Delete a category by ID
  static bool deleteCategory(int id) {
    return categoryBox.remove(id);
  }

  /// Delete all categories
  static void clearAllCategories() {
    categoryBox.removeAll();
  }
}
