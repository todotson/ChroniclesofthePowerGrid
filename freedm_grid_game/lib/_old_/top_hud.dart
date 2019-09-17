import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:freedm_grid_game/interface.dart';

class TopHUD extends StatelessWidget {
  final double width, height, textScale;
  GameInterface game;

  TopHUD({Key key, this.game, this.width, this.height, this.textScale}) : super(key: key);

  List<DropdownMenuItem<int>> menuDrop = [];
  void menuData() {
    menuDrop = [];
    menuDrop.add(new DropdownMenuItem(
      child: new Text('Save'),
      value: 1,
    ));

    menuDrop.add(new DropdownMenuItem(
      child: new Text('Load'),
      value: 2,
    ));

    menuDrop.add(new DropdownMenuItem(
      child: new Text('Settings'),
      value: 3,
    ));

    menuDrop.add(new DropdownMenuItem(
      child: new Text('Exit'),
      value: 4,
    ));
  }

  @override
  Widget build(BuildContext context) {
    menuData();
    return Scaffold(

      body: new Container(
        decoration: new BoxDecoration(
          shape: BoxShape.rectangle,
          color: Colors.blueGrey,
        ),
        alignment: Alignment.topCenter,
        child: Row(
          children: <Widget>[
            new AspectRatio(
                aspectRatio: (this.width*5.2) / (this.height),
                child: Column(
                    children: <Widget>[

                      new AspectRatio(
                        aspectRatio: (this.width*2.0) / (this.height*0.188),
                        child: Text(' ',
                            style: new TextStyle(
                              fontSize: (14.0*this.textScale),
                            )
                        ),
                      ),

                      // Notifications alert button.
                      new AspectRatio(
                          aspectRatio: (this.width*2.0) / (this.height*0.195),
                          child: FlatButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) => _buildAboutDialog(context),
                              );
                            },
                            color: Colors.green,
                            child: Text("Notifications",
                                style: new TextStyle(
                                  fontSize: (14.0*this.textScale),
                                )),
                          )
                      )
                    ]
                )
            ),


            // Money and Date information.
            new AspectRatio(
              aspectRatio: (this.width*2.0) / (this.height),
              child: Padding(
                padding: EdgeInsets.fromLTRB(20.0, 12.0, 0.0, 5.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[

                    new AspectRatio(
                      aspectRatio: (this.width*1.0) / (this.height*0.21),
                      child: Text('\$' + game.money.toString() + 'M',
                          style: new TextStyle(
                            fontSize: (14.0*this.textScale),
                          )
                      ),
                    ),

                    new AspectRatio(
                      aspectRatio: (this.width*1.0) / (this.height*0.01),
                      child: Text(game.year.toString(),
                          style: new TextStyle(
                            fontSize: (14.0*this.textScale),
                          )),
                    ),

                  ],
                ),
              ),
            ),

            new AspectRatio(
                aspectRatio: (this.width*2.8) / (this.height*1.0),
                child: Stack(
                    alignment: Alignment.center,
                    children: <Widget>[

                      new AspectRatio(
                          aspectRatio: (this.width*2.0) / (this.height*1.0),
                          child: Padding(
                              padding: EdgeInsets.fromLTRB(8.0, 0.0, 0.0, 0.0),
                              child: Card(
                                child: Icon(Icons.menu),
                              )
                          )
                      ),

                      // Game drop down menu.
                      new AspectRatio(
                        aspectRatio: (this.width) / (this.height*0.4),
                        child: DropdownButtonHideUnderline(
                            child: DropdownButton(
                              items: menuDrop,
                              onChanged: (value) => value++,
                              iconSize: 0.0,
                            )
                        ),
                      ),
                    ]
                )
            ),


          ],
        ),
      ),
    );
  }
}

Widget _buildAboutDialog(BuildContext context) {
  return new AlertDialog(
    title: const Text('Notifications'),
    content: new Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        //_buildAboutText(),
        _buildLogoAttribution(),
      ],
    ),
    actions: <Widget>[
      new FlatButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        textColor: Theme.of(context).primaryColor,
        child: const Text('Ok'),
      ),
    ],
  );
}

Widget _buildLogoAttribution() {
  return new Padding(
    padding: const EdgeInsets.only(top: 16.0),
    child: new Row(
      children: <Widget>[
        new Padding(
          padding: const EdgeInsets.only(top: 0.0),
          child: new Image.asset(
            "assets/coal_power_plant.png",
            width: 32.0,
          ),
        ),
        const Expanded(
          child: const Padding(
            padding: const EdgeInsets.only(left: 12.0),
            child: const Text(
              'You can buy a new type of generator!',
              style: const TextStyle(fontSize: 12.0),
            ),
          ),
        ),
      ],
    ),
  );
}