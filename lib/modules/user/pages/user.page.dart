import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:mpos/core/config/web_socket/web_socket_cubit.dart';
import 'package:mpos/modules/user/model/user.model.dart';
import 'package:mpos/services/user.service.dart';

final faker = Faker();

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  @override
  Widget build(BuildContext context) {
    final users = UserService.getAllUsers();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppBar(
          title: Text("Users"),
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(child: Text("A")),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "User Managment",
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Text(
                "Managment your team members and their account permission here",
              ),
              Gap(20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "All User ${users.length}",
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  TextButton.icon(
                    icon: Icon(Icons.add),
                    onPressed: () {
                      final formKey = GlobalKey<FormState>();
                      final nameController = TextEditingController();
                      final emailController = TextEditingController();
                      final empIdController = TextEditingController();
                      final ageController = TextEditingController();

                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text("Add User"),
                            content: Form(
                              key: formKey,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  TextFormField(
                                    controller: nameController,
                                    decoration: InputDecoration(
                                      labelText: "Name",
                                    ),
                                    validator:
                                        (value) =>
                                            value == null || value.isEmpty
                                                ? "Enter name"
                                                : null,
                                  ),
                                  TextFormField(
                                    controller: emailController,
                                    decoration: InputDecoration(
                                      labelText: "Email",
                                    ),
                                    validator:
                                        (value) =>
                                            value == null ||
                                                    !value.contains('@')
                                                ? "Enter valid email"
                                                : null,
                                  ),
                                  TextFormField(
                                    controller: empIdController,
                                    decoration: InputDecoration(
                                      labelText: "Emp ID",
                                    ),
                                    validator:
                                        (value) =>
                                            value == null || value.isEmpty
                                                ? "Enter emp ID"
                                                : null,
                                  ),
                                  TextFormField(
                                    controller: ageController,
                                    decoration: InputDecoration(
                                      labelText: "Age",
                                    ),
                                    keyboardType: TextInputType.number,
                                    validator:
                                        (value) =>
                                            value == null ||
                                                    int.tryParse(value) == null
                                                ? "Enter valid age"
                                                : null,
                                  ),
                                ],
                              ),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(),
                                child: Text("Cancel"),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  if (formKey.currentState!.validate()) {
                                    final newUser = User(
                                      name: nameController.text,
                                      email: emailController.text,
                                      empId: empIdController.text,
                                      age: int.parse(ageController.text),
                                    );
                                    UserService.addUser(newUser);
                                    Navigator.of(context).pop();
                                    // Call setState or notify your data table
                                    setState(() {});
                                  }
                                },
                                child: Text("Add"),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    label: Text("Add User"),
                  ),
                ],
              ),
            ],
          ),
        ),
        Expanded(child: PaginatedUserTable()),
      ],
    );
  }
}

class UserDataSource extends DataTableSource {
  final List<User> users;
  final List<String> onlineEmpIds;

  UserDataSource(this.users, this.onlineEmpIds);

  void removeUser(int userId) {
    users.removeWhere((user) => user.id == userId);
    notifyListeners(); // Triggers rebuild
  }

  @override
  DataRow getRow(int index) {
    final user = users[index];
    final isEven = index % 2 == 0;
    return DataRow.byIndex(
      index: index,
      color: WidgetStatePropertyAll(
        isEven ? Colors.white : Colors.grey.shade200,
      ),
      cells: [
        DataCell(Text("${user.id}")),
        DataCell(Text(user.name)),
        DataCell(Text(user.email)),
        DataCell(
          Text((user.sessions.isNotEmpty) ? user.sessions.last.ipAddress : "-"),
        ),
        DataCell(
          onlineEmpIds.contains(user.empId)
              ? Container(
                padding: EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(" Online ", style: TextStyle(color: Colors.white)),
              )
              : Container(
                padding: EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: Colors.deepOrange,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(" Offline ", style: TextStyle(color: Colors.white)),
              ),
        ),
        DataCell(Text(user.empId)),
        DataCell(
          Text(
            (user.sessions.isNotEmpty)
                ? DateFormat(
                  'MMM d, yyyy h:mm a',
                ).format(user.sessions.last.createdAt)
                : "-",
          ),
        ),
        DataCell(
          Row(
            children: [
              IconButton(onPressed: () {}, icon: Icon(Icons.edit)),
              IconButton(
                onPressed: () {
                  UserService.deleteUser(user.id);
                  removeUser(user.id); // Notify after deletion
                },
                icon: Icon(Icons.delete),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => users.length;

  @override
  int get selectedRowCount => 0;
}

class PaginatedUserTable extends StatelessWidget {
  final List<User> users = UserService.getAllUsers();

  PaginatedUserTable({super.key});

  @override
  Widget build(BuildContext context) {
    final wsState = context.watch<WebSocketCubit>().state;
    final onlineEmpIds = wsState.clientinfo.map((c) => c.empId).toList();
    return SingleChildScrollView(
      child: PaginatedDataTable(
        // header: Text('User List'),
        columns: const [
          DataColumn(label: Text('ID')),
          DataColumn(label: Text('Name')),
          DataColumn(label: Text('Email')),
          DataColumn(label: Text('IP')),
          DataColumn(label: Text('Status')),
          DataColumn(label: Text('Emp ID')),
          DataColumn(label: Text('Last Sync')),
          DataColumn(label: Text('Action')),
        ],
        source: UserDataSource(users, onlineEmpIds),
        rowsPerPage: 10,
        showCheckboxColumn: false,
      ),
    );
  }
}
