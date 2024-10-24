
// import 'package:flutter/material.dart';
// import 'package:tflite/tflite.dart';
// import 'dart:typed_data';
// import 'package:tflite/tflite.dart';


// class MilkQualityPredictor {
//   List<double> minValues = [3.0, 34.0, 240.0];
//   List<double> maxValues = [9.5, 90.0, 255.0];

//   Future<void> loadModel() async {
//     try {
//       String? res = await Tflite.loadModel(
//         model: "assets/Qneural_network_model.tflite",
//       );
//       print("Model loaded: $res");
//     } catch (e) {
//       print("Error loading model: $e");
//     }
//   }

//   double scale(double value, int index) {
//     return (value - minValues[index]) / (maxValues[index] - minValues[index]);
//   }

// Future<String> predict(List<double> input) async {
//   try {
//     // Convert the input list of doubles to a Float32List
//     Float32List floatList = Float32List.fromList(input);
    
//     // Convert Float32List to Uint8List as required by TFLite
//     Uint8List byteBuffer = floatList.buffer.asUint8List();

//     // Run model on the buffer
//     var output = await Tflite.runModelOnFrame(
      
//       numResults: 3,  // Number of output categories
//       threshold: 0.1, bytesList: [], // Confidence threshold
//     );

//     if (output != null && output.isNotEmpty) {
//       var maxIndex = output[0]['index'];
//       return getLabel(maxIndex); // Assuming you have a function to get the label
//     }
//     return "Unknown";
//   } catch (e) {
//     print("Error running model: $e");
//     return "Error";
//   }
// }


//   String getLabel(int index) {
//     switch (index) {
//       case 0:
//         return "Low";
//       case 1:
//         return "Medium";
//       case 2:
//         return "High";
//       default:
//         return "Unknown";
//     }
//   }
// }
