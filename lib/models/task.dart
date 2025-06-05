class Task {
  final int? id;
  final String title;
  final bool confirmed;

  Task({this.id, required this.title, required this.confirmed});

  Map<String, dynamic> toMap() {
    return {'id': id, 'title': title, 'confirmed': confirmed ? 1 : 0};
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(id: map['id'], title: map['title'], confirmed: map['confirmed'] == 1);
  }
}
