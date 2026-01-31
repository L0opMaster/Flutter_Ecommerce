// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:io';

import 'package:e_commerce/Auth/model/productdata.dart';
import 'package:flutter/foundation.dart';

class ListProductData {
  final List<Productdata> product;
  ListProductData({
    required this.product,
  });

  ListProductData copyWith({
    List<Productdata>? product,
  }) {
    return ListProductData(
      product: product ?? this.product,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'product': product.map((x) => x.toMap()).toList(),
    };
  }

  factory ListProductData.fromMap(Map<String, dynamic> map) {
    return ListProductData(
      product: List<Productdata>.from(
        (map['product'] as List<int>).map<Productdata>(
          (x) => Productdata.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory ListProductData.fromJson(String source) {
    try {
      final List<dynamic> jsonList = jsonDecode(source) as List<dynamic>;
      return ListProductData(
          product: jsonList.map((json) => Productdata.fromMap(json)).toList());
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  String toString() => 'ListProductData(product: $product)';

  @override
  bool operator ==(covariant ListProductData other) {
    if (identical(this, other)) return true;

    return listEquals(other.product, product);
  }

  @override
  int get hashCode => product.hashCode;
}
