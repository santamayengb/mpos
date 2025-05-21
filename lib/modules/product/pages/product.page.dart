import 'package:data_table_2/data_table_2.dart';
import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:mpos/common/models/brand.model.dart';
import 'package:mpos/common/models/category.model.dart';
import 'package:mpos/common/models/product_unit.model.dart';
import 'package:mpos/common/popup/category.popup.dart';
import 'package:mpos/common/services/brand.service.dart';
import 'package:mpos/common/services/category.service.dart';
import 'package:mpos/common/services/product_unit.service.dart';
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
  late List<Product> products;
  late List<Category> categories;
  late List<ProductUnit> unit;
  late List<Brand> brands;
  @override
  void initState() {
    products = ProductService.getAllProducts();
    categories = CategoryService.getAllCategories();
    brands = BrandService.getAllBrands();
    unit = ProductUnitService.getAllUnits();
    super.initState();
  }

  Category? selectedCategory;
  Brand? selectedBrand;
  @override
  Widget build(BuildContext context) {
    var mq = MediaQuery.of(context).size;
    var style = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppBar(
          title: InkWell(
            onTap: () {
              ProductService.createDummyProducts(count: 50);
              setState(() {});
            },
            child: Text("Products"),
          ),
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
                header: Row(
                  spacing: 10,
                  children: [
                    Text("Products"),
                    SizedBox(
                      width: 200,
                      child: DropdownButtonFormField<Category>(
                        isDense: true,
                        decoration: InputDecoration(
                          labelText: 'Select Category',
                          border:
                              OutlineInputBorder(), // optional for outlined style
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                        ),
                        value: selectedCategory,
                        hint: Text("Select Category"),
                        items: [
                          DropdownMenuItem<Category>(
                            value:
                                null, // or a special Category instance if needed
                            child: Text("All"),
                          ),
                          ...categories.map((e) {
                            return DropdownMenuItem<Category>(
                              value: e,
                              child: Text(e.name),
                            );
                          }),
                        ],
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              selectedCategory = value;
                            });
                            products = ProductService.getProductsByCategory(
                              value,
                            );
                          } else {
                            selectedCategory = null;
                            products = ProductService.getAllProducts();
                            setState(() {});
                          }
                        },
                      ),
                    ),
                    SizedBox(
                      width: 200,
                      child: DropdownButtonFormField<Brand>(
                        isDense: true,
                        decoration: InputDecoration(
                          labelText: 'Select Brand',
                          border:
                              OutlineInputBorder(), // optional for outlined style
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                        ),
                        value: selectedBrand,
                        hint: Text("Select Brand"),
                        items: [
                          DropdownMenuItem<Brand>(
                            value:
                                null, // or a special Category instance if needed
                            child: Text("All"),
                          ),
                          ...brands.map((e) {
                            return DropdownMenuItem<Brand>(
                              value: e,
                              child: Text(e.name),
                            );
                          }),
                        ],
                        onChanged: (value) {
                          // if (value != null) {
                          //   setState(() {
                          //     selectedBrand = value;
                          //   });
                          //   products = ProductService.getProductsByCategory(
                          //     value,
                          //   );
                          // } else {
                          //   selectedCategory = null;
                          //   products = ProductService.getAllProducts();
                          //   setState(() {});
                          // }
                        },
                      ),
                    ),
                  ],
                ),
                isHorizontalScrollBarVisible: true,
                isVerticalScrollBarVisible: true,
                columnSpacing: 4,

                minWidth: 800,
                columns: [
                  DataColumn2(label: Text('ID')),
                  DataColumn2(label: Text('Name')),
                  DataColumn2(label: Text('Product Code')),
                  DataColumn2(label: Text('Unit')),
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
                source: MyDataTable(products, brands, context),
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
  final List<Brand> brands;
  final BuildContext context;

  MyDataTable(this.products, this.brands, this.context);

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
          InkWell(
            onTap: () async {
              final selectedUnit = await showDialog<ProductUnit>(
                builder: (context) => UnitSelectionDialog(),
                context: context,
              );
              if (selectedUnit != null) {
                ProductService.updateProduct(
                  products[index].id,
                  unit: selectedUnit,
                );
                products[index].unit.target = selectedUnit;
                notifyListeners();
              }
            },
            child: Text(products[index].unit.target?.shortName ?? ' - '),
          ),
        ),

        DataCell(
          StockProgressBar(
            maxQuantity:
                StockService.getStockForProduct(products[index])?.maxQuantity ??
                0,
            quantity:
                StockService.getStockForProduct(products[index])?.quantity ?? 0,
          ),
        ),

        // DataCell(
        //   Builder(
        //     builder:
        //         (cellContext) => InkWell(
        //           onTap: () async {
        //             final renderBox =
        //                 cellContext.findRenderObject() as RenderBox;
        //             final position = renderBox.localToGlobal(Offset.zero);

        //             showContextMenu(
        //               cellContext,

        //               contextMenu: ContextMenu(
        //                 position: position,
        //                 entries: [MenuItem(label: "Edit Category")],
        //               ),
        //             );
        //           },
        //           child: Text(
        //             products[index].category.target?.name ?? 'Uncategorised',
        //           ),
        //         ),
        //   ),
        // ),
        DataCell(
          InkWell(
            onTap: () async {
              final selectedCategory = await showDialog<Category>(
                builder: (context) => CategorySelectionDialog(),
                context: context,
              );

              if (selectedCategory != null) {
                ProductService.updateProduct(
                  products[index].id,
                  category: selectedCategory,
                );
                products[index].category.target =
                    selectedCategory; // Update in list
                notifyListeners();
              }
            },
            child: Text(
              products[index].category.target?.name ?? 'Uncategorised',
            ),
          ),
        ),
        DataCell(
          InkWell(
            onTap: () async {
              // final selectedCategory = await showDialog<Brand>(
              //   builder: (context) => CategorySelectionDialog(),
              //   context: context,
              // );

              // if (selectedCategory != null) {
              //   ProductService.updateProduct(
              //     products[index].id,
              //     category: selectedCategory,
              //   );
              //   products[index].category.target =
              //       selectedCategory; // Update in list
              //   notifyListeners();
              // }
            },
            child: Text(products[index].brand.target?.name ?? 'Unbrand'),
          ),
        ),
        // DataCell(Text(products[index].brand.target?.name ?? 'Unbrand')),
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
