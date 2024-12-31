import 'package:flutter/material.dart';
import 'package:todo/models/post_model.dart';
import 'package:todo/models/post_service.dart';

class PostProvider extends ChangeNotifier {
  final PostService _postService = PostService();
  List<Post> _posts = [];
  bool _isLoading = false;
  String _error = '';
  int? _filterUserId;

  List<Post> get posts => _posts;
  bool get isLoading => _isLoading;
  String get error => _error;
  int? get filterUserId => _filterUserId;


  Future<void> loadPosts() async {
    _isLoading = true;
    notifyListeners();
    try {
      if (_filterUserId != null) {
        _posts = await _postService.getPostsByUserId(_filterUserId!);
      } else {
        _posts = await _postService.getPosts();
      }
      _error = '';
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void setFilterUserId(int? userId) {
    _filterUserId = userId;
    loadPosts();
  }
}