import 'dart:convert';
import 'package:shamo/models/user_model.dart';
import 'package:http/http.dart' as http;

class AuthService {
  String baseUrl = 'http://10.0.2.2:8000/api';
  // String baseUrl = 'http://192.168.1.7:8000/api';
  // String baseUrl = 'http://127.0.0.1:8000/api';

  Future<UserModel> register({
    required String name,
    required String username,
    required String email,
    required String password,
  }) async {
    var url = '$baseUrl/register';
    var headers = {'Content-Type': 'application/json'};
    var body = jsonEncode({
      'name': name,
      'username': username,
      'email': email,
      'password': password,
    });

    var response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: body,
    );

    print(body);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body)['data'];
      // print(data['user']);
      print(data['access_token']);
      UserModel user = UserModel.fromJson(data['user']);
      user.token = 'Bearer ' + data['access_token'];
      return user;
    } else {
      throw Exception('Gagal Register');
    }
    // return throw Exception('Gagal Register');
  }

  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    var url = '$baseUrl/login';
    // var url = '$baseUrl/products';
    var headers = {'Content-Type': 'application/json'};
    var body = jsonEncode({
      'email': email,
      'password': password,
    });

    var response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: body,
    );
    // var response = await http.get(Uri.parse(url));

    // print(body);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      print(data);
      // print(data['data']['user']);
      // print(data['data']['access_token']);
      UserModel user = UserModel.fromJson(data['data']['user']);
      user.token = 'Bearer ${data['data']['access_token']}';
      return user;
    } else {
      throw Exception('Gagal Login' + response.statusCode.toString());
      // throw Exception('Gagal Login' + url + response.statusCode.toString());
    }
  }
}
