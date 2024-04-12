package com.example.app

import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val CHANNEL = "tee_channel"

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        MethodChannel(flutterEngine!!.dartExecutor.binaryMessenger, CHANNEL)
            .setMethodCallHandler { call, result ->
                if (call.method == "processImageData") {
                    val imageData = call.argument<ByteArray>("data")
                    if (imageData != null) {
                        println("imageData is not null")
                        println("imageData.size: ${imageData.size}")

                        // Call sendImageToTEE function here
                        sendImageToTEE(imageData, imageData.size)

                        result.success(null) // Indicate success back to Flutter
                    } else {
                        println("imageData is null")
                        result.error("INVALID_DATA", "Image data is null", null)
                    }
                } else {
                    result.notImplemented()
                }
            }
    }

    private fun sendImageToTEE(imageData: ByteArray, size: Int) {
        println("we are now in sendImageToTEE function")
        println("Size: $size")
    }
}

    
    