// import 'dart:io';
// import 'dart:math';
// import 'dart:typed_data';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:image/image.dart' as img; 
// import 'package:tflite_flutter/tflite_flutter.dart';


// class DiseaseFinderActivity extends StatefulWidget {
//   @override
//   _DiseaseFinderActivityState createState() => _DiseaseFinderActivityState();
// }

// class _DiseaseFinderActivityState extends State<DiseaseFinderActivity> {
//   late Interpreter interpreter;
//   final categories = ['Lumpy Skin', 'Normal Skin'];
//   final imgSize = 64;
//   String predictionResult = '....................';
//   File? _image;
//   final picker = ImagePicker();

//   @override
//   void initState() {
//     super.initState();
//     loadModel();
//   }

//   Future<void> loadModel() async {
//     try {
//       interpreter = await Interpreter.fromAsset("assets/cow1_lump_classification_model_v2.tflite");
//         print('Model loaded successfully');
//     } catch (e) {
//       print("Failed to load model: $e");
//     }
//   }

//   Future<void> classifyDisease(File imageFile) async {
//     var imageBytes = await imageFile.readAsBytes();
//     var imgImage = img.decodeImage(Uint8List.fromList(imageBytes))!;  // Decode image using image package
//     var resizedImage = img.copyResize(imgImage, width: imgSize, height: imgSize);  // Resize image
//     var input = imageToByteBuffer(resizedImage);

//     var output = List.filled(2, 0.0).reshape([1, 2]);
//     interpreter.run(input, output);

//     int predictedIndex = output[0].indexOf(output[0].reduce(max));
//     setState(() {
//       predictionResult = "Your Cow has: ${categories[predictedIndex]}";
//     });
//   }

//   Uint8List imageToByteBuffer(img.Image image) {
//     var buffer = Uint8List(4 * imgSize * imgSize * 3);  // Image buffer to store pixel data
//     for (int y = 0; y < imgSize; y++) {
//       for (int x = 0; x < imgSize; x++) {
//         var pixel = image.getPixel(x, y);  // Use getPixel() from the image package
//         buffer[(y * imgSize + x) * 3 + 0] = (pixel >> 16) & 0xFF;  // Red
//         buffer[(y * imgSize + x) * 3 + 1] = (pixel >> 8) & 0xFF;   // Green
//         buffer[(y * imgSize + x) * 3 + 2] = pixel & 0xFF;          // Blue
//       }
//     }
//     return buffer;
//   }

//   Future<void> _pickImage() async {
//     final pickedFile = await picker.pickImage(source: ImageSource.gallery);
//     setState(() {
//       _image = File(pickedFile!.path);
//     });
//     classifyDisease(_image!);
//   }

//   Future<void> _takePicture() async {
//     final pickedFile = await picker.pickImage(source: ImageSource.camera);
//     setState(() {
//       _image = File(pickedFile!.path);
//     });
//     classifyDisease(_image!);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Disease Finder"),
//       ),
//       body: Column(
//         children: [
//           _image != null
//               ? Image.file(_image!, height: 300)
//               : Container(
//                   height: 300,
//                   color: Colors.grey[200],
//                   child: Icon(Icons.image, size: 100),
//                 ),
//           SizedBox(height: 20),
//           Text(
//             predictionResult,
//             style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//           ),
//           SizedBox(height: 20),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               ElevatedButton(
//                 onPressed: _pickImage,
//                 child: Text("Select Image"),
//               ),
//               SizedBox(width: 20),
//               ElevatedButton(
//                 onPressed: _takePicture,
//                 child: Text("Open Camera"),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
