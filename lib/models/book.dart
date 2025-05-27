class Book {
  final String id;
  final String title;
  final List<dynamic> authors;
  final String imageUrl;

  Book(this.id, this.title, this.authors, this.imageUrl);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'authors': authors.join(", "),
      'imageUrl': imageUrl,
    };
  }

  factory Book.fromJson(Map<String, dynamic> json) {
    final volumeInfo = json["volumeInfo"] ?? {};
    final authors =
        (volumeInfo['authors'] as List<dynamic>?)?.cast<String>() ??
        ["Unknown"];

    return Book(
      json['id'] as String,
      volumeInfo['title'] as String? ?? "No Title",
      authors,
      volumeInfo['imageLinks']?["thumbnail"] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'title': title, 'authors': authors, 'imageUrl': imageUrl};
  }

  factory Book.fromMap(Map<String, dynamic> map) {
    return Book(
      map['id'] as String,
      map['title'] as String,
      (map['authors'] as String).split(', ') as List<dynamic>,
      map['imageUrl'] as String,
    );
  }
}
