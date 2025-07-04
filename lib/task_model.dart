class TaskModel {
  String id;
  String titulo;
  String descripcion;
  String userId;

  TaskModel({this.id = '', required this.titulo, required this.descripcion, required this.userId});

  factory TaskModel.fromJson(Map<String, dynamic> j) => TaskModel(
        id: j['id'] ?? '',
        titulo: j['titulo'] ?? '',
        descripcion: j['descripcion'] ?? '',
        userId: j['userId'] ?? '',
      );

  Map<String, String> toJson() => {
        'titulo': titulo,
        'descripcion': descripcion,
        'userId': userId,
      };
}
