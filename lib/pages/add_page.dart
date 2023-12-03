import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          TextField(
            controller: nameController,
            decoration: InputDecoration(hintText: 'Name'),
          ),
          TextField(
            controller: emailController,
            decoration: InputDecoration(hintText: 'email'),
          ),
          TextField(
            controller: passwordController,
            decoration: InputDecoration(hintText: 'password'),
          ),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton(onPressed: submitData, child: const Text('Submit'))
        ],
      ),
    );
  }

  Future<void> submitData() async {
    //Get the data from the form
    final name = nameController.text;
    final email = emailController.text;
    final password = passwordController.text;

    final body = {"name": name, "email": email, "password": password};
    //Submit data to the database
    const url = 'http://127.0.0.1:8000/api/users';
    final uri = Uri.parse(url);
    final response = await http.post(
      uri,
      body: jsonEncode(body),
      headers: {'Accept': 'application/json'},
    );
    //Show success of fail message
    print(response.statusCode);
    print(response.body);
  }
}

