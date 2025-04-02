import 'package:flutter/foundation.dart';
import '../models/Cart.dart';
import '../models/Product.dart';

class CartProvider with ChangeNotifier {
  // Use a list that can grow dynamically with no size restrictions
  final List<Cart> _items = [];
  
  List<Cart> get items => [..._items];
  
  int get itemCount => _items.fold(0, (sum, item) => sum + item.numOfItem);
  
  double get totalAmount {
    double total = 0;
    for (var item in _items) {
      total += item.product.price * item.numOfItem;
    }
    return total;
  }

  bool isItemInCart(int productId) {
    return _items.any((item) => item.product.id == productId);
  }

  int getQuantity(int productId) {
    final existingCartItem = _items.firstWhere(
      (item) => item.product.id == productId,
      orElse: () => Cart(product: Product(
        id: -1,
        title: '',
        price: 0,
        description: '',
        images: const [],
        colors: const [],
        rating: 0,
        isFavourite: false,
        isPopular: false,
      ), numOfItem: 0),
    );
    return existingCartItem.product.id != -1 ? existingCartItem.numOfItem : 0;
  }

  void addItem(Product product, int quantity) {
    if (quantity <= 0) return;
    
    final existingIndex = _items.indexWhere((item) => item.product.id == product.id);
    if (existingIndex >= 0) {
      // Update existing item
      _items[existingIndex].numOfItem = quantity;
    } else {
      // Add new item with no restriction on the number of items
      _items.add(Cart(product: product, numOfItem: quantity));
    }
    notifyListeners();
  }

  void removeItem(int productId) {
    _items.removeWhere((item) => item.product.id == productId);
    notifyListeners();
  }

  void updateQuantity(int productId, int quantity) {
    if (quantity <= 0) {
      removeItem(productId);
      return;
    }
    
    final index = _items.indexWhere((item) => item.product.id == productId);
    if (index >= 0) {
      _items[index].numOfItem = quantity;
      notifyListeners();
    }
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }
}