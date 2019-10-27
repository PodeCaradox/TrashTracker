import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:path/path.dart' as prefix0;
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Profile.dart';

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
        title: Text('Kategorisierung' ,style: TextStyle(color: Colors.white),)
        
        ),
        
      floatingActionButton: FloatingActionButton.extended(
        foregroundColor: Colors.white,
        backgroundColor: Colors.indigo[300],
                onPressed: (){
                   if(!disableRequest){
                    disableRequest = true;
                    apiRequest();

                   }
                   
        },
        label: Text('Senden'),
        icon: Icon(Icons.send),

      ),
      // The image is stored as a file on the device. Use the `Image.file`
      // constructor with the given path to display the image.
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
      child:Padding(
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
                child: new RoundButton(text: buttonStruct.text, icon: buttonStruct.icon, iconColor: (buttonStruct.id != actualID)? Colors.white:Colors.greenAccent,onPressed: () => setState(() => actualID = buttonStruct.id)));
                          }).toList()),
                            ),
                           SliderTheme(
                                child:Slider(
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
                              ),data: SliderTheme.of(context).copyWith(
                                activeTickMarkColor: Colors.white,
                                disabledInactiveTrackColor: Colors.white,
                                activeTrackColor: Colors.greenAccent,
                                disabledActiveTrackColor: Colors.white,
                                disabledThumbColor: Colors.white,
                                disabledInactiveTickMarkColor: Colors.white,
                                inactiveTickMarkColor: Colors.black,
                                inactiveTrackColor: Colors.white,
                                valueIndicatorColor: Colors.indigo[300],

                                overlappingShapeStrokeColor: Colors.greenAccent,
                                thumbColor: Colors.greenAccent,
                                disabledActiveTickMarkColor: Colors.white,
                              valueIndicatorTextStyle: TextStyle(color: Colors.white),
                              ),
                            ),
                            RaisedButton(
                              color: Colors.indigo[300],
                              child: Text(
                                'Beschreibung',
                                style: TextStyle(fontSize: 15,color: Colors.white)
                              ),
                              onPressed: () {
                                return showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      backgroundColor: Colors.indigo[300],
                                      title: Text('Beschreibung' ,style: new TextStyle(color: Colors.white),),
                                      content:  TextField(
                                        style: new TextStyle(color: Colors.white),
                                          controller: textController,
                                            decoration: InputDecoration(
                                                border: InputBorder.none,
                                                hintText: 'Gebe eine Beschreibung ein',
                                                hintStyle: new TextStyle(color: Colors.white),
                                                fillColor: Colors.white
                                              ),
                                      ),
                                      actions: <Widget>[
                                        FlatButton(
                                          child: Text('OK',style: new TextStyle(color: Colors.white),),
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
                    )
                    );
                  }
   
     bool disableRequest=false;






Future<http.Response> apiRequest() async {
 
  String url;
  Map jsonMap;
  if(actualID == -1){
 
disableRequest = false;
 return fehlerMeldung('Es wurde keine Kategorie ausgewählt','Fehler',true);
            }else if(textController.text == ''){
            disableRequest = false;
          return fehlerMeldung('Es wurde keine Beschreibung hinzugefügt','Fehler',true);
            }
             fehlerMeldung('Informationen werden gesendet','Information',false);
  //beschreibung
    Position position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    File imageFile =File(widget.imagePath);
    Uint8List imageBytes = imageFile.readAsBytesSync();
    String base64Image = base64.encode(imageBytes);

             url = 'http://192.168.137.6:8081/api/v1/hotspots';
             jsonMap = {
                'gpsData': {
                  'longitude': position.longitude.toString(),
                  'latitude': position.latitude.toString()
                },
                'category': Kategorie.values[actualID].toString().replaceAll('Kategorie.', ''),
                'severity': _sliderValue,
                'description': ''+textController.text,
                'image': {
                  'fileName': DateTime.now().toString(),
                  'fileType': prefix0.extension(widget.imagePath),
                  'data': base64Image//zurück zum main bildschirm 
                  //tippe die mülltonne zum weiterkommen
                }
              };
              
 try{
 
  http.post(url,
      headers: {"Content-Type": "application/json"},
      body: json.encode(jsonMap)
  ).then((http.Response response) {
    
  });
 }catch(e){
   Navigator.of(context).pop();
return fehlerMeldung('Server konnte nicht erreicht werden','Fehler',true);
 }
  await _save();
 Navigator.popUntil(context, ModalRoute.withName('/'));
  return null;
}

_save() async {
        final prefs = await SharedPreferences.getInstance();
        final key = 'experience';
        int experience = prefs.getInt(key) ?? 0;
        final key1 = 'level';
        final level = prefs.getInt(key1) ?? 0;
     
        experience++;
        prefs.setInt(key, experience);
        prefs.setInt(key1, level);
      }

      Future<Response> fehlerMeldung(String fehler,String title,bool activateButton) async {

return  showDialog<Response>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.indigo[300],
        title: Text(title,style: new TextStyle(color: Colors.white)),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text(fehler,style: new TextStyle(color: Colors.white)),
            ],
          ),
        ),
        actions: <Widget>[
          FlatButton(
            child: Text((activateButton)?'OK':'',style: new TextStyle(color: Colors.white),),
            onPressed: () {
              if(activateButton)
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );

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