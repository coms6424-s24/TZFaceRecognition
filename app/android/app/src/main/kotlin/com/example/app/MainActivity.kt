package com.example.app
import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugin.common.MethodChannel
import android.util.Log

class MainActivity : FlutterActivity() {
    private val CHANNEL = "tee_channel"
    private val TAG = "MainActivity"

    // Add the following line to load the JNI library
    companion object {
        init {
            //System.loadLibrary("tee_jni") // Load the JNI library
            //uncomment this to use the tee_jni 
            //this is prob not setup the correct way
        }
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        MethodChannel(flutterEngine!!.dartExecutor.binaryMessenger, CHANNEL)
            .setMethodCallHandler { call, result ->
                if (call.method == "processImageData") {
                    val imageData = call.argument<ByteArray>("data")
                    if (imageData != null) {
                        Log.d(TAG, "Received image data from Flutter: size=${imageData.size}")

                        // Call JNI function to send image data to TEE
                        sendImageToTEE(imageData)

                        result.success(null) // Indicate success back to Flutter
                    } else {
                        Log.e(TAG, "Received null image data from Flutter")
                        result.error("INVALID_DATA", "Image data is null", null)
                    }
                } else {
                    result.notImplemented()
                }
            }
    }

    // Define the JNI function to send image data to TEE
    private external fun sendImageToTEE(data: ByteArray)

    // Other methods
}
