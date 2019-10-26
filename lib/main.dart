

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:trashtracker/TakePictureScreen.dart';
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
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.transparent,
  ));
    return 
     Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.blue),
        title: Text("Trash Tracker"),
      ),
      body: Align(
        
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
            color: Colors.black,
            size: 40.0,
          ),
          shape: new CircleBorder(
            side: BorderSide(color: Colors.black)
          
          ),

          ),
        ),
        ),
        SizedBox(height: 20),
Text('Klicke auf das Müll Icon.'),
        ],),
        
        
        alignment: Alignment.center,
        )
     );
  }
}
