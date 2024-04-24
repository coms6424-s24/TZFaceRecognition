#include <opencv2/opencv.hpp>
#include <iostream>
#include <vector>

using namespace cv;
using namespace std;

//roight now this is reading from a image on the laptop. Change this to secure storage after init
void captureFacesAndStore() {
    // Load the face detection model
    CascadeClassifier faceCascade;
    if (!faceCascade.load("src/haarcascade_frontalface_default.xml")) {
        cerr << "Error: Unable to load face detection model" << endl;
        return;
    }

    // Load an image containing faces
    Mat image = imread("test/test_img.jpeg");
    if (image.empty()) {
        cerr << "Error: Unable to load image" << endl;
        return;
    }

    // Convert the image to grayscale for face detection
    Mat grayImage;
    cvtColor(image, grayImage, COLOR_BGR2GRAY);

    // Detect faces in the image
    vector<Rect> faces;
    faceCascade.detectMultiScale(grayImage, faces, 1.1, 4);

    // For each detected face
    for (size_t i = 0; i < faces.size(); ++i) {
        Rect face = faces[i];

        // Extract the detected face from the image
        Mat detectedFace = grayImage(face);

        // Save the detected face to disk (you may need to use a unique filename)
string filename = "detected_faces/detected_face_" + to_string(i) + ".jpg";
        imwrite(filename, detectedFace);

        // Print the coordinates of the detected face
        cout << "Face " << i + 1 << " Detected at: " << face.x << ", " << face.y << endl;

        // Draw a rectangle around the detected face for visualization
        rectangle(image, face, Scalar(255, 0, 0), 2);
    }

    // Display the image with detected faces
    imshow("Detected Faces", image);
    waitKey(0);
}

// Function to recognize faces from a new photo
void recognizeFaces() {
    // Capture a new photo containing a face

    // Extract facial features from the new photo

    // Compare the extracted features with the stored features in the database

    // Determine if the new face matches any of the faces stored in the database
}

int main() {
    // Capture faces and store in the database
    captureFacesAndStore();

    // Recognize faces from a new photo
    //recognizeFaces();

    return 0;
}
