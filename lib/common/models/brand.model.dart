import 'package:mpos/modules/product/model/product.model.dart';
import 'package:mpos/modules/user/model/user.model.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
class Brand {
  int id;
  String name;
  String code;

  @Property(type: PropertyType.date)
  DateTime updatedAt;

  @Property(type: PropertyType.date)
  DateTime createdAt;

  final createdBy = ToOne<User>();
  final updatedBy = ToOne<User>();

  @Backlink('brand')
  final products = ToMany<Product>();

  Brand({
    this.id = 0,
    required this.name,
    required this.code,
    DateTime? updatedAt,
    DateTime? createdAt,
  }) : updatedAt = updatedAt ?? DateTime.now(),
       createdAt = createdAt ?? DateTime.now();
}
