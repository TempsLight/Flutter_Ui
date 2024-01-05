import 'package:final_project/pages/add_page.dart';
import 'package:final_project/pages/home.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(
                labelText: 'Password',
              ),
              obscureText: true,
            ),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
              onPressed: () => login(context),
              child: const Text('Login'),
            ),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RegisterPage(),
                  ),
                );
              },
              child: Text('Sign Up'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> login(BuildContext context) async {
    final email = _emailController.text;
    final password = _passwordController.text;

    const url = 'http://192.168.31.97/api/users/login';
    final response = await http.post(
      Uri.parse(url),
      body: jsonEncode({'email': email, 'password': password}),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      // Decode the response body
      final responseData = jsonDecode(response.body);
      print('Response data: $responseData');
      // Handle successful login here
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if (responseData['id'] != null) {
        await prefs.setInt('id', responseData['user']['id']);
      } else {
        print('ID is null');
      }
      await prefs.setString('token', responseData['token']);
      print({responseData['token']});
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Login successful')),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
      print('Login successful');
    } else {
      // Handle failed login here
      print('Login failed');
    }
  }
}
