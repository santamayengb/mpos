import 'package:mpos/common/models/brand.model.dart';
import 'package:mpos/common/models/category.model.dart';
import 'package:mpos/common/models/product_unit.model.dart';
import 'package:mpos/modules/user/model/user.model.dart';
import 'package:objectbox/objectbox.dart';

// Assuming this exists

@Entity()
class Product {
  int id;
  String name;
  double mrp;
  double retailPrice;
  String productCode;
  String barcode;
  double? conversionFactor; // New field to store the conversion factor

  final createdBy = ToOne<User>();
  final updatedBy = ToOne<User>();
  final category = ToOne<Category>();
  final brand = ToOne<Brand>();
  final unit = ToOne<ProductUnit>(); // 👈 New relationship

  @Property(type: PropertyType.date)
  DateTime updatedAt;

  @Property(type: PropertyType.date)
  DateTime createdAt;

  // Link to category

  Product({
    this.id = 0,
    required this.name,
    required this.mrp,
    required this.retailPrice,
    required this.productCode,
    required this.barcode,
    this.conversionFactor,
    DateTime? updatedAt,
    DateTime? createdAt,
  }) : updatedAt = updatedAt ?? DateTime.now(),
       createdAt = createdAt ?? DateTime.now();
}
