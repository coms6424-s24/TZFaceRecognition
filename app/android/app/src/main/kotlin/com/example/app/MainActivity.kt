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


    //private fun sendImageToTEE(imageData: ByteArray, size: Int) {
         //print("we are now in sendImagetoTEEE function  ")
        //print(size)
        // try {
        //     // Initialize the GlobalPlatform API
        //     val omapi = OMApec.getOMApecInstance()
    
        //     // Open a session with the secure element
        //     val session = omapi.openSession()
    
        //     // Select the Trusted Application (TA) within the TEE
        //     val aid = byteArrayOf(/* TA AID */)
        //     val selectCommand = CommandAPDU(CommandAPDU.SELECT, 0x04, 0x00, 0x00, aid)
        //     val response = session.transmit(selectCommand)
        //     if (response.sw1 != CommandAPDU.SUCCESS || response.sw2 != CommandAPDU.SUCCESS) {
        //         throw Exception("Failed to select TA")
        //     }
    
        //     // Prepare the data to send
        //     val dataToSend = ByteArray(size + 4)
        //     // First 4 bytes represent the size of the data
        //     dataToSend[0] = (size shr 24).toByte()
        //     dataToSend[1] = (size shr 16).toByte()
        //     dataToSend[2] = (size shr 8).toByte()
        //     dataToSend[3] = size.toByte()
        //     // Copy image data into the rest of the array
        //     System.arraycopy(imageData, 0, dataToSend, 4, size)
    
        //     // Send image data to the TA
        //     val dataCommand = CommandAPDU(CommandAPDU.DATA, 0x00, 0x00, 0x00, dataToSend)
        //     val responseData = session.transmit(dataCommand)
    
        //     // Process response from the TA
        //     // Handle response data...
    
        //     // Close the session with the secure element
        //     session.close()
    
        // } catch (e: Exception) {
        //     e.printStackTrace()
        // }
    //}
    
    