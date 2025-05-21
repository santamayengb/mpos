import 'package:mpos/common/models/category.model.dart';
import 'package:mpos/common/models/product_unit.model.dart';
import 'package:mpos/core/config/objectbox.helper.dart';
import 'package:mpos/modules/product/model/product.model.dart';
import 'package:mpos/modules/user/pages/user.page.dart';
import 'package:mpos/objectbox.g.dart';

import 'package:mpos/services/user.service.dart'; // Import to access currentUser

class ProductService {
  static int createProduct(
    String name,
    double price,
    double retailPrice,
    String productCode,
    String barcode,
  ) {
    final product = Product(
      name: name,
      mrp: price,
      retailPrice: 0,
      productCode: '',
      barcode: '',
    );
    product.createdBy.target = UserService.currentUser;
    product.updatedBy.target = UserService.currentUser;
    product.updatedAt = DateTime.now();
    return productBox.put(product);
  }

  static void createDummyProducts({int count = 50}) {
    final categories = categoryBox.getAll();
    final brands = brandBox.getAll();

    for (int i = 0; i < count; i++) {
      final product = Product(
        name: faker.food.dish(),
        mrp: faker.randomGenerator.integer(1000, min: 50).toDouble(),
        retailPrice: faker.randomGenerator.integer(1000, min: 50).toDouble(),
        productCode: faker.randomGenerator.string(6).toUpperCase(),
        barcode: faker.randomGenerator.numbers(9, 13).join(),
      );

      // Randomly assign category and brand if available
      if (categories.isNotEmpty) {
        product.category.target =
            categories[faker.randomGenerator.integer(categories.length)];
      }
      if (brands.isNotEmpty) {
        product.brand.target =
            brands[faker.randomGenerator.integer(brands.length)];
      }

      product.createdBy.target = UserService.currentUser;
      product.updatedBy.target = UserService.currentUser;
      product.updatedAt = DateTime.now();

      productBox.put(product);
    }
  }

  static int createDummyProduct() {
    // Get a random category and brand (if available)
    final categories = categoryBox.getAll();
    final brands = brandBox.getAll();

    final category =
        categories.isNotEmpty
            ? categories[faker.randomGenerator.integer(categories.length)]
            : null;

    final brand =
        brands.isNotEmpty
            ? brands[faker.randomGenerator.integer(brands.length)]
            : null;

    final product = Product(
      name: faker.food.dish(),
      mrp: faker.randomGenerator.integer(9999).toDouble(),
      retailPrice: faker.randomGenerator.integer(9999).toDouble(),
      productCode: faker.randomGenerator.string(6).toUpperCase(),
      barcode: faker.randomGenerator.numbers(9, 13).join(),
    );

    product.createdBy.target = UserService.currentUser;
    product.updatedBy.target = UserService.currentUser;
    product.updatedAt = DateTime.now();

    // Set brand and category if available
    if (brand != null) product.brand.target = brand;
    if (category != null) product.category.target = category;

    return productBox.put(product);
  }

  static Product? getProduct(int id) {
    return productBox.get(id);
  }

  static List<Product> getAllProducts() {
    return productBox.getAll();
  }

  static bool updateProduct(
    int id, {
    String? name,
    double? mrp,
    Category? category, // Add this line
    ProductUnit? unit,
    double? conversionFactor, // Add this line
  }) {
    final product = productBox.get(id);
    if (product == null) return false;

    if (name != null) product.name = name;
    if (mrp != null) product.mrp = mrp;
    if (category != null) {
      product.category.target = category; // Set category relation
    }
    if (unit != null) {
      product.unit.target = unit; // Set unit relation
    }
    if (conversionFactor != null) {
      product.conversionFactor = conversionFactor; // Set conversion factor
    }

    product.updatedBy.target = UserService.currentUser;
    product.updatedAt = DateTime.now();
    productBox.put(product); // Save the updated product
    return true;
  }

  static bool deleteProduct(int id) {
    return productBox.remove(id);
  }

  static List<Product> getProductsByCategory(Category category) {
    final query =
        productBox.query(Product_.category.equals(category.id)).build();
    final products = query.find();
    query.close();
    return products;
  }
}
