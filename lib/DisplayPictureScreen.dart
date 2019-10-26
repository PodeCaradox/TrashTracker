import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as prefix0;

import 'package:geolocator/geolocator.dart';

class DisplayPictureScreen extends StatefulWidget {
  final String imagePath;
  
  DisplayPictureScreen({Key key, this.imagePath}) : super(key: key);

  @override
  _DisplayPictureScreenState createState() => _DisplayPictureScreenState();
}

enum Kategorie {
  Plastik,
  Papier,
  Oel,
  Elektroschrott,
  Bauschutt,
  ETC,
}

class _DisplayPictureScreenState extends State<DisplayPictureScreen> {

 final textController = TextEditingController();
  int actualID = -1;
  String sliderText = 'Leicht Verschmutung';
  double _sliderValue = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.blue),
        title: Text('Kategorisierung')),
      floatingActionButton: FloatingActionButton.extended(
        foregroundColor: Colors.blue,
        backgroundColor: Colors.black54,
                onPressed: (){
            apiRequest();
        },
        label: Text('Senden'),
        icon: Icon(Icons.send),

      ),
      // The image is stored as a file on the device. Use the `Image.file`
      // constructor with the given path to display the image.
      body: Padding(
        padding: EdgeInsets.all(10),
        child: 
        new Column(
          children: <Widget>[
            new Expanded(
              child:

          new GridView.count(
          crossAxisCount: 3,
          childAspectRatio: 1.0,
          padding: const EdgeInsets.all(4.0),
          mainAxisSpacing: 4.0,
          crossAxisSpacing: 4.0,
            children: <ButtonStruct>[
                new ButtonStruct(id: 0,text: 'Plastik',icon: Icons.autorenew),
                new ButtonStruct(id: 1,text: 'Papier',icon: Icons.business),
                new ButtonStruct(id: 2,text: 'Öl',icon: Icons.format_color_fill),
                new ButtonStruct(id: 3,text: 'Elektroschrott',icon: Icons.flash_on),
                new ButtonStruct(id: 4,text: 'Bauschutt',icon: Icons.account_balance),
                new ButtonStruct(id: 5,text: 'Etc.',icon: Icons.blur_circular),
           
            ].map((ButtonStruct buttonStruct) {
            return new GridTile(
                child: new RoundButton(text: buttonStruct.text, icon: buttonStruct.icon, iconColor: (buttonStruct.id != actualID)? Colors.black:Colors.blue,onPressed: () => setState(() => actualID = buttonStruct.id)));
                          }).toList()),
                            ),
                            Slider(
                              activeColor: Colors.blue,
                              inactiveColor: Colors.black,
                              min: 0,
                              max: 4,
                              divisions: 4,
                              value: _sliderValue,
                              onChanged: (double changed) => setState(() { 
                             String newText = sliderText;
                                switch (changed.toInt()){
                                case 0:
                                newText = 'Sehr Leichte Verschmutung';
                                break;
                                case 1:
                                newText = 'Leichte Verschmutung';
                                break;
                                case 2:
                                newText = 'Mittlere Verschmutung';
                                break;
                                case 3:
                                newText = 'Starke Verschmutung';
                                break;
                                case 4:
                                newText = 'Sehr Stark Verschmutung';
                                break;
                               
                                }
                                sliderText = newText;
                                _sliderValue = changed;
                                 setState(() { 
                                   sliderText = newText;
                                   _sliderValue = changed;
                                 
                                 });
                            
                                
                                }),
                              label: sliderText,
                            ),
                            RaisedButton(
                              child: Text(
                                'Beschreibung',
                                style: TextStyle(fontSize: 15)
                              ),
                              onPressed: () {
                                return showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: Text('Beschreibung'),
                                      content:  TextField(
                                          controller: textController,
                                            decoration: InputDecoration(
                                                border: InputBorder.none,
                                                hintText: 'Gebe eine Beschreibung ein'
                                              ),
                                      ),
                                      actions: <Widget>[
                                        FlatButton(
                                          child: Text('OK'),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                            ),
                         
                          SizedBox(height: 250,
                          child: Image.file(File(widget.imagePath),fit: BoxFit.scaleDown),),
                        
                          ],
                        )
                      )
                    );
                  }
     HttpClient httpClient = new HttpClient();
Future<String> apiRequest() async {
  
  String url;
  Map jsonMap;
  if(actualID!=-1){
    Position position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    File imageFile =File(widget.imagePath);
    List<int> imageBytes = imageFile.readAsBytesSync();
    String base64Image = base64.encode(imageBytes);

             url = 'http://192.168.137.6:8081/api/v1/hotspots';
             jsonMap = {
                'gpsData': {
                  'longitude': position.longitude.toString(),
                  'latitude': position.latitude.toString()
                },
                'category': Kategorie.values[actualID].toString(),
                'severity': _sliderValue,
                'description': ''+textController.text,
                'image': {
                  'fileName': DateTime.now(),
                  'fileType': prefix0.extension(widget.imagePath),
                  'data': base64Image//zurück zum main bildschirm 
                  //tippe die mülltonne zum weiterkommen
                }
              };
              

            }else{
          return showDialog<String>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Fehler'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text('Es wurde keine Kategorie ausgewählt'),
            ],
          ),
        ),
        actions: <Widget>[
          FlatButton(
            child: Text('OK'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
            }
            
  HttpClientRequest request = await httpClient.postUrl(Uri.parse(url));
  request.headers.set('content-type', 'application/json');
  request.add(utf8.encode(json.encode(jsonMap)));
  HttpClientResponse response = await request.close();
  String reply = await response.transform(utf8.decoder).join();
  httpClient.close();
  Navigator.popUntil(context, ModalRoute.withName('/'));
  return reply;
}

}

class ButtonStruct{
  ButtonStruct({this.text,this.id,this.icon});
   int id;
 String text;
  IconData icon;

}

class RoundButton extends StatelessWidget{
  RoundButton({this.text,this.icon,this.iconColor,this.onPressed});
  final String text;
  final IconData icon;
  final Color iconColor;
  final GestureTapCallback onPressed;

  @override
  Widget build(BuildContext context) {
   
    return    
    Column(
children: <Widget>[
SizedBox(
            width: 50,
            height: 50,
            child:FlatButton (
          onPressed: onPressed,
          child: new Icon(
            icon,
            color: iconColor,
            size: 20.0,
          ),
          shape: new CircleBorder(
            side: BorderSide(color: iconColor)
          ),
          )), 

          Text(text, style: TextStyle(color: iconColor),),

],
 
    );
    
  }
  
}