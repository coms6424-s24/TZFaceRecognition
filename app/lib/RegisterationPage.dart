import 'package:flutter/material.dart';
class RegistrationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registration'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const TextField(
              decoration: InputDecoration(labelText: 'Username'),
            ),
            const SizedBox(height: 20),
            const TextField(
              decoration: InputDecoration(labelText: 'Email'),
            ),
            const SizedBox(height: 20),
            const TextField(
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Add registration logic here
              },
              child: Text('Register'),
            ),
          ],
        ),
      ),
    );
  }
}
