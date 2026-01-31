// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:e_commerce/Product/model/product_data_model.dart';

class ListProductModel {
  final List<Product> products;

  ListProductModel({
    required this.products,
  });

  ListProductModel copyWith({
    List<Product>? products,
  }) {
    return ListProductModel(
      products: products ?? this.products,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'products': products.map((x) => x.toMap()).toList(),
    };
  }

  factory ListProductModel.fromMap(Map<String, dynamic> map) {
    return ListProductModel(
      products: List<Product>.from((map['products'] as List<int>).map<Product>((x) => Product.fromMap(x as Map<String,dynamic>),),),
    );
  }

  String toJson() => json.encode(toMap());

  factory ListProductModel.fromJson(String source) {
    try {
      final List<dynamic> jsonList = jsonDecode(source) as List<dynamic>;
      return ListProductModel(
        products: jsonList.map((json) => Product.fromMap(json)).toList()
      );
    } catch (e) {
      throw FormatException("invalid Json Fomrat: $e");
    }
  }
  @override
  String toString() => 'ListProductModel(products: $products)';

  @override
  bool operator ==(covariant ListProductModel other) {
    if (identical(this, other)) return true;
  
    return 
      listEquals(other.products, products);
  }

  @override
  int get hashCode => products.hashCode;
}
