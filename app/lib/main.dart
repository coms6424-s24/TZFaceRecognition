import 'package:flutter/material.dart';
import 'LoginPage.dart';
import 'RegisterationPage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // Set primaryColor to transparent
        primaryColor: Colors.transparent,
        appBarTheme: const AppBarTheme(
          // Set appBar's background color to transparent
          backgroundColor: Color.fromARGB(255, 62, 184, 66),
        ),
      ),
      home: const MyHomePage(title: 'Secure Face Recognition using TZ'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
                        ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              },
              // Style for Login button
              style: ElevatedButton.styleFrom(
                primary: Color.fromARGB(255, 46, 134, 49), // Set background color
                padding: EdgeInsets.symmetric(vertical: 16, horizontal: 32), // Increase padding
              ),
              child: const Text('  Login  '),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.05, // 10% of the screen height
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RegistrationPage()),
                );
              },
              // Style for Register button
              style: ElevatedButton.styleFrom(
                primary: Color.fromARGB(255, 46, 134, 49), // Set background color
                padding: EdgeInsets.symmetric(vertical: 16, horizontal: 32), // Increase padding
              ),
              child: const Text('Register'),
            ),
            


          ],
        ),
      ),
    );
  }
}
