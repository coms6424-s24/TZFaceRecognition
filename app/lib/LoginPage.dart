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
    // Use FutureBuilder to execute _takePicture when LoginPage is built for the first time
    return FutureBuilder(
      future: _takePicture(context),
      builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
        // Display a loading indicator while the picture is being taken
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(
              title: Text('Login'),
            ),
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else {
          // Once picture is taken, show the login UI
          return Scaffold(
            appBar: AppBar(
              title: Text('Login'),
            ),
            body: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const TextField(
                    decoration: InputDecoration(labelText: 'Email'),
                  ),
                  SizedBox(height: 20),
                  const TextField(
                    decoration: InputDecoration(labelText: 'Password'),
                    obscureText: true,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      _takePicture(context); // Call function to take a picture
                    },
                    child: Text('Login'),
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
