import 'dart:async';
import 'dart:io' show Platform;
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_exif_rotation/flutter_exif_rotation.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:facesdk_plugin/facesdk_plugin.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Face Recognition',
      theme: ThemeData(
        // Define the default brightness and colors.
        useMaterial3: true,
        brightness: Brightness.dark,
      ),
      home: MyHomePage(title: 'Face Recognition'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String title;

  const MyHomePage({Key? key, required this.title}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _facesdkPlugin = FacesdkPlugin();
  final MethodChannel _teeChannel = MethodChannel('tee_channel');

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    int facepluginState = -1;
    try {
      if (Platform.isAndroid) {
        await _facesdkPlugin
            .setActivation(
                "CFO+UUpNLaDMlmdjoDlhBMbgCwT27CzQJ4xHpqe9rDOErwoEUeCGPRTfQkZEAFAFdO0+rTNRIwnQwpqqGxBbfnLkfyFeViVS5bpWZFk15QXP3ZtTEuU1rK5zsFwcZrqRUxsG9dXImc+Vw5Ddc9zBp9GEUuDycHLqC9KgQGVb0TS2u9Kz67HQOSDw9hskjBpjRbqiG+F/h5DBLPzjgFh1Y6vzgg6I59FzTOcdrdEbX7kI15Nwgf1hvHGtSgON/a0Fmw+XNdnxH2pVY96mcTemHYZAtxh8lA/t1DtTyZXpHjW8N6nq4UN2YDlKLXSrDzLpLHJmBsdpH71AXb7dfAq94Q==")
            .then((value) => facepluginState = value ?? -1);
      } else {
        await _facesdkPlugin
            .setActivation(
                "nWsdDhTp12Ay5yAm4cHGqx2rfEv0U+Wyq/tDPopH2yz6RqyKmRU+eovPeDcAp3T3IJJYm2LbPSEz"
                "+e+YlQ4hz+1n8BNlh2gHo+UTVll40OEWkZ0VyxkhszsKN+3UIdNXGaQ6QL0lQunTwfamWuDNx7Ss"
                "efK/3IojqJAF0Bv7spdll3sfhE1IO/m7OyDcrbl5hkT9pFhFA/iCGARcCuCLk4A6r3mLkK57be4r"
                "T52DKtyutnu0PDTzPeaOVZRJdF0eifYXNvhE41CLGiAWwfjqOQOHfKdunXMDqF17s+LFLWwkeNAD"
                "PKMT+F/kRCjnTcC8WPX3bgNzyUBGsFw9fcneKA==")
            .then((value) => facepluginState = value ?? -1);
      }

      if (facepluginState == 0) {
        await _facesdkPlugin.init();
      }
    } catch (e) {}
  }

  Future<void> enrollPerson() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.camera);
      if (image == null) return;

      var rotatedImage =
          await FlutterExifRotation.rotateImage(path: image.path);

      final faces = await _facesdkPlugin.extractFaces(rotatedImage.path);

      if (faces.isNotEmpty) {
        Fluttertoast.showToast(
          msg: "Person detected!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      } else {
        Fluttertoast.showToast(
          msg: "No face detected!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }

      // Read image as bytes and send to TEE
      final imageData = await rotatedImage.readAsBytes();
      _sendImageDataToTEE(imageData);
    } catch (e) {
      // Handle error
    }
  }

  Future<int> processSignIn(Uint8List imageData) async {
    try {
      print("Sending image data for sign-in verification...");
      final result = await _teeChannel.invokeMethod('processSignIn', {'data': imageData});
      return result as int; // Return the result received from TEE
    } on PlatformException catch (e) {
      print("Failed to send data to TEE: '${e.message}'.");
      return -1; // Return -1 to indicate error
    }
  }

  Future<void> signIn() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.camera);
      if (image == null) return;

      var rotatedImage =
          await FlutterExifRotation.rotateImage(path: image.path);

      final faces = await _facesdkPlugin.extractFaces(rotatedImage.path);

      if (faces.isNotEmpty) {
        Fluttertoast.showToast(
          msg: "Person detected!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      } else {
        Fluttertoast.showToast(
          msg: "No face detected!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }

      // Read image as bytes and send to TEE for sign-in verification
      final imageData = await rotatedImage.readAsBytes();
      final result = await processSignIn(imageData);

      if (result == 1) {
        // User is registered
        Fluttertoast.showToast(
          msg: "User is registered!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      } else if (result == 0) {
        // User is not registered
        Fluttertoast.showToast(
          msg: "User is not registered!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      } else {
        // Error occurred
        Fluttertoast.showToast(
          msg: "Error occurred!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
    } catch (e) {
      // Handle error
    }
  }

  Future<void> _sendImageDataToTEE(Uint8List imageData) async {
    try {
      print("Sending image data to TEE...");
      await _teeChannel.invokeMethod('processImageData', {'data': imageData});
    } on PlatformException catch (e) {
      print("Failed to send data to TEE: '${e.message}'.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Demo-Ritwik and Shivam '),
        toolbarHeight: 70,
        centerTitle: true,
      ),
      body: Container(
        margin: const EdgeInsets.only(left: 16.0, right: 16.0),
        child: Column(
          children: <Widget>[
            const SizedBox(
              height: 6,
            ),
            ElevatedButton.icon(
              label: const Text('Register'),
              icon: const Icon(Icons.camera),
              onPressed: enrollPerson,
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              label: const Text('Sign In'),
              icon: const Icon(Icons.camera),
              onPressed: signIn,
            ),
          ],
        ),
      ),
    );
  }
}