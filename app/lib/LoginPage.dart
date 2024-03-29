import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class LoginPage extends StatelessWidget {
  Future<void> _takePicture(BuildContext context) async {
    final imagePicker = ImagePicker();
    final XFile? image = await imagePicker.pickImage(source: ImageSource.camera);
    if (image != null) {
      // Image captured, you can handle it accordingly
      print('Image Path: ${image.path}');
    } else {
      // No image selected
      print('No image selected.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _takePicture(context),
      builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(
              title: Text('Login'),
              backgroundColor: Colors.transparent, // Make app bar transparent
              elevation: 0, // Remove app bar shadow
            ),
            backgroundColor: Colors.black, // Set the background color to black
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else {
          return Scaffold(
            appBar: AppBar(
              title: Text('Login'),
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
                      labelText: 'Email',
                      labelStyle: TextStyle(color: Colors.white), // Set label text color
                      enabledBorder: OutlineInputBorder( // Set outline border color
                        borderRadius: BorderRadius.all(Radius.circular(10)), // Adjust the border radius
                        borderSide: BorderSide(color: Colors.greenAccent, width: 2),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
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
                  SizedBox(height: 20),
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
                        _takePicture(context); // Call function to take a picture
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.black, // Set button background color to black
                      ),
                      child: Text(
                        'Login',
                        style: TextStyle(color: Colors.white), // Set button text color
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
