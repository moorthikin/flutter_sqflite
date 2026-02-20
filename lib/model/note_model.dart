class Note {
  int? id;
  String title;
  String description;
  String priority;
  String? deadline;

  Note(
      {required this.description,
      required this.title,
      required this.priority,
      this.deadline,
      this.id});

  factory Note.fromJson(Map<String, dynamic> json) => Note(
        id: json['id'],
        title: json['title'],
        description: json['description'],
        priority: json['priority'] ?? 'Low',
        deadline: json['deadline'],
      );

  Map<String, dynamic> toJson() =>
      {
        'id': id,
        'title': title,
        'description': description,
        'priority': priority,
        'deadline': deadline
      };
}
