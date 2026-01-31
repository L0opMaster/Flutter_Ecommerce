// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:e_commerce/Auth/model/productdata.dart';


class CartItems {
  final Productdata product;
  int quantity; 
  double get totalprice => product.price * quantity;
  CartItems({
    required this.product,
    required this.quantity,
  });

  CartItems copyWith({
    Productdata? product,
    int? quantity,
  }) {
    return CartItems(
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
    );
  }

  // double get totalprice{
  //   return product.price;
  // }
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'product': product.toMap(),
      'quantity': quantity,
    };
  }

  factory CartItems.fromMap(Map<String, dynamic> map) {
    return CartItems(
      product: Productdata.fromMap(map['product'] as Map<String,dynamic>),
      quantity: map['quantity'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory CartItems.fromJson(String source) => CartItems.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'CartItems(product: $product, quantity: $quantity)';

  @override
  bool operator ==(covariant CartItems other) {
    if (identical(this, other)) return true;
  
    return 
      other.product == product &&
      other.quantity == quantity;
  }

  @override
  int get hashCode => product.hashCode ^ quantity.hashCode;
}
