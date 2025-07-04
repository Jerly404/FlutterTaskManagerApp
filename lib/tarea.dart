class Tarea {
  final String id;
  final String title;
  final String description;

  Tarea({required this.id, required this.title, required this.description});

  factory Tarea.fromJson(Map<String, dynamic> json) {
    return Tarea(
      id: json['id'],
      title: json['title'],
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
    };
  }
}
