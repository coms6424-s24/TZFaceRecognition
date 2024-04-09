import 'package:flutter/material.dart';

class RegistrationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registration'),
        backgroundColor: Colors.transparent, // Make app bar transparent
        elevation: 0, // Remove app bar shadow
      ),
      backgroundColor: Colors.black, // Set the background color to black
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const TextField(
              decoration: InputDecoration(
                labelText: 'Username',
                labelStyle: TextStyle(color: Colors.white), // Set label text color
                enabledBorder: OutlineInputBorder( // Set outline border color
                  borderRadius: BorderRadius.all(Radius.circular(10)), // Adjust the border radius
                  borderSide: BorderSide(color: Colors.greenAccent, width: 2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const TextField(
              decoration: InputDecoration(
                labelText: 'Email',
                labelStyle: TextStyle(color: Colors.white), // Set label text color
                enabledBorder: OutlineInputBorder( // Set outline border color
                  borderRadius: BorderRadius.all(Radius.circular(10)), // Adjust the border radius
                  borderSide: BorderSide(color: Colors.greenAccent, width: 2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const TextField(
              decoration: InputDecoration(
                labelText: 'Password',
                labelStyle: TextStyle(color: Colors.white), // Set label text color
                enabledBorder: OutlineInputBorder( // Set outline border color
                  borderRadius: BorderRadius.all(Radius.circular(10)), // Adjust the border radius
                  borderSide: BorderSide(color: Colors.greenAccent, width: 2),
                ),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.greenAccent, // Neon green color
                  width: 2, // Border width
                ),
                borderRadius: BorderRadius.circular(8), // Border radius
              ),
              child: ElevatedButton(
                onPressed: () {
                  // Add registration logic here
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black, // Set button background color to black
                ),
                child: Text(
                  'Register',
                  style: TextStyle(color: Colors.white), // Set button text color
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
