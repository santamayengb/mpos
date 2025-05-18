import 'package:mpos/modules/product/model/product.model.dart';
import 'package:mpos/modules/user/model/user.model.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
class Stock {
  int id;

  int _quantity;
  int maxQuantity;

  bool inStock;

  final product = ToOne<Product>();
  final createdBy = ToOne<User>();
  final updatedBy = ToOne<User>();

  @Property(type: PropertyType.date)
  DateTime createdAt;

  @Property(type: PropertyType.date)
  DateTime updatedAt;

  Stock({
    this.id = 0,
    required int quantity,
    this.maxQuantity = 100, // ✅ Default value added
    bool? inStock,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : _quantity = quantity,
       inStock = inStock ?? (quantity > 0),
       createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  // Getter for quantity
  int get quantity => _quantity;

  // Setter for quantity: auto update inStock
  set quantity(int value) {
    _quantity = value;
    inStock = _quantity > 0;
  }

  // Progress value between 0 and 1 for use in a progress bar
  double get progress => maxQuantity > 0 ? _quantity / maxQuantity : 0;
}
