import 'package:barcode/barcode.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:mpos/common/services/stock.service.dart';
import 'package:mpos/common/widgets/barcode.widget.dart';
import 'package:mpos/common/widgets/progressbar.widget.dart';
import 'package:mpos/modules/product/model/product.model.dart';
import 'package:mpos/modules/product/widget/card.widget.dart';
import 'package:mpos/services/product.service.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({super.key});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
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
          child: Container(
            padding: EdgeInsets.all(20),
            // color: Colors.white,
            child: Theme(
              data: Theme.of(context).copyWith(
                cardTheme: CardTheme(
                  color: Colors.white,
                  elevation: 1, // remove shadow
                  margin: const EdgeInsets.all(0), // reset margin
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16), // Change radius
                  ),
                ),
              ),
              child: PaginatedDataTable2(
                // headingRowColor: WidgetStatePropertyAll(),
                header: InkWell(
                  onTap: () {
                    ProductService.createDummyProduct();
                    setState(() {});
                  },
                  child: Text("Products"),
                ),
                isHorizontalScrollBarVisible: true,
                isVerticalScrollBarVisible: true,
                columnSpacing: 4,

                minWidth: 800,
                columns: [
                  DataColumn2(label: Text('ID')),
                  DataColumn2(label: Text('Name')),
                  DataColumn2(label: Text('Product Code')),
                  DataColumn2(label: Text('Stock')),
                  DataColumn2(label: Text('Category')),
                  DataColumn2(label: Text('Brand')),
                  DataColumn2(label: Text('MRP')),
                  DataColumn2(label: Text('Retail Price')),
                  DataColumn2(label: Text('Barcode')),
                  DataColumn2(label: Text('Created By')),
                  DataColumn2(label: Text('Action')),

                  //
                ],
                source: MyDataTable(products),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class MyDataTable extends DataTableSource {
  final List<Product> products;

  MyDataTable(this.products);

  void removeProduct(int productId) {
    products.removeWhere((product) => product.id == productId);
    notifyListeners(); // Triggers rebuild
  }

  @override
  DataRow? getRow(int index) {
    return DataRow2(
      cells: [
        DataCell(Text("${products[index].id}")),
        DataCell(
          InkWell(
            onTap: () {
              StockService.updateStock(
                products[index],
                faker.randomGenerator.integer(100),
              );
              notifyListeners();
            },
            child: Text(products[index].name),
          ),
        ),
        DataCell(Text(products[index].productCode)),

        DataCell(
          StockProgressBar(
            maxQuantity:
                StockService.getStockForProduct(products[index])?.maxQuantity ??
                0,
            quantity:
                StockService.getStockForProduct(products[index])?.quantity ?? 0,
          ),
        ),
        DataCell(Text(products[index].category.target?.name ?? 'NA')),

        DataCell(Text(products[index].brand.target?.name ?? 'NA')),
        DataCell(Text("${products[index].mrp}")),
        DataCell(Text("${products[index].retailPrice}")),
        // DataCell(Text(products[index].barcode)),
        DataCell(BarcodeWidget(data: products[index].barcode)),
        DataCell(Text(products[index].createdBy.target!.name)),
        DataCell(
          Row(
            children: [
              IconButton(
                onPressed: () {
                  ProductService.deleteProduct(products[index].id);
                  removeProduct(products[index].id);
                },
                icon: Icon(Icons.delete_forever),
              ),
              IconButton(
                onPressed: () {
                  StockService.createStock(
                    product: products[index],
                    quantity: 154,
                  );
                  notifyListeners();
                },
                icon: Icon(Icons.edit_document),
              ),
            ],
          ),
        ),
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
