import 'dart:convert';

import 'package:e_commerce/Auth/model/listproductdata.dart';
import 'package:e_commerce/Auth/model/productdata.dart';
import 'package:http/http.dart' as http;

class ProductService {
  ProductService._internal();
  static final ProductService _instance = ProductService._internal();
  factory ProductService() => _instance;

  final String baseUrl = 'http://10.0.2.2:8080';

  Future<List<Productdata>> getAllProduct() async {
    try {
      final url = Uri.parse('$baseUrl/products/all');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final ListProductData data = ListProductData.fromJson(response.body);
        return data.product;
      } else {
        throw Exception('Invalid to loading formart ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to loading product');
    }
  }

  Future<Productdata> createProduct(
    Productdata product,
    String adminEmail,
  ) async {
    final url = Uri.parse('$baseUrl/products/create?email=$adminEmail');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(product.toMap()),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return Productdata.fromMap(jsonDecode(response.body));
    } else {
      throw Exception(response.body);
    }
  }

  // Update
  Future<Productdata> updateProduct(
    int id,
    Productdata product,
    String adminEmail,
  ) async {
    final url = Uri.parse('$baseUrl/products/update/$id?email=$adminEmail');

    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(product.toJson()),
    );

    if (response.statusCode == 200) {
      return Productdata.fromMap(jsonDecode(response.body));
    } else {
      throw Exception(response.body);
    }
  }

  // DELETE PRODUCT
  Future<void> deleteProduct(int id, String adminEmail) async {
    final url = Uri.parse('$baseUrl/products/delete/$id?email=$adminEmail');

    final response = await http.delete(url);

    if (response.statusCode != 200) {
      throw Exception(response.body);
    }
  }
}
