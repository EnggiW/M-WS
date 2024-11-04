import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = 'https://jsonplaceholder.typicode.com/posts';

  Future<List<dynamic>> fetchPosts() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      print('Fetch successful');
      return json.decode(response.body);
    } else {
      print('Failed to fetch posts');
      throw Exception('Failed to load posts');
    }
  }

  Future<bool> createPost(String title, String body) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        'title': title,
        'body': body,
        'userId': 1,
      }),
    );
    print('Create response: ${response.statusCode}');
    return response.statusCode == 201;
  }

  Future<bool> updatePost(int id, String title, String body) async {
    final response = await http.put(
      Uri.parse('$baseUrl/$id'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        'title': title,
        'body': body,
      }),
    );
    print('Update response: ${response.statusCode}');
    return response.statusCode == 200;
  }

  Future<bool> deletePost(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'));
    print('Delete response: ${response.statusCode}');
    return response.statusCode == 200;
  }
}
