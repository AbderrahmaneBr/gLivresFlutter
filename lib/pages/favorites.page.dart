import 'package:flutter/material.dart';
import 'package:gestion_livres/services/db.service.dart';
import '../models/book.dart';

class FavoritesPage extends StatefulWidget {
  @override
  _FavoritesPageState createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  final DatabaseService _dbService = DatabaseService();

  void _removeFromFavorites(String bookId) async {
    await _dbService.deleteItem(bookId);
    setState(() {}); // Refresh the list
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Removed from favorites')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Favorite Books')),
      body: FutureBuilder<List<Book>>(
        future: _dbService.getItems(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final favoriteBooks = snapshot.data ?? [];

          if (favoriteBooks.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.favorite_border, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'No favorite books yet',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            itemCount: favoriteBooks.length,
            itemBuilder: (context, index) {
              final book = favoriteBooks[index];
              return Card(
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
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
                  trailing: IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _removeFromFavorites(book.id),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
