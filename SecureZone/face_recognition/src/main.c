#include <opencv2/opencv.hpp>
#include <iostream>
#include <vector>
#include <filesystem>

using namespace cv;
using namespace std;
namespace fs = std::__fs::filesystem;

// Placeholder function for facial feature extraction and comparison
bool areFacialFeaturesMatching(const Mat& detectedFace1, const Mat& detectedFace2) {
    // Implement your facial feature extraction and comparison algorithm here
    // For demonstration purposes, let's assume all faces are considered a match

// Display the concatenated image
    imshow("Detected Faces", detectedFace2);
    waitKey(0);
    return true;
}

void captureFacesAndStore() {
    CascadeClassifier faceCascade;
    if (!faceCascade.load("src/haarcascade_frontalface_default.xml")) {
        cerr << "Error: Unable to load face detection model" << endl;
        return;
    }

    Mat image = imread("test/test_img.jpeg");
    if (image.empty()) {
        cerr << "Error: Unable to load image" << endl;
        return;
    }

    Mat grayImage;
    cvtColor(image, grayImage, COLOR_BGR2GRAY);

    vector<Rect> faces;
    faceCascade.detectMultiScale(grayImage, faces, 1.1, 4);

    for (size_t i = 0; i < faces.size(); ++i) {
        Rect face = faces[i];
        Mat detectedFace = grayImage(face);

        string filename = "detected_faces/detected_face_" + to_string(i) + ".jpg";
        imwrite(filename, detectedFace);

        cout << "Face " << i + 1 << " Detected at: " << face.x << ", " << face.y << endl;
        rectangle(image, face, Scalar(255, 0, 0), 2);
    }

    //imshow("Detected Faces", image);
    //waitKey(0);
}

void recognizeFaces() {
    Mat newImage = imread("test/test_img.jpeg");
    if (newImage.empty()) {
        cerr << "Error: Unable to load the new photo" << endl;
        return;
    }

    for (const auto& entry : fs::directory_iterator("detected_faces")) {
        if (entry.is_regular_file()) {
            Mat detectedFace = imread(entry.path().string());
            if (detectedFace.empty()) {
                cerr << "Error: Unable to load detected face " << entry.path() << endl;
                continue;
            }

            if (areFacialFeaturesMatching(detectedFace, newImage)) {
                cout << "Match found: Detected face in " << entry.path() << " matches the new photo" << endl;
                return;
            }
        }
    }

    cout << "No match found: The new photo does not match any detected faces" << endl;
}

int main() {
    captureFacesAndStore();
    recognizeFaces();
    return 0;
}
