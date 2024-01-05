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
          ElevatedButton(
            onPressed: () async {
              await submitData();
              Navigator.pop(context);
              if (nameController.text.isEmpty ||
                  emailController.text.isEmpty ||
                  passwordController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Please fill in all fields')),
                );
              } else {
                // Handle the submit action here
              }
            },
            child: const Text('Submit'),
          )
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
    const url = 'http://192.168.31.97/api/users';
    final uri = Uri.parse(url);

    final response = await http.post(
      uri,
      body: jsonEncode(body),
      headers: {'Content-Type': 'application/json'},
    );

    //Show success of fail message
    print(response.statusCode);
    print(response.body);
  }
}
