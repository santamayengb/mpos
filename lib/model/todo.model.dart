import 'package:objectbox/objectbox.dart';

@Entity()
class Todo {
  @Id()
  int id = 0;

  String uuid;
  String title;
  bool completed;

  Todo({required this.uuid, required this.title, this.completed = false});

  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      uuid: json['uuid'] ?? '', // Add fallback if missing
      title: json['title'] ?? '',
      completed: json['isDone'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {'uuid': uuid, 'title': title, 'isDone': completed};
  }
}
