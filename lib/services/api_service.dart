import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product.dart';

class ApiService {
  static Future<List<Product>> fetchProducts() async {
    final response = await http.get(Uri.parse('http://127.0.0.1:8000/api/products/'));

    if (response.statusCode == 200) {
      final dynamic jsonBody = jsonDecode(response.body);

      if (jsonBody is String) {
        final List<dynamic> jsonData = jsonDecode(jsonBody);
        print('Fetched data: $jsonData');
        return jsonData.map((item) => Product.fromJson(item)).toList();
      }

      if (jsonBody is List) {
        print('Fetched data: $jsonBody');
        return jsonBody.map((item) => Product.fromJson(item)).toList();
      }

      throw Exception('Unexpected JSON format.');
    } else {
      throw Exception('Failed to load products: ${response.statusCode}');
    }
  }

}
