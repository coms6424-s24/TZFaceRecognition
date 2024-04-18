import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_ml_vision/google_ml_vision.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/services.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final MethodChannel _teeChannel = MethodChannel('tee_channel');

  @override
  void initState() {
    super.initState();
    _takePicture(context);
  }

  Future<void> _takePicture(BuildContext context) async {
    final imagePicker = ImagePicker();
    final XFile? image =
        await imagePicker.pickImage(source: ImageSource.camera);
    if (image != null) {
      // Image captured, send it to TEE
      final imageData = await image.readAsBytes();
      print(imageData);
      final GoogleVisionImage visionImage =
          GoogleVisionImage.fromFilePath(image.path);

      // Detect faces in the image
      final FaceDetector faceDetector = GoogleVision.instance.faceDetector();
      final List<Face> faces = await faceDetector.processImage(visionImage);

      if (faces.isNotEmpty) {
        // Assuming only one face is detected, extract features for the first face
        for (Face face in faces) {
          final Rect boundingBox = face.boundingBox!;

          final double? rotY = face.headEulerAngleY; // Make it nullable
          final double? rotZ = face.headEulerAngleZ; // Make it nullable

          // If landmark detection was enabled with FaceDetectorOptions (mouth, ears,
          // eyes, cheeks, and nose available):
          final FaceLandmark? leftEar = face.getLandmark(FaceLandmarkType.leftEar); // Make it nullable
          if (leftEar != null) {
            final Point<double> leftEarPos = Point(leftEar.position.dx, leftEar.position.dy); // Convert Offset to Point<double>
          }

          // If classification was enabled with FaceDetectorOptions:
          final double? smileProb = face.smilingProbability; // Make it nullable

          // If face tracking was enabled with FaceDetectorOptions:
          final int? id = face.trackingId; // Make it nullable
        }
        // Process the landmarks or any other features you're interested in
      } else {
        // No face detected
        print('No face detected.');
      }

      _sendImageDataToTEE(imageData);
    } else {
      // No image selected
      print('No image selected.');
    }
  }

  Future<void> _sendImageDataToTEE(Uint8List imageData) async {
    try {
      print("this is being called from the send Image Data ");
      await _teeChannel.invokeMethod('processImageData', {'data': imageData});
    } on PlatformException catch (e) {
      print("Failed to send data to TEE: '${e.message}'.");
    }
  }

  @override
  Widget build(BuildContext context) {
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
            // Your email and password text fields
            const TextField(
              decoration: InputDecoration(
                labelText: 'Email',
                // Remaining code for email text field...
              ),
            ),
            const SizedBox(height: 20),
            const TextField(
              decoration: InputDecoration(
                labelText: 'Password',
                // Remaining code for password text field...
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
                  backgroundColor:
                      Colors.black, // Set button background color to black
                ),
                child: Text(
                  'Login',
                  style:
                      TextStyle(color: Colors.white), // Set button text color
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
