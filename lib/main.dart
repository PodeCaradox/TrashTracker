

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:trashtracker/TakePictureScreen.dart';

import 'Profile.dart';
Map<int, Color> color ={50:Color.fromRGBO(230,234,237, .1),100:Color.fromRGBO(230,234,237, .2),200:Color.fromRGBO(230,234,237, .3),300:Color.fromRGBO(230,234,237, .4),400:Color.fromRGBO(230,234,237, .5),500:Color.fromRGBO(230,234,237, .6),600:Color.fromRGBO(230,234,237, .7),700:Color.fromRGBO(230,234,237, .8),800:Color.fromRGBO(230,234,237, .9),900:Color.fromRGBO(230,234,237, 1),};
Future<void> main() async {
  // Obtain a list of the available cameras on the device.
  final cameras = await availableCameras();

  // Get a specific camera from the list of available cameras.
  final firstCamera = cameras.first;

  runApp(
    
    MaterialApp(
      theme: new ThemeData(
  primarySwatch: MaterialColor(0xFFE6EAED,color),
  accentTextTheme: TextTheme(
    body2: TextStyle( color: Colors.white),),
  primaryTextTheme: TextTheme(
    title: TextStyle(
      color: Colors.white
    )
  )),
      home: StartScreen(
        // Pass the appropriate camera to the TakePictureScreen widget.
        camera: firstCamera,
      ),
    ),
  );
}

// A screen that allows users to take a picture using a given camera.

class StartScreen extends StatefulWidget {
  StartScreen({Key key, this.camera}) : super(key: key);
   final CameraDescription camera;

  @override
  StartScreenState createState() => StartScreenState();
}

class StartScreenState extends State<StartScreen> with SingleTickerProviderStateMixin {


AnimationController rotationController;
  Animation animation;
  int currentState = 0;

  @override
  void initState() {
 
    super.initState();
   rotationController = AnimationController(duration: const Duration(milliseconds: 1500), vsync: this);
  rotationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.transparent,
  ));
    return 
     Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.indigo[300],
        actions: <Widget>[
          IconButton(icon: Icon(Icons.person),
          color: Colors.white,
              onPressed: () {
                Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Profile(),
              ),
            );
              },)
        ],
        iconTheme: IconThemeData(color: Colors.white),
        title: Text("Trash Tracker",style: TextStyle(color: Colors.white)),
      ),
      body: Container(
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
      child: Center(
        child: Align(
        
        child: Column(
           mainAxisAlignment: MainAxisAlignment.center,
  crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
          
RotationTransition(
          
          turns: Tween(begin: 0.0, end: 1.0).animate(rotationController),
          child: new SizedBox(
            width: 100,
            height: 100,
            child:FlatButton (
            
          onPressed: () {
        Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TakePictureScreen(camera: widget.camera),
              ),
            );


          },
          child: new Icon(
            Icons.delete,
            color: Colors.white,
            size: 60.0,
          ),
          shape: new CircleBorder(
            side: BorderSide(color: Colors.white)
          
          ),

          ),
        ),
        ),
        SizedBox(height: 20),
Text('Klicke auf das Müll Icon.'
,style: TextStyle(color: Colors.white,fontSize: 20)),
        ],),
        
        
        alignment: Alignment.center,
        )
      ),
    ),
     );
  }
}
