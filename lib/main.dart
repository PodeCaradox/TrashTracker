

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:trashtracker/TakePictureScreen.dart';

Future<void> main() async {
  // Obtain a list of the available cameras on the device.
  final cameras = await availableCameras();

  // Get a specific camera from the list of available cameras.
  final firstCamera = cameras.first;

  runApp(
    MaterialApp(
      theme: new ThemeData(
  primarySwatch: Colors.grey,
  primaryTextTheme: TextTheme(
    title: TextStyle(
      color: Colors.blue
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
    return 
     Scaffold(
      appBar: AppBar(
        title: Text("Trash Tracker"),
      ),
      body: Align(
        
        child: RotationTransition(
          
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
            color: Colors.black,
            size: 40.0,
          ),
          shape: new CircleBorder(
            side: BorderSide(color: Colors.black)
          
          ),

          ),
        ),
        ),
        alignment: Alignment.center,
        )
     );
  }
}
