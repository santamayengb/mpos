import 'package:mpos/modules/user/model/user.model.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
class Product {
  int id;
  String title;
  double price;

  // Creator
  final createdBy = ToOne<User>();

  // Last updated by
  final updatedBy = ToOne<User>();

  // Timestamp for last update
  @Property(type: PropertyType.date)
  DateTime updatedAt;

  Product({
    this.id = 0,
    required this.title,
    required this.price,
    DateTime? updatedAt,
  }) : updatedAt = updatedAt ?? DateTime.now();
}
