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
          backgroundColor: Color.fromARGB(255, 156, 20, 20),
        ),
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double fontSize = screenWidth * 0.05; // Adjust this multiplier as needed

    return Scaffold(
      backgroundColor: Colors.black, // Set the background color to black

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Shiri',
              style: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                fontFamily: 'RetroHackerFont', // Use the correct font family name
                color: Color.fromARGB(255, 7, 234, 15),
              ),
            ),
            SizedBox(
              height: screenHeight * 0.05, // Add some space between text and buttons
            ),
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Color.fromARGB(255, 7, 234, 15), // Neon green color
                  width: 4, // Border width
                ),
                borderRadius: BorderRadius.circular(8), // Border radius
              ),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                },
                // Style for Login button
                style: ElevatedButton.styleFrom(
                  primary: Colors.black, // Set button background color to black
                  padding: EdgeInsets.symmetric(
                      vertical: 16, horizontal: 32), // Increase padding
                ),
                child: Text(
                  '  Login  ',
                  style: TextStyle(
                    fontFamily: 'RetroHackerFont', // Use the custom font for the button text
                  ),
                ),
              ),
            ),
            SizedBox(
              height: screenHeight * 0.05, // Add some space between buttons
            ),
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Color.fromARGB(255, 7, 234, 15), // Neon green color
                  width: 4, // Border width
                ),
                borderRadius: BorderRadius.circular(8), // Border radius
              ),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RegistrationPage()),
                  );
                },
                // Style for Register button
                style: ElevatedButton.styleFrom(
                  primary: Colors.black, // Set button background color to black
                  padding: EdgeInsets.symmetric(
                      vertical: 16, horizontal: 32), // Increase padding
                ),
                child: Text(
                  'Register',
                  style: TextStyle(
                    fontFamily: 'RetroHackerFont', // Use the custom font for the button text
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
