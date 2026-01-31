import 'package:e_commerce/Product/model/list_product_model.dart';
import 'package:e_commerce/Product/model/product_data_model.dart';
import 'package:http/http.dart' as http;

class ApiService {
  ApiService._internal();
  static final ApiService _instance = ApiService._internal();
  factory ApiService() {
    return _instance;
  }
  final String baseUrl = 'http://10.0.2.2:8080';
  Future<List<Product>> getProducts() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/products/all'));
      if (response.statusCode == 200) {
        final ListProductModel data = ListProductModel.fromJson(response.body);
        return data.products;
      } else {
        throw Exception('Invalid to loading formart ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to loading product');
    }
  }
}
