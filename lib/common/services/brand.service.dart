import 'package:mpos/common/models/brand.model.dart';
import 'package:mpos/core/config/objectbox.helper.dart';
import 'package:mpos/modules/user/pages/user.page.dart';

class BrandService {
  /// Create a new brand
  static int createBrand(String name, String code) {
    final brand = Brand(
      name: name,
      code: code,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    brand.createdBy.target = currentUser;
    brand.updatedBy.target = currentUser;
    return brandBox.put(brand);
  }

  static int createDummyBrand() {
    final brand = Brand(
      name: faker.company.name(),
      code: faker.randomGenerator.string(4).toUpperCase(),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    brand.createdBy.target = currentUser;
    brand.updatedBy.target = currentUser;
    return brandBox.put(brand);
  }

  /// Get a brand by ID
  static Brand? getBrand(int id) {
    return brandBox.get(id);
  }

  /// Get all brands
  static List<Brand> getAllBrands() {
    return brandBox.getAll();
  }

  /// Update an existing brand
  static bool updateBrand(int id, {String? name, String? code}) {
    final brand = brandBox.get(id);
    if (brand == null) return false;

    if (name != null) brand.name = name;
    if (code != null) brand.code = code;
    brand.updatedBy.target = currentUser;
    brand.updatedAt = DateTime.now();

    brandBox.put(brand);
    return true;
  }

  /// Delete a brand by ID
  static bool deleteBrand(int id) {
    return brandBox.remove(id);
  }
}
