import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
  }

Map<int, int> levelMap = {
  1: 10,
  2: 20,
  3: 40,
  4: 70,
  5: 110,
  6: 160,
  7: 220,
  8: 290,
  9: 370,
  10: 460,
  };

class _ProfileState extends State<Profile> {
int level = 1;
int experience = 0;

  @override
  Widget build(BuildContext context) {
   
     return Scaffold(
      appBar: AppBar(
         elevation: 0.0,
        backgroundColor: Colors.indigo[300],
        iconTheme: IconThemeData(color: Colors.white),
        title: Text('Kategorisierung')),
      // The image is stored as a file on the device. Use the `Image.file`
      // constructor with the given path to display the image.
      body:Container(
      // Add box decoration
      decoration: BoxDecoration(
        // Box decoration takes a gradient
        gradient: LinearGradient(
          // Where the linear gradient begins and ends
          begin: Alignment.topCenter,
          end: Alignment.bottomLeft,
          // Add one stop for each color. Stops should increase from 0 to 1
          stops: [0.1, 0.5, 0.7, 0.9],
          colors: [
            // Colors are easy thanks to Flutter's Colors class.
            Colors.indigo[300],
            Colors.indigo[600],
            Colors.indigo[700],
            Colors.indigo[900],
          ],
        ),
      ),
      child: 
      FutureBuilder(
future: _read(),
builder: (BuildContext context, AsyncSnapshot snapshot) {
  switch (snapshot.connectionState) {
      case ConnectionState.none:
        return Text('Press button to start.');
      case ConnectionState.active:
      case ConnectionState.waiting:
        return Text('Awaiting result...');
      case ConnectionState.done:
        if (snapshot.hasError)
          return Text('Error: ${snapshot.error}');
       return Center(  
         child: Align(alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          new Text('Dein aktuells Level:',style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0, color: Colors.white) ),
                new CircularPercentIndicator(
                radius: 180.0,
                animation: true,
                animationDuration: 1200,
                lineWidth: 15.0,
                percent: 1,
                startAngle: 0,
                center: new Text(
                  "Level "+level.toString(),
                  style:
                      new TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0, color: Colors.white),
                ),
                circularStrokeCap: CircularStrokeCap.butt,
                backgroundColor: Colors.grey,
                progressColor: Colors.blue,
              ),

      ],
      ),
      )
      );
    }
    return null; // unreachable
  },
       )
      ));
  }

_read() async {
        final prefs = await SharedPreferences.getInstance();
        final key = 'experience';
        experience = prefs.getInt(key) ?? 0;
        final key1 = 'level';
        level = prefs.getInt(key1) ?? 0;
      }

}




