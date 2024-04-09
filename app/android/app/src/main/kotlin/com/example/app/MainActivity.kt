package com.example.app

import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import java.io.FileInputStream
import java.io.FileOutputStream
import java.io.PrintWriter

class MainActivity : FlutterActivity() {

    private val FLUTTER_CHANNEL = "tee_channel"
    private val TEE_CHANNEL = "com.example.app.tee"

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        // Set up method channel to communicate with Flutter
        MethodChannel(flutterEngine!!.dartExecutor.binaryMessenger, FLUTTER_CHANNEL)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "processImageData" -> {
                        val imageData = call.argument<ByteArray>("data")
                        if (imageData != null) {
                            // Handle image data here
                            println("Workig")
                            sendDataToTEE(imageData)
                            result.success(null) // Indicate success back to Flutter
                        } else {
                            result.error("INVALID_DATA", "Image data is null", null)
                        }
                    }
                    else -> result.notImplemented()
                }
            }
    }

    private fun sendDataToTEE(data: ByteArray) {
        try {
            val pfd = openParcelFileDescriptor(TEE_CHANNEL, null)
            val fis = FileInputStream(pfd.fileDescriptor)
            val fos = FileOutputStream(pfd.fileDescriptor)
            val writer = PrintWriter(fos)

            // Send data to TEE
            sendData(writer, data)

            // Close streams
            writer.close()
            fis.close()
            fos.close()
            pfd.close()
        } catch (e: Exception) {
            e.printStackTrace()
        }
    }

    private fun sendData(writer: PrintWriter, data: ByteArray) {
        writer.println("sendData") // Method name defined in the TEE interface
        writer.println(data.size) // Send size of data
        writer.flush()

        // Write data to the stream
        writer.write(data.decodeToString())
        writer.flush()
    }
}
