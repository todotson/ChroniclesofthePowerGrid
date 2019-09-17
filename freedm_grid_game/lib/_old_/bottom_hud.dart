import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class BottomHUD extends StatelessWidget {
  static const double genIconMult = 13.0;
  final double width, height, textScale;
  BottomHUD({Key key, this.width, this.height, this.textScale}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    int numNuclear = 0;
    int numNaturalGas = 0;
    int numSolar = 0;
    int numHydro = 0;
    int numCoal = 0;



    return Scaffold(
      body: new Container(
        decoration: new BoxDecoration(
          shape: BoxShape.rectangle,
          color: Colors.blueGrey,
        ),
        alignment: Alignment.topCenter,
        child: Row(
          children: <Widget>[

            // The buttons on the bottom hud.
            new AspectRatio(
                aspectRatio: (this.width*6.66) / (this.height),
                child: Row(
                    children: <Widget>[

                    // Stats for how many generators owned.
                      new AspectRatio(
                        aspectRatio: (this.width) / (this.height*.3),
                        child: Column(
                            children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      Text("                    Gen: ",
                                      style: new TextStyle(
                                        fontSize: (genIconMult*this.textScale),
                                      )),
                                      Icon(
                                        Icons.warning,
                                        color: Colors.green,
                                        size: genIconMult,
                                      ),
                                      Text(" ",
                                          style: new TextStyle(
                                            fontSize: (genIconMult*this.textScale),
                                          )),
                                      Icon(
                                        Icons.invert_colors,
                                        color: Colors.yellowAccent,
                                        size: genIconMult,
                                      ),
                                      Text(" ",
                                          style: new TextStyle(
                                            fontSize: (genIconMult*this.textScale),
                                          )),
                                      Icon(
                                        Icons.wb_sunny,
                                        color: Colors.yellow,
                                        size: genIconMult,
                                      ),
                                      Text(" ",
                                          style: new TextStyle(
                                            fontSize: (13.0*this.textScale),
                                          )),
                                      Icon(
                                        Icons.local_drink,
                                        color: Colors.blue,
                                        size: genIconMult,
                                      ),
                                      Text(" ",
                                          style: new TextStyle(
                                            fontSize: (genIconMult*this.textScale),
                                          )),
                                      Icon(
                                        Icons.whatshot,
                                        color: Colors.red,
                                        size: genIconMult,
                                      ),
                                      Text("\n",
                                          style: new TextStyle(
                                            fontSize: (genIconMult*this.textScale),
                                          )),

                                    ]
                              ),
                              Text("            Owned:   $numNuclear   $numNaturalGas  $numSolar   $numHydro  $numCoal  \n",
                                  style: new TextStyle(
                                    fontSize: (genIconMult*this.textScale),),
                              )

                          ]
                        )
                      ),

                    // For separating the buttons.
                    new AspectRatio(
                      aspectRatio: (this.width*1.43) / (this.height),
                      child: Text(' ',
                          style: new TextStyle(
                            fontSize: (14.0*this.textScale),
                          )
                      ),
                    ),


                    // Next Turn button.
                    new AspectRatio(
                      aspectRatio: (this.width*1.0) / (this.height*0.53),
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                        child: ButtonTheme(
                          minWidth: (50),
                          height: (50),
                          child: FlatButton(
                            child: Column(
                                children: <Widget>[
                                  Icon(
                                    Icons.play_arrow,
                                    color: Colors.black,
                                  ),
                                  Text("Next Turn"),
                                ]
                            ),
                            onPressed: (){},
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
          ],
        ),
      ),
      ]
        )
      )
    );
  }
}