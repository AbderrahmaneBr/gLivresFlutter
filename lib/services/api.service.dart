import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/book.dart';

class ApiService {
  static const String baseUrl = 'https://www.googleapis.com/books/v1/volumes';

  static Future<List<Book>> searchBooks(String query) async {
    if (query.isEmpty) return [];

    try {
      query = Uri.encodeComponent(query.trim());

      final response = await http.get(
        Uri.parse('$baseUrl?q=$query&maxResults=30'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final items = data['items'] as List<dynamic>? ?? [];

        return items.map((item) => Book.fromJson(item)).toList();
      } else {
        throw Exception('Failed to load books');
      }
    } catch (e) {
      throw Exception('Error searching books: $e');
    }
  }
}
