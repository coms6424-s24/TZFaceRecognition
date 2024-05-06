package com.example.facerecognition_flutter

import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import android.util.Log
import android.content.Context
import android.content.SharedPreferences

class MainActivity : FlutterActivity() {
    private val CHANNEL = "tee_channel"
    private val TAG = "MainActivity"

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        MethodChannel(flutterEngine!!.dartExecutor.binaryMessenger, CHANNEL)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "processImageData" -> {
                        val imageData = call.argument<ByteArray>("data")
                        if (imageData != null) {
                            Log.d(TAG, "Image data received. Size: ${imageData.size}")
                            sendImageToTEE(imageData)
                            result.success(null) // Indicate success back to Flutter
                        } else {
                            Log.e(TAG, "Image data is null")
                            result.error("INVALID_DATA", "Image data is null", null)
                        }
                    }
                    "processSignIn" -> {
                        val imageData = call.argument<ByteArray>("data")
                        if (imageData != null) {
                            Log.d(TAG, "Sign-in image data received. Size: ${imageData.size}")
                            val isUserRegistered = signIn(imageData)
                            result.success(if (isUserRegistered) 1 else 0)
                        } else {
                            Log.e(TAG, "Sign-in image data is null")
                            result.error("INVALID_DATA", "Sign-in image data is null", null)
                        }
                    }
                    else -> result.notImplemented()
                }
            }
    }

    private fun writeToSecureStorage(context: Context, data: ByteArray) {
        val sharedPreferences: SharedPreferences = context.getSharedPreferences("secure_storage", Context.MODE_PRIVATE)
        val encodedData = android.util.Base64.encodeToString(data, android.util.Base64.DEFAULT)
        val editor = sharedPreferences.edit()
        editor.putString("imageData", encodedData)
        editor.apply()
        Log.d(TAG, "Image data written to secure storage")
    }

    private fun sendImageToTEE(imageData: ByteArray) {
        Log.d(TAG, "Sending image data to TEE")
        // Call your TEE function here
        // After processing in TEE, write the image data to secure storage
        writeToSecureStorage(this, imageData)
    }

    private fun signIn(imageData: ByteArray): Boolean {
        //  sign-in logic here
        // check if the user is registered by comparing the image data with stored data
        // Return true if the user is registered, false otherwise
        return false // Dummy implementation or return true
    }
}
