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
                        //println("Image Data: ${imageData.contentToString()}") 
                        sendImageToTEE(imageData)
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



    private fun sendImageToTEE(imageData: ByteArray) {
        //get this to work today
        // try {
        //     println("Are you Working?")
        //     // Initialize the GlobalPlatform API
        //     val omapi = OMApec.getOMApecInstance()
    
        //     val session = omapi.openSession()
    
        //     // Select the Trusted Application (TA) within the TEE
        //     val aid = byteArrayOf(/* TA AID */)
        //     val selectCommand = CommandAPDU(CommandAPDU.SELECT, 0x04, 0x00, 0x00, aid)
        //     val response = session.transmit(selectCommand)
        //     if (response.sw1 != CommandAPDU.SUCCESS || response.sw2 != CommandAPDU.SUCCESS) {
        //         throw Exception("Failed to select TA")
        //     }
    
        //     // Send image data to the TA
        //     val dataToSend = imageData // Use the image data received from Flutter
        //     val dataCommand = CommandAPDU(CommandAPDU.DATA, 0x00, 0x00, 0x00, dataToSend)
        //     val responseData = session.transmit(dataCommand)
    
        //     // Process response from the TA
        //     // Handle response data...
    
        //     // Close the session with the secure element
        //     session.close()
    
        // } catch (e: Exception) {
        //     e.printStackTrace()
        // }
    }
    
}
