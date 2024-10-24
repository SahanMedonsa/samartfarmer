import 'package:flutter/material.dart';
import 'package:iskole/pages/diseasefind.dart';
import 'package:iskole/pages/milkproduction.dart';
import 'package:iskole/pages/milkquality.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
       return Scaffold(
        
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text('Smart Farmer'),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage("assets/cowwall.png"), fit: BoxFit.cover)
        ),
        child: Column(
          
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            
            ElevatedButton(
              onPressed: () {
              //   Navigator.push(
              //     context,
              //     MaterialPageRoute(builder: (context) => DiseaseFinderActivity()),
              //  );
              },
              child: Text('Go to Disease Finder'),
            ),
            SizedBox(height: 16), // Space between buttons
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MilkProductionScreen()),
                );
              },
              child: Text('Go to Milk Production'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MilkQualityScreen()),
                );
              },
              child: Text('Go to Milk Quality'),
            ),
          ],
        ),
      ),
    );
  }
}
