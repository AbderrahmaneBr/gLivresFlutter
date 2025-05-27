import 'package:flutter/material.dart';
import 'package:gestion_livres/models/book.dart';

class BookDetailPage extends StatelessWidget {
  final Book book;

  const BookDetailPage({Key? key, required this.book}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(book.title)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child:
                    book.imageUrl.isNotEmpty
                        ? Image.network(
                          book.imageUrl,
                          height: 300,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return _buildImagePlaceholder();
                          },
                        )
                        : _buildImagePlaceholder(),
              ),
            ),
            const SizedBox(height: 24),
            Text('Authors', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(book.authors.join(', ')),
            const SizedBox(height: 16),
            Text('Book ID', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(book.id),
          ],
        ),
      ),
    );
  }

  Widget _buildImagePlaceholder() {
    return Container(
      height: 300,
      color: Colors.grey[300],
      child: const Icon(Icons.book, size: 50),
    );
  }
}
