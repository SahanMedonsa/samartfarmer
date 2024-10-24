import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;
import 'package:tflite_flutter/src/interpreter_options.dart'; 

class MilkProductionScreen extends StatefulWidget {
  @override
  _MilkProductionScreenState createState() => _MilkProductionScreenState();
}

class _MilkProductionScreenState extends State<MilkProductionScreen> {
  late Interpreter interpreter;

  // Define Min-Max Scaler parameters for each continuous variable
  final List<double> minValues = [0, 0, 0, 0, 0, 0];  // Replace with actual min values
  final List<double> maxValues = [100, 100, 100, 100, 100, 100];  // Replace with actual max values

  final TextEditingController weatherController = TextEditingController();
  final TextEditingController climateController = TextEditingController();
  final TextEditingController feedQualityController = TextEditingController();
  final TextEditingController accommodationController = TextEditingController();
  final TextEditingController speciesController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController milkingFrequencyController = TextEditingController();
  final TextEditingController healthController = TextEditingController();
  final TextEditingController dryPeriodController = TextEditingController();

  late Interpreter _interpreter;

  String predictedProduction = 'Predicted Milk Production will be shown here.';

  @override
  void initState() {
    super.initState();
    _loadModel();
  }

  @override
  void dispose() {
    weatherController.dispose();
    climateController.dispose();
    feedQualityController.dispose();
    accommodationController.dispose();
    speciesController.dispose();
    ageController.dispose();
    milkingFrequencyController.dispose();
    healthController.dispose();
    dryPeriodController.dispose();
    interpreter.close();
    super.dispose();
  }

   // Load the TensorFlow Lite model
Future<void> _loadModel() async {
  try {
    // Simply load the model without adding FlexDelegate
    _interpreter = await Interpreter.fromAsset(
      "assets/milk_production_lstm_modelbest.tflite",
    );
    print('Model loaded successfully');
  } catch (e) {
    print('Failed to load model: $e');
  }
}


  Future<void> predictMilkProduction() async {
    String weather = weatherController.text;
    String climate = climateController.text;
    double feedQuality = double.tryParse(feedQualityController.text) ?? 0.0;
    double accommodation = double.tryParse(accommodationController.text) ?? 0.0;
    String species = speciesController.text;
    double age = double.tryParse(ageController.text) ?? 0.0;
    double milkingFrequency = double.tryParse(milkingFrequencyController.text) ?? 0.0;
    double health = double.tryParse(healthController.text) ?? 0.0;
    double dryPeriod = double.tryParse(dryPeriodController.text) ?? 0.0;

    // One-hot encoding for 'Weather', 'Climate', and 'Species'
    List<double> weatherEncoded = oneHotEncode(weather, {'Cold': 0, 'Hot': 1, 'Mild': 2}, 3);
    List<double> climateEncoded = oneHotEncode(climate, {'Arid': 0, 'Temperate': 1, 'Tropical': 2}, 3);
    List<double> speciesEncoded = oneHotEncode(species, {'Holstein': 1, 'Jersey': 2, 'Guernsey': 0}, 3);

    // Scale the continuous values
    double scaledFeedQuality = scaleValue(feedQuality, 0);
    double scaledAccommodation = scaleValue(accommodation, 1);
    double scaledAge = scaleValue(age, 2);
    double scaledMilkingFrequency = scaleValue(milkingFrequency, 3);
    double scaledHealth = scaleValue(health, 4);
    double scaledDryPeriod = scaleValue(dryPeriod, 5);

    // Prepare the final input array for the model
    List<double> inputArray = [
      scaledFeedQuality, scaledAccommodation, scaledAge, scaledMilkingFrequency,
      scaledHealth, scaledDryPeriod, ...weatherEncoded, ...climateEncoded, ...speciesEncoded
    ];

    var inputBuffer = Float32List.fromList(inputArray).buffer.asByteData();
    var outputBuffer = Float32List(1).buffer.asByteData();

    // Run the model
    interpreter.run(inputBuffer, outputBuffer);

    // Get the prediction result
    double prediction = outputBuffer.getFloat32(0, Endian.little);
    setState(() {
      predictedProduction = "Predicted Milk Production: ${prediction.toStringAsFixed(2)} Liters";
    });
  }

  List<double> oneHotEncode(String value, Map<String, int> map, int numClasses) {
    List<double> oneHotArray = List.filled(numClasses, 0.0);
    int? index = map[value];
    if (index != null) {
      oneHotArray[index] = 1.0;
    }
    return oneHotArray;
  }

  double scaleValue(double value, int index) {
    return (value - minValues[index]) / (maxValues[index] - minValues[index]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Milk Production Prediction'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: weatherController,
              decoration: InputDecoration(labelText: 'Weather (e.g., Cold, Hot, Mild)'),
            ),
            TextField(
              controller: climateController,
              decoration: InputDecoration(labelText: 'Climate (e.g., Arid, Temperate, Tropical)'),
            ),
            TextField(
              controller: feedQualityController,
              decoration: InputDecoration(labelText: 'Feed Quality'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: accommodationController,
              decoration: InputDecoration(labelText: 'Accommodation'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: speciesController,
              decoration: InputDecoration(labelText: 'Species (e.g., Holstein, Jersey, Guernsey)'),
            ),
            TextField(
              controller: ageController,
              decoration: InputDecoration(labelText: 'Age'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: milkingFrequencyController,
              decoration: InputDecoration(labelText: 'Milking Frequency'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: healthController,
              decoration: InputDecoration(labelText: 'Health'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: dryPeriodController,
              decoration: InputDecoration(labelText: 'Dry Period'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: predictMilkProduction,
              child: Text('Predict Milk Production'),
            ),
            SizedBox(height: 20),
            Text(
              predictedProduction,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
