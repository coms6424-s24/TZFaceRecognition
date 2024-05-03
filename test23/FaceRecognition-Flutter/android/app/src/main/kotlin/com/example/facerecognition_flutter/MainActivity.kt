package com.example.facerecognition_flutter
import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugin.common.MethodChannel
import android.util.Log
import android.content.Context
import android.content.SharedPreferences



class MainActivity : FlutterActivity() {
    private val CHANNEL = "tee_channel"
    private  val TAG = "MainActivity"

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

    private fun writeToSecureStorage(context: Context, data: ByteArray) {
        // Initialize SharedPreferences for secure storage
        //change this to init the OPTEE context using some API- global platform or something and then send 
        val sharedPreferences: SharedPreferences = context.getSharedPreferences("secure_storage", Context.MODE_PRIVATE)
        
        // Convert the byte array to a Base64-encoded string for storage
        val encodedData = android.util.Base64.encodeToString(data, android.util.Base64.DEFAULT)
    
        // Store the encoded data in SharedPreferences
        val editor = sharedPreferences.edit()
        editor.putString("imageData", encodedData)
        editor.apply()
    
        Log.d(TAG, "Image data written to secure storage")
    }

    private fun sendImageToTEE(imageData: ByteArray, size: Int) {
        println("we are now in sendImageToTEE function")
        println("Size: $size")
        Log.d(TAG, "Sending image data to TEE")
    Log.d(TAG, "Size: ${imageData.size}")

    // Call your TEE function here
    
    // After processing in TEE, write the image data to secure storage
    writeToSecureStorage(this, imageData)
        
    }
}

    
    
