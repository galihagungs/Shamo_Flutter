import 'dart:convert';
import 'package:shamo/models/product_model.dart';
import 'package:http/http.dart' as http;

class ProductService {
  String baseUrl = 'http://10.0.2.2:8000/api';
  // String baseUrl = 'http://127.0.0.1:8000/api';
  // String baseUrl = 'http://192.168.1.7:8000/api';

  Future<List<ProductModel>> getProducts() async {
    var url = '$baseUrl/products';
    var headers = {
      'Content-Type': 'application/json',
      "Connection": "Keep-Alive",
      "Keep-Alive": "timeout=20, max=5"
    };

    var response = await http.get(Uri.parse(url), headers: headers);
    print(response.body);

    if (response.statusCode == 200) {
      List data = jsonDecode(response.body)['data']['data'];
      List<ProductModel> products = [];

      for (var item in data) {
        products.add(ProductModel.fromJson(item));
      }

      return products;
    } else {
      throw Exception('Gagal Get Products');
    }
  }
}
