import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ApiService {
  final String baseUrl;
  String endpoint = '/api.php';

  // 设置默认值
  ApiService({this.baseUrl = 'http://hisiphp.tangying.icu'});
  //ApiService({this.baseUrl = 'http://hisiphp.tangying.icu'});
  // 登录后即本地Hive存储中获取 token
  Future<String?> getToken() async {
    var userinfo = await Hive.openBox('userinfo');
    return userinfo.get('token');
  }

  //get请求
  Future<dynamic> getRequest(String address) async {
    try {
      final token = await getToken(); // 获取 token
      final url = Uri.parse('$baseUrl$endpoint$address');
      final response = await http.get(
        url,
        headers: {
          if (token != null) 'token': token, // 添加 Authorization 头
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error during GET request: $e');
    }
  }

  //psot请求
  Future<dynamic> postRequest(String address, Map<String, dynamic> data) async {
    try {
      final token = await getToken(); // 获取 token
      final url = Uri.parse('$baseUrl$endpoint$address');
      print("token");
      print(token);
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'token': token, // 添加 Authorization 头
        },
        body: jsonEncode(data),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to post data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error during POST request: $e');
    }
  }
}
