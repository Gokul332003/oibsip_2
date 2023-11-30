import 'package:flutter/material.dart';
import '../database/database.dart';

class SignUpScreen extends StatelessWidget {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: usernameController,
              decoration: InputDecoration(
                labelText: 'Username',
                hintText: 'Choose a username',
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
                hintText: 'Choose a password',
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () async {
                // Validate inputs
                if (usernameController.text.isEmpty || passwordController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Please enter both username and password.'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                  return;
                }

                // Attempt to sign up
                bool signUpSuccess = await _insertUser(
                  usernameController.text,
                  passwordController.text,
                );

                // Show feedback
                if (signUpSuccess) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Signup successful!'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Signup failed. Please try again.'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                }
              },
              child: Text('Sign Up'),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> _insertUser(String username, String password) async {
    try {
      final dbHelper = DatabaseHelper();
      await dbHelper.insertUser(username, password);
      return true; // Signup success
    } catch (e) {
      print('Error during signup: $e');
      return false; // Signup failed
    }
  }
}
