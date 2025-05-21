import 'dart:developer';

import 'package:mpos/common/models/brand.model.dart';
import 'package:mpos/common/models/category.model.dart';
import 'package:mpos/common/models/product_unit.model.dart';
import 'package:mpos/common/models/stock.model.dart';
import 'package:mpos/core/config/model/session.model.dart';
import 'package:mpos/modules/product/model/product.model.dart';
import 'package:mpos/modules/user/model/user.model.dart';
import 'package:mpos/objectbox.g.dart';

late final Store store;
late final Box<User> userBox;
late final Box<Product> productBox;
late final Box<Session> sessionBox;
late final Box<Brand> brandBox;
late final Box<Category> categoryBox;
late final Box<Stock> stockBox;
late final Box<ProductUnit> productUnitBox;

late final User currentUser;

Future<void> initObjectBox() async {
  store = await openStore();
  userBox = store.box<User>();
  productBox = store.box<Product>();
  sessionBox = store.box<Session>();
  brandBox = store.box<Brand>();
  categoryBox = store.box<Category>();
  stockBox = store.box<Stock>();
  productUnitBox = store.box<ProductUnit>();

  // final dozenUnit = ProductUnit(
  //   name: "Dozen",
  //   shortName: "dz",
  //   baseUnit: "pc",
  //   conversionFactor: 10.0,
  // );
  // productUnitBox.put(dozenUnit);

  // Simulate login or default user
  // final users = userBox.getAll();
  // if (users.isEmpty) {
  //   currentUser = User(
  //     name: 'Admin',
  //     email: 'admin@admin.com',
  //     empId: '1',
  //     age: 1,
  //   );

  //   currentUser.id = userBox.put(currentUser);
  // } else {
  //   currentUser = users.first;
  // }
}
