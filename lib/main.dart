import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:photodit/main1.dart';

void main() {
  runApp(MaterialApp(
    home: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  void handleButtonPress() {
    print('User wants to add an image');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(0, 63, 113, 170),
        title: Text(
          'PhotoDit',
          style: TextStyle(fontSize: 24.0),
        ),
        centerTitle: true,
      ),
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/bgpic1.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Welcome to PhotoDit',
                style: TextStyle(
                  fontSize: 40.0,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => MyApp1()));
                },
                child: Text(
                  'Start Editing',
                  style: TextStyle(color: Colors.white),
                ),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                    Color.fromARGB(255, 63, 113, 170),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
