import 'package:flutter/material.dart';
import 'package:gestion_livres/pages/detail.page.dart';
import 'package:gestion_livres/pages/favorites.page.dart';
import 'package:gestion_livres/services/api.service.dart';
import 'package:gestion_livres/services/db.service.dart';
import '../models/book.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  List<Book> _searchResults = [];
  bool _isLoading = false;
  final DatabaseService _dbService = DatabaseService();

  void _searchBooks() async {
    if (_searchController.text.trim().isEmpty) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final results = await ApiService.searchBooks(
        _searchController.text.trim(),
      );
      setState(() {
        _searchResults = results;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  void _toggleFavorite(Book book) async {
    final isFav = await _dbService.isFavorite(book.id);

    if (isFav) {
      await _dbService.deleteItem(book.id);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Removed from favorites')));
    } else {
      await _dbService.insertItem(book);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Added to favorites')));
    }
    setState(() {}); // Refresh to update favorite icons
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Books'),
        actions: [
          IconButton(
            icon: Icon(Icons.favorite),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FavoritesPage()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search for books...',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (_) => _searchBooks(),
                  ),
                ),
                SizedBox(width: 8),
                ElevatedButton(onPressed: _searchBooks, child: Text('Search')),
              ],
            ),
          ),
          Expanded(
            child:
                _isLoading
                    ? Center(child: CircularProgressIndicator())
                    : _searchResults.isEmpty
                    ? Center(child: Text('Search for books to see results'))
                    : ListView.builder(
                      itemCount: _searchResults.length,
                      itemBuilder: (context, index) {
                        final book = _searchResults[index];
                        return BookTile(
                          book: book,
                          onFavoriteToggle: () => _toggleFavorite(book),
                        );
                      },
                    ),
          ),
        ],
      ),
    );
  }
}

class BookTile extends StatelessWidget {
  final Book book;
  final VoidCallback onFavoriteToggle;

  const BookTile({Key? key, required this.book, required this.onFavoriteToggle})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => BookDetailPage(book: book)),
          );
        },
        leading:
            book.imageUrl.isNotEmpty
                ? Image.network(
                  book.imageUrl,
                  width: 50,
                  height: 70,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 50,
                      height: 70,
                      color: Colors.grey[300],
                      child: Icon(Icons.book),
                    );
                  },
                )
                : Container(
                  width: 50,
                  height: 70,
                  color: Colors.grey[300],
                  child: Icon(Icons.book),
                ),
        title: Text(
          book.title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          book.authors.join(', '),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: FutureBuilder<bool>(
          future: DatabaseService().isFavorite(book.id),
          builder: (context, snapshot) {
            final isFavorite = snapshot.data ?? false;
            return IconButton(
              icon: Icon(
                isFavorite ? Icons.favorite : Icons.favorite_border,
                color: isFavorite ? Colors.red : Colors.grey,
              ),
              onPressed: onFavoriteToggle,
            );
          },
        ),
      ),
    );
  }
}
