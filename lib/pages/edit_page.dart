import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class EditPage extends StatefulWidget {
  final Map user;

  EditPage({required this.user});

  @override
  _EditPageState createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user['name']);
    _emailController = TextEditingController(text: widget.user['email']);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit User'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(hintText: 'Name'),
            ),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(hintText: 'Email'),
            ),
            ElevatedButton(
              onPressed: () async {
                try {
                  final response = await http.put(
                    Uri.parse('http://192.168.31.97/api/users/edit/${widget.user['id']}'),
                    body: {
                      'name': _nameController.text,
                      'email': _emailController.text,
                    },
                  );
                  if (response.statusCode == 200) {
                    setState(() {
                      widget.user['name'] = _nameController.text;
                      widget.user['email'] = _emailController.text;
                    });
                    Navigator.pop(context);
                  } else {
                    throw Exception('Failed to update user.');
                  }
                } catch (e) {
                  // You can show a dialog or a snackbar here
                  print('Failed to update user: $e');
                }
              },
              child: const Text('Update'),
            ),
          ],
        ),
      ),
    );
  }
}
