import 'package:mpos/common/models/product_unit.model.dart';
import 'package:mpos/services/user.service.dart';
import 'package:mpos/core/config/objectbox.helper.dart';

class ProductUnitService {
  /// Create a new product unit
  static int createUnit(String name, String shortName) {
    final unit = ProductUnit(name: name, shortName: shortName);

    unit.createdBy.target = UserService.currentUser;
    unit.updatedBy.target = UserService.currentUser;
    unit.updatedAt = DateTime.now();

    return productUnitBox.put(unit);
  }

  /// Update an existing product unit
  static bool updateUnit(int id, {String? name, String? shortName}) {
    final unit = productUnitBox.get(id);
    if (unit == null) return false;

    if (name != null) unit.name = name;
    if (shortName != null) unit.shortName = shortName;

    unit.updatedBy.target = UserService.currentUser;
    unit.updatedAt = DateTime.now();

    productUnitBox.put(unit);
    return true;
  }

  /// Delete a unit
  static bool deleteUnit(int id) {
    return productUnitBox.remove(id);
  }

  /// Get unit by ID
  static ProductUnit? getUnit(int id) {
    return productUnitBox.get(id);
  }

  /// Get all units
  static List<ProductUnit> getAllUnits() {
    return productUnitBox.getAll();
  }

  /// Get all products for a unit (uses backlink)
  static List productsForUnit(int unitId) {
    final unit = productUnitBox.get(unitId);
    return unit?.products ?? [];
  }

  /// Add all default units
  static void addDefaultUnits() {
    final defaultUnits = [
      ProductUnit(name: 'Piece', shortName: 'pcs'),
      ProductUnit(name: 'Set', shortName: 'set'),
      ProductUnit(name: 'Pair', shortName: 'pair'),
      ProductUnit(name: 'Box', shortName: 'box'),
      ProductUnit(name: 'Packet', shortName: 'pkt'),
      ProductUnit(name: 'Pack', shortName: 'pack'),
      ProductUnit(name: 'Roll', shortName: 'roll'),
      ProductUnit(name: 'Gram', shortName: 'gm'),
      ProductUnit(name: 'Kilogram', shortName: 'kg'),
      ProductUnit(name: 'Milligram', shortName: 'mg'),
      ProductUnit(name: 'Liter', shortName: 'L'),
      ProductUnit(name: 'Milliliter', shortName: 'mL'),
      ProductUnit(name: 'Meter', shortName: 'm'),
      ProductUnit(name: 'Centimeter', shortName: 'cm'),
      ProductUnit(name: 'Foot', shortName: 'ft'),
      ProductUnit(name: 'Inch', shortName: 'in'),
      ProductUnit(name: 'Bottle', shortName: 'btl'),
      ProductUnit(name: 'Can', shortName: 'can'),
      ProductUnit(name: 'Jar', shortName: 'jar'),
      ProductUnit(name: 'Tube', shortName: 'tube'),
      ProductUnit(name: 'Tin', shortName: 'tin'),
      ProductUnit(name: 'Sachet', shortName: 'sachet'),
      ProductUnit(name: 'Bar', shortName: 'bar'),
      ProductUnit(name: 'Dozen', shortName: 'dozen'),
      ProductUnit(name: 'Tray', shortName: 'tray'),
      ProductUnit(name: 'Bundle', shortName: 'bndl'),
      ProductUnit(name: 'Carton', shortName: 'ctn'),
      ProductUnit(name: 'Unit', shortName: 'unit'),
    ];

    for (var unit in defaultUnits) {
      productUnitBox.put(unit);
    }
  }
}
