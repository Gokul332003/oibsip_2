import 'package:flutter/material.dart';
import 'main_menu_screen.dart';
import '../database/database.dart';
import 'signup_screen.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
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
                hintText: 'Enter your username',
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
                hintText: 'Enter your password',
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () async {
                // Validate login using the database
                bool isValid = await _validateUser(
                  usernameController.text,
                  passwordController.text,
                );

                if (isValid) {
                  // Navigate to the MainMenuScreen on successful login
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => MainMenuScreen()),
                  );
                } else {
                  // Show login failed feedback
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Login failed. Please check your credentials.'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                }
              },
              child: Text('Login'),
            ),
            SizedBox(height: 8.0),
            TextButton(
              onPressed: () {
                // Navigate to SignUpScreen if the user doesn't have an account
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SignUpScreen()),
                );
              },
              child: Text('Don\'t have an account? Sign Up'),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> _validateUser(String username, String password) async {
    final dbHelper = DatabaseHelper();
    return await dbHelper.validateUser(username, password);
  }
}
