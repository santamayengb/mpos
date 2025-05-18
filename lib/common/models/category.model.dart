import 'package:mpos/modules/product/model/product.model.dart';
import 'package:mpos/modules/user/model/user.model.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
class Category {
  int id;
  String name;

  final createdBy = ToOne<User>();
  final updatedBy = ToOne<User>();

  @Property(type: PropertyType.date)
  DateTime createdAt;

  @Property(type: PropertyType.date)
  DateTime updatedAt;

  @Backlink('category')
  final products = ToMany<Product>();

  Category({
    this.id = 0,
    required this.name,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();
}
