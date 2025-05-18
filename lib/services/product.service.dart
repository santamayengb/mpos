import 'package:mpos/core/config/objectbox.helper.dart';
import 'package:mpos/modules/product/model/product.model.dart';
import 'package:mpos/modules/user/pages/user.page.dart';

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

  static bool updateProduct(int id, {String? title, double? price}) {
    final product = productBox.get(id);
    if (product == null) return false;

    if (title != null) product.name = title;
    if (price != null) product.mrp = price;

    product.updatedBy.target = UserService.currentUser;
    product.updatedAt = DateTime.now();
    productBox.put(product);
    return true;
  }

  static bool deleteProduct(int id) {
    return productBox.remove(id);
  }
}
