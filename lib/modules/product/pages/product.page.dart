import 'package:data_table_2/data_table_2.dart';
import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:mpos/modules/product/model/product.model.dart';
import 'package:mpos/modules/product/widget/card.widget.dart';
import 'package:mpos/services/product.service.dart';

class ProductPage extends StatelessWidget {
  const ProductPage({super.key});

  @override
  Widget build(BuildContext context) {
    var mq = MediaQuery.of(context).size;
    var style = Theme.of(context).textTheme;
    var products = ProductService.getAllProducts();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppBar(
          title: Text("Products"),
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(child: Text("A")),
            ),
          ],
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 20),
          child: Card(
            child: Container(
              padding: EdgeInsets.all(20),
              color: Colors.white,
              width: mq.width,
              height: 120,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                // crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CardWidget(style: style),
                  VerticalDivider(color: Colors.grey, thickness: 1),
                  CardWidget(style: style),
                  VerticalDivider(color: Colors.grey, thickness: 1),
                  CardWidget(style: style),
                  VerticalDivider(color: Colors.grey, thickness: 1),
                  CardWidget(style: style),
                ],
              ),
            ),
          ),
        ),
        Expanded(
          child: PaginatedDataTable2(
            isHorizontalScrollBarVisible: true,
            isVerticalScrollBarVisible: true,
            columnSpacing: 4,

            minWidth: 800,
            columns: [
              DataColumn2(label: Text('ID')),
              DataColumn2(label: Text('Name')),
              DataColumn2(label: Text('Email')),
              DataColumn2(label: Text('IP')),
              //
              DataColumn2(label: Text('Status')),
              DataColumn2(label: Text('Emp ID')),
              DataColumn2(label: Text('Last Sync')),
              DataColumn2(label: Text('Action')),
            ],
            source: MyDataTable(products),
          ),
        ),
      ],
    );
  }
}

class MyDataTable extends DataTableSource {
  final List<Product> products;

  MyDataTable(this.products);

  void removeUser(int userId) {
    products.removeWhere((user) => user.id == userId);
    notifyListeners(); // Triggers rebuild
  }

  @override
  DataRow? getRow(int index) {
    return DataRow2(
      cells: [
        DataCell(Text("${products[index].id}")),

        DataCell(Text(products[index].title)),
        DataCell(Text("${products[index].id}")),

        DataCell(Text(products[index].title)),
        DataCell(Text("${products[index].id}")),

        DataCell(Text(products[index].title)),
        DataCell(Text("${products[index].id}")),

        DataCell(Text(products[index].title)),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => products.length;

  @override
  int get selectedRowCount => 0;
}
