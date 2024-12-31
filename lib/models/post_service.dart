import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:todo/models/post_model.dart';

class PostService {
  static const String baseUrl = 'https://jsonplaceholder.typicode.com/posts';

  Future<List<Post>> getPosts() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List;
      return data.map((item) => Post.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load posts');
    }
  }

  Future<List<Post>> getPostsByUserId(int userId) async {
    final url = '$baseUrl?userId=$userId';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List;
      return data.map((item) => Post.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load posts for user ID: $userId');
    }
  }
}