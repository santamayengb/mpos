import 'package:mpos/common/models/stock.model.dart';
import 'package:mpos/core/config/objectbox.helper.dart';
import 'package:mpos/modules/product/model/product.model.dart';
import 'package:mpos/objectbox.g.dart';
import 'package:mpos/services/user.service.dart';

class StockService {
  static int createStock({required Product product, required int quantity}) {
    final stock = Stock(quantity: quantity, maxQuantity: quantity);
    stock.product.target = product;
    stock.createdBy.target = UserService.currentUser;
    stock.updatedBy.target = UserService.currentUser;
    stock.createdAt = DateTime.now();
    stock.updatedAt = DateTime.now();
    return stockBox.put(stock);
  }

  static List<Stock> getAll() => stockBox.getAll();

  static Stock? getStockForProduct(Product product) {
    final query = stockBox.query(Stock_.product.equals(product.id)).build();
    final result = query.findFirst();
    query.close();
    return result;
  }

  static bool updateStock(Product product, int quantity) {
    final stock = getStockForProduct(product);
    if (stock == null) return false;
    stock.quantity = quantity;
    stock.updatedBy.target = UserService.currentUser;
    stock.updatedAt = DateTime.now();
    stockBox.put(stock);
    return true;
  }

  static void toggleStockStatus(Stock stock) {
    stock.inStock = !stock.inStock;
    stockBox.put(stock);
  }
}
