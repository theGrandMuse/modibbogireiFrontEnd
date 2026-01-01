import 'package:http/http.dart' as http;

class HttpService {
  //static const String _baseUrl = "http://127.0.0.1/emcube/api";
  //static const String _baseUrl = "http://localhost/emcube/api";
  static const String _baseUrl = "https://emcube.com.ng/portal/api";
  //const String _baseUrl = "http://127.0.0.1/emcube/api";

  static Future<http.Response> get(String endpoint) async {
   final response = await http.get(Uri.parse('$_baseUrl/$endpoint'),
        headers: {"Accept": "application/json"});
    return response;
  }

  static Future<http.Response> post(
      String endpoint, dynamic data) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/$endpoint'),
      body: data,
    );
    return response;
  }

  static Future<http.Response> put(String endpoint, dynamic data) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/$endpoint'),
      body: data,
    );
    return response;
  }

  static Future<http.Response> delete(String endpoint) async {
    final response = await http.delete(Uri.parse('$_baseUrl/$endpoint'));
    return response;
  }
}
