import 'package:mpos/modules/user/model/user.model.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
class Session {
  int id = 0;

  final String ipAddress;

  @Property(type: PropertyType.date)
  final DateTime createdAt;

  final ToOne<User> user = ToOne<User>();

  Session({required this.ipAddress, required this.createdAt});
}
