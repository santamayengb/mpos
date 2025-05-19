import 'package:mpos/modules/product/model/product.model.dart';
import 'package:mpos/modules/user/model/user.model.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
class ProductUnit {
  int id;

  String name; // e.g., "Kilogram", "Piece"
  String shortName; // e.g., "kg", "pcs"

  final createdBy = ToOne<User>();
  final updatedBy = ToOne<User>();

  @Property(type: PropertyType.date)
  DateTime createdAt;

  @Property(type: PropertyType.date)
  DateTime updatedAt;

  @Backlink('unit')
  final products = ToMany<Product>(); // 👈 backlink to products using this unit

  ProductUnit({
    this.id = 0,
    required this.name,
    required this.shortName,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();
}
