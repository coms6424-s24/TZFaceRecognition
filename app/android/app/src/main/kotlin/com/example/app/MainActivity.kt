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
                        // Handle image data here
                        // Send it to the TEE or perform any other processing
                        println("Success!!!!!!!!!!!!!!!!!!!!!")
                        println("Image Data: ")
                        println(imageData)

                        result.success(null) // Indicate success back to Flutter
                    } else {
                        println("NO Success!!!!!!!!!!!!!!!!!!!!!")

                        result.error("INVALID_DATA", "Image data is null", null)
                    }
                } else {
                    result.notImplemented()
                }
            }
    }
}
