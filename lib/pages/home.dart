import 'package:final_project/pages/add_page.dart';
import 'package:final_project/pages/edit_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List user = [];
  bool isLoading = true;
  List<Map> users = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 71, 66, 66),
        title: const Text('Final Project'),
      ),
      body: Visibility(
        visible: isLoading,
        child: const Center(
          child: CircularProgressIndicator(
            backgroundColor: Colors.white,
          ),
        ),
        replacement: RefreshIndicator(
          onRefresh: fetchUsers,
          child: ListView.builder(
            itemCount: user.length,
            itemBuilder: (context, index) {
              final users = user[index] as Map;
              return Card(
                child: ListTile(
                  leading: const Icon(Icons.person),
                  title: Text(users['name']),
                  subtitle: Text(users['email']),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditPage(
                                user: users,
                              ),
                            ),
                          );
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Warning'),
                                content: const Text(
                                    'Are you sure you want to delete this user?'),
                                actions: <Widget>[
                                  TextButton(
                                    child: const Text('Cancel'),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  TextButton(
                                    child: const Text('Delete'),
                                    onPressed: () {
                                      deleteUser(users['id']);
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: navigateToAddPage,
        label: const Text('Add'),
      ),
    );
  }

  void navigateToAddPage() {
    final route = MaterialPageRoute(
      builder: (context) => RegisterPage(),
    );
    Navigator.push(context, route);
  }

  Future<void> fetchUsers() async {
    setState(() {
      isLoading = false;
    });
    const url = 'http://192.168.31.24/api/users';
    final uri = Uri.parse(url);
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body) as Map;
      final result = jsonData['user'] as List;

      setState(() {
        user = result;
      });
    }

    setState(() {
      isLoading = false;
    });
  }

  Future<void> deleteUser(int id) async {
    setState(() {
      isLoading = true;
    });

    final url = 'http://192.168.31.97/api/users/delete/$id';

    try {
      final response = await http.delete(Uri.parse(url));

      if (response.statusCode == 200) {
        setState(() {
          users.removeWhere((user) => user['id'] == id);
          isLoading = false;
        });
        await fetchUsers(); // Refresh the list
      } else {
        throw Exception('Failed to delete user.');
      }
    } catch (e) {
      print('Failed to delete user: $e');
      setState(() {
        isLoading = false;
      });
    }
  }
}
