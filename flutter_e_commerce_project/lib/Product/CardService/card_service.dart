import 'package:e_commerce/Auth/model/productdata.dart';
import 'package:e_commerce/Product/model/cart_items.dart';
import 'package:flutter/material.dart';

class CartService {
  CartService._internal();
  static final CartService _instance = CartService._internal();
  factory CartService() {
    return _instance;
  }

  final ValueNotifier<List<CartItems>> cartNotifier = ValueNotifier([]);

  final ValueNotifier<int> notifier = ValueNotifier(0);

  void addProduct(Productdata product) {
    addProductWithQuanity(product, 1);
  }

  void addProductWithQuanity(Productdata product, int quantityToAdd) {
    if (quantityToAdd <= 0) {
      return;
    }
    final List<CartItems> currentCart = List.from(cartNotifier.value);
    final index =
        currentCart.indexWhere((item) => item.product.id == product.id);

    if (index != -1) {
      int newQuantity = currentCart[index].quantity + quantityToAdd;
      currentCart[index].quantity =
          (newQuantity > product.stock) ? product.stock : newQuantity;
    } else {
      if (product.stock > quantityToAdd) {
        currentCart.add(CartItems(product: product, quantity: quantityToAdd));
      }
    }
    cartNotifier.value = currentCart;
    notifier.value += 1;
  }

  void removeProduct(int productid) {
    final List<CartItems> currentCart = List.from(cartNotifier.value);
    currentCart.removeWhere((item) => item.product.id == productid);
    cartNotifier.value == currentCart;
  }

  void updateQuantity(int productid, int quantity) {
    final List<CartItems> currentCart = List.from(cartNotifier.value);
    int index = currentCart.indexWhere((item) => item.product.id == productid);
    if (index != -1) {
      if (quantity > 0 && quantity <= currentCart[index].product.stock) {
        currentCart[index].quantity = quantity;
      } else if (quantity == 0) {
        currentCart.removeAt(index);
      }
      cartNotifier.value = currentCart;
    }
  }

  void clearCart() {
    cartNotifier.value = [];
  }

  void clearbadge() {
    notifier.value = 0;
  }

  double get totalCost {
    return cartNotifier.value.fold(0, (sum, item) => sum + item.totalprice);
  }
}
