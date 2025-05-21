import 'package:mpos/modules/product/model/product.model.dart';
import 'package:mpos/modules/user/model/user.model.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
class ProductUnit {
  int id;

  String name; // e.g., "Dozen", "Piece", "Bag"
  String shortName; // e.g., "dz", "pc", "bag"

  final createdBy = ToOne<User>();
  final updatedBy = ToOne<User>();

  @Property(type: PropertyType.date)
  DateTime createdAt;

  @Property(type: PropertyType.date)
  DateTime updatedAt;

  @Backlink('unit')
  final products = ToMany<Product>(); // Backlink to products using this unit

  // New fields for conversion
  String? baseUnit; // e.g., "pc" for pieces
  double? conversionFactor; // e.g., 10 for 1 dz = 10 pc

  ProductUnit({
    this.id = 0,
    required this.name,
    required this.shortName,
    DateTime? createdAt,
    DateTime? updatedAt,
    this.baseUnit,
    this.conversionFactor,
  }) : createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();
}
