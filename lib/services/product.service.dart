import 'package:mpos/core/config/objectbox_helper.dart';
import 'package:mpos/modules/product/model/product.model.dart';

class ProductService {
  static int createProduct(String title, double price) {
    final product = Product(title: title, price: price);
    product.createdBy.target = currentUser;
    product.updatedBy.target = currentUser;
    product.updatedAt = DateTime.now();
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

    if (title != null) product.title = title;
    if (price != null) product.price = price;

    product.updatedBy.target = currentUser;
    product.updatedAt = DateTime.now();
    productBox.put(product);
    return true;
  }

  static bool deleteProduct(int id) {
    return productBox.remove(id);
  }
}
