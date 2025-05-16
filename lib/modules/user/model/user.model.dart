import 'package:mpos/core/config/model/session.model.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
class User {
  int id = 0;

  String name;
  String email;
  String empId;
  int age;

  @Backlink('user') // backlink from Session
  final sessions = ToMany<Session>();

  User({
    required this.name,
    required this.email,
    required this.empId,
    required this.age,
  });
}
