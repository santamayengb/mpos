import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:mpos/common/services/category.service.dart';
import 'package:mpos/common/services/product_unit.service.dart';

class InventoryPage extends StatefulWidget {
  const InventoryPage({super.key});

  @override
  State<InventoryPage> createState() => _InventoryPageState();
}

class _InventoryPageState extends State<InventoryPage> {
  @override
  Widget build(BuildContext context) {
    var list = CategoryService.getAllCategories();
    var u = ProductUnitService.getAllUnits();
    log("$u");

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppBar(
          title: InkWell(
            onTap: () {
              ProductUnitService.addDefaultUnits();
            },
            child: Text("Inventory ${u.first}"),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(child: Text("A")),
            ),
          ],
        ),
        ListView.builder(
          shrinkWrap: true,
          itemCount: list.length,
          itemBuilder: (context, index) {
            var category = list[index];
            return ListTile(
              onTap: () {
                CategoryService.deleteCategory(category.id);
                setState(() {});
              },
              title: Text(category.name),
            );
          },
        ),
      ],
    );
  }
}
