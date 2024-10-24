import 'package:flutter/material.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

class MilkQualityScreen extends StatefulWidget {
  @override
  _MilkQualityScreenState createState() => _MilkQualityScreenState();
}

class _MilkQualityScreenState extends State<MilkQualityScreen> {
  late Interpreter _interpreter;
  final _pHController = TextEditingController();
  final _temperatureController = TextEditingController();
  final _colourController = TextEditingController();

  String _result = "Unknown";

  // Min and max values for scaling (replace with actual values)
  final minValues = [3.0, 34.0, 240.0];
  final maxValues = [9.5, 90.0, 255.0];

  @override
  void initState() {
    super.initState();
    _loadModel();
  }

  @override
  void dispose() {
    _interpreter.close();
    super.dispose();
  }

  // Load the TensorFlow Lite model
  Future<void> _loadModel() async {
    try {
      _interpreter = await Interpreter.fromAsset("assets/Qneural_network_model.tflite");
      print('Model loaded successfully');
    } catch (e) {
      print('Failed to load model.');
    }
  }

  // Min-Max Scaler
  double _scaleValue(double value, int index) {
    return (value - minValues[index]) / (maxValues[index] - minValues[index]);
  }

  // Function to handle prediction
  void _predictMilkQuality() {
    final pH = double.parse(_pHController.text);
    final temperature = double.parse(_temperatureController.text);
    final colour = double.parse(_colourController.text);

    final scaledPH = _scaleValue(pH, 0);
    final scaledTemperature = _scaleValue(temperature, 1);
    final scaledColour = _scaleValue(colour, 2);

    final tasteTrue = _tasteGroup == "true" ? 1.0 : 0.0;
    final tasteFalse = 1.0 - tasteTrue;

    final odorTrue = _odorGroup == "true" ? 1.0 : 0.0;
    final odorFalse = 1.0 - odorTrue;

    final fatTrue = _fatGroup == "true" ? 1.0 : 0.0;
    final fatFalse = 1.0 - fatTrue;

    final turbidityTrue = _turbidityGroup == "true" ? 1.0 : 0.0;
    final turbidityFalse = 1.0 - turbidityTrue;

    // Prepare input for the model
    var input = [
      [
        scaledPH,
        scaledTemperature,
        scaledColour,
        tasteTrue,
        tasteFalse,
        odorTrue,
        odorFalse,
        fatTrue,
        fatFalse,
        turbidityTrue,
        turbidityFalse
      ]
    ];

    // Allocate memory for the output (size of 1x3)
    var output = List.filled(3, 0.0).reshape([1, 3]);

    // Run inference
    _interpreter.run(input, output);

    // Get the predicted quality
    setState(() {
      _result = _getLabel(
          output[0].indexOf(output[0].reduce((double curr, double next) => curr > next ? curr : next)));
    });
  }

  // Map model output to human-readable label
  String _getLabel(int index) {
    switch (index) {
      case 0:
        return 'Low';
      case 1:
        return 'Medium';
      case 2:
        return 'High';
      default:
        return 'Unknown';
    }
  }

  String _tasteGroup = "true";
  String _odorGroup = "true";
  String _fatGroup = "true";
  String _turbidityGroup = "true";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Milk Quality Prediction'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              TextField(
                controller: _pHController,
                decoration: InputDecoration(labelText: 'pH'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: _temperatureController,
                decoration: InputDecoration(labelText: 'Temperature (°C)'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: _colourController,
                decoration: InputDecoration(labelText: 'Colour'),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 16),
              Text('Taste:'),
              RadioListTile(
                title: Text('True'),
                value: "true",
                groupValue: _tasteGroup,
                onChanged: (value) {
                  setState(() {
                    _tasteGroup = value.toString();
                  });
                },
              ),
              RadioListTile(
                title: Text('False'),
                value: "false",
                groupValue: _tasteGroup,
                onChanged: (value) {
                  setState(() {
                    _tasteGroup = value.toString();
                  });
                },
              ),
              Text('Odor:'),
              RadioListTile(
                title: Text('True'),
                value: "true",
                groupValue: _odorGroup,
                onChanged: (value) {
                  setState(() {
                    _odorGroup = value.toString();
                  });
                },
              ),
              RadioListTile(
                title: Text('False'),
                value: "false",
                groupValue: _odorGroup,
                onChanged: (value) {
                  setState(() {
                    _odorGroup = value.toString();
                  });
                },
              ),
              Text('Fat:'),
              RadioListTile(
                title: Text('True'),
                value: "true",
                groupValue: _fatGroup,
                onChanged: (value) {
                  setState(() {
                    _fatGroup = value.toString();
                  });
                },
              ),
              RadioListTile(
                title: Text('False'),
                value: "false",
                groupValue: _fatGroup,
                onChanged: (value) {
                  setState(() {
                    _fatGroup = value.toString();
                  });
                },
              ),
              Text('Turbidity:'),
              RadioListTile(
                title: Text('True'),
                value: "true",
                groupValue: _turbidityGroup,
                onChanged: (value) {
                  setState(() {
                    _turbidityGroup = value.toString();
                  });
                },
              ),
              RadioListTile(
                title: Text('False'),
                value: "false",
                groupValue: _turbidityGroup,
                onChanged: (value) {
                  setState(() {
                    _turbidityGroup = value.toString();
                  });
                },
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _predictMilkQuality,
                child: Text('Predict Milk Quality'),
              ),
              SizedBox(height: 16),
              Text('Predicted Milk Quality: $_result'),
            ],
          ),
        ),
      ),
    );
  }
}
