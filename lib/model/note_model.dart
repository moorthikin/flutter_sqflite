class Note {
  int? id;
  String title;
  String description;

  Note({required this.description, required this.title, this.id});

  factory Note.fromJson(Map<String, dynamic> json) => Note(
        id: json['id'],
        title: json['title'],
        description: json['description'],
      );

  Map<String, dynamic> toJson() =>
      {'id': id, 'title': title, 'description': description};
}
