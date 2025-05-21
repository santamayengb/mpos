import 'package:flutter/material.dart';
import 'package:mpos/common/services/category.service.dart';
import 'package:mpos/common/services/product_unit.service.dart';

class CategorySelectionDialog extends StatelessWidget {
  const CategorySelectionDialog({super.key});

  @override
  Widget build(BuildContext context) {
    // Replace with your actual category list
    final categories =
        CategoryService.getAllCategories(); // Assume it returns a List<Category>

    return AlertDialog(
      title: InkWell(
        onTap: () {
          CategoryService.createCategory("Electronic");
        },
        child: Text('Select Category ${categories.length}'),
      ),
      content: SizedBox(
        height: 300,
        width: 300,
        child: ListView.builder(
          itemCount: categories.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(categories[index].name),
              onTap: () {
                Navigator.of(context).pop(categories[index]);
              },
            );
          },
        ),
      ),
    );
  }
}

class UnitSelectionDialog extends StatelessWidget {
  const UnitSelectionDialog({super.key});

  @override
  Widget build(BuildContext context) {
    // Replace with your actual category list
    final units =
        ProductUnitService.getAllUnits(); // Assume it returns a List<Category>

    return AlertDialog(
      title: Text('Select Unit ${units.length}'),
      content: SizedBox(
        height: 300,
        width: 300,
        child: ListView.builder(
          itemCount: units.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(units[index].name),
              onTap: () {
                Navigator.of(context).pop(units[index]);
              },
            );
          },
        ),
      ),
    );
  }
}
