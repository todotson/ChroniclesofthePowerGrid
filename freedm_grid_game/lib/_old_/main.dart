import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:freedm_grid_game/interface.dart';
import 'package:freedm_grid_game/_old_/widgets.dart';
import 'package:freedm_grid_game/_old_/top_hud.dart';
import 'package:freedm_grid_game/_old_/bottom_hud.dart';
import 'package:freedm_grid_game/frontend/graph.dart';

const String generatorIconURLBase = 'assets/_global/generator_icons/';

const Map<generatorType,String> generatorIconURLs = {
  generatorType.coal    : 'coal_power_plant.png',
  generatorType.hydro   : 'hydro_power_plant.png',
  generatorType.gas     : 'natural_gas_power_plant.png',
  generatorType.nuclear : 'nuclear_power_plant.png',
  generatorType.solar   : 'solar_power_plant.png',
  generatorType.wind    : 'wind_power_plant.png',
};

const Map<generatorType,String> generatorTypeStrings = {
  generatorType.coal    : 'Coal',
  generatorType.hydro   : 'Hydro',
  generatorType.gas     : 'Gas',
  generatorType.nuclear : 'Nuclear',
  generatorType.solar   : 'Solar',
  generatorType.wind    : 'Wind',
};



void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: GUI(),
    );
  }
}

class GUI extends StatefulWidget {
  GUI({Key key}) : super(key: key);

  @override
  _GUIState createState() => _GUIState();
}

class _GUIState extends State<GUI> {

  @override
  Widget build(BuildContext context) {

    return _MapPage();
  }
}

class _MapPage extends StatefulWidget {
  _MapPage({Key key, this.upperHUD, this.map, this.child, this.lowerHUD}) : super(key: key);
  final Widget upperHUD;
  final Widget map;
  final Widget child;
  final Widget lowerHUD;

  @override
  _MapPageState createState() => _MapPageState(GameInterface(1900));
}

class _MapPageState extends State<_MapPage> {

  GameInterface game;

  _MapPageState(this.game);

  @override
  Widget build(BuildContext context) {
    MediaQueryData queryData;
    queryData = MediaQuery.of(context);

    final upperHUD = new AspectRatio(
        aspectRatio: queryData.size.width / (queryData.size.height*0.1),
        child: TopHUD(game: game, width: queryData.size.width, height: queryData.size.height, textScale: queryData.textScaleFactor)
    );



    final map = new AspectRatio(
      aspectRatio: queryData.size.width / (queryData.size.height*0.75),
      child: Align(
          widthFactor: queryData.size.width,
          heightFactor: queryData.size.height*0.75,
          child: _StateMap(
              game: game,
              url: 'assets/mro/states/nebraska.png',
              width: queryData.size.width,
              height: queryData.size.height,
              textScale: queryData.textScaleFactor)

        /*_RegionMap(
              url: 'assets/mro/mro.png',
              width: queryData.size.width,
              height: queryData.size.height,
              textScale: queryData.textScaleFactor)*/

        /*_CountryMap(
              url: 'assets/_global/us_map.png',
              width: queryData.size.width,
              height: queryData.size.height,
              textScale: queryData.textScaleFactor)*/
      ),
    );


    final lowerHUD = new AspectRatio(
        aspectRatio: queryData.size.width / (queryData.size.height*0.15),
        child: BottomHUD(width: queryData.size.width, height: queryData.size.height, textScale: queryData.textScaleFactor)
    );

    return Scaffold(
      body: Container(
          decoration: new BoxDecoration(
            shape: BoxShape.rectangle,
            color: Colors.green,
          ),
          alignment: Alignment.bottomCenter,
          child: Row(
              children: <Widget>[
               new AspectRatio(
                aspectRatio: (queryData.size.width) / (queryData.size.height),
                child: new Container(
                  decoration: new BoxDecoration(
                    shape: BoxShape.rectangle,
                    color: Colors.black,
                  ),
                  child: Column(
                   children: <Widget>[

                     // The top hud.
                     upperHUD,

                    // The Map part of the screen.
                     map,

                     // The bottom hud.
                     lowerHUD,

                   ],
                  )
                )
               )
              ]
          )
      ),
    );
  }
}

class _StateMap extends StatefulWidget {

  GameInterface game;

  _StateMap({Key key, this.game, this.url, this.width, this.height, this.textScale}) : super(key: key);
  final double width, height, textScale;
  final String url;

  @override
  _StateMapState createState() => _StateMapState(game);
}

class _StateMapState extends State<_StateMap> {

  GameInterface game;

  _StateMapState(this.game);


  Widget _buildAboutDialog(BuildContext context, GeneratorInterface generator) {
    return new AlertDialog(
      title: const Text('Generator Statistics',
        style: const TextStyle(fontSize: 12.0),
      ),
      content: new Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildLogoAttribution(generator.asset, generatorTypeStrings[generator.type]),
          _buildAboutText(generator.name, generator.cost, generator.rating.base, generator.rating.peak, generator.description),
        ],
      ),
      actions: <Widget>[
        new FlatButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          textColor: Theme
              .of(context)
              .primaryColor,
          child: const Text('Cancel'),
        ),

        new FlatButton(
          onPressed: () {
            Navigator.of(context).pop();
            setState(() {game.buyGenerator(generator);});
          },
          textColor: Theme
              .of(context)
              .primaryColor,
          child: const Text('Buy'),
        ),
      ],
    );
  }

  Widget _buildAboutText(String name, double cost, double base, double peak, String description) {
    return new RichText(
      text: new TextSpan(
        style: const TextStyle(color: Colors.black87),
        children: <TextSpan>[
          TextSpan(text: 'Name: $name \n'),
          new TextSpan(
            text: 'Cost: $cost M\n',
          ),
          new TextSpan(
            text: 'Base/Peak: $base/$peak MW\n\n',
          ),
          new TextSpan(
            text: 'Description: $description\n',
          ),
        ],
      ),
    );
  }


  Widget _buildLogoAttribution(String assetURL, String plant) {
    return new Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: new Row(
        children: <Widget>[
          new Padding(
            padding: const EdgeInsets.only(top: 0.0),
            child: new Image.asset(
              assetURL,
              width: 64.0,
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 12.0),
              child: Text(
                '${plant} Power Plant',
                style: TextStyle(fontSize: 12.0),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData queryData;
    queryData = MediaQuery.of(context);

    double screenXOrigin = queryData.size.width*0.00025;
    double screenYOrigin = queryData.size.height*0.00035;

    List<Widget> list = <Widget>[
      // Back Button
      Align(
        alignment: Alignment.topLeft,
        child: Button(
                (){Navigator.of(context).pop();},
            "",
            Icons.arrow_back,
            Colors.grey,
            Colors.blue,
            Colors.black,
            queryData.size.width,
            queryData.size.height),
      ),

      // Map
      Align(
          widthFactor: widget.width,
          heightFactor: widget.height,
          child: Picture(
              pictureURL: widget.url,
              width: (widget.width),
              height: (widget.height*0.8))
      ),


      // Graph.
      Align(
        alignment: Alignment(screenXOrigin-1.0,screenYOrigin+0.75),
        child: Container(
          width: 145.0,
          height: 100.0,
          child: Center(
            child: LoadProfile.withSampleData(),
          ),
        ),
      ),
    ];

    game.visitRegion(regionType.MRO).visitState(stateType.Nebraska).forEach((generator) => list.add(
      Align(
        alignment: Alignment(screenXOrigin+generator.latitude,screenYOrigin+generator.longitude),
        child: AnimatedOpacity(
          opacity: generator.owned ? 1.0 : 0.5,
          duration: Duration(milliseconds: 500),
          child: FlatButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) => _buildAboutDialog(
                    context,
                    generator,
                ),
              );
            },
            color: Colors.transparent,
            child: Picture(pictureURL: generatorIconURLBase + generatorIconURLs[generator.type], width: 40, height: 40),
          ),
        ),
      ),
    ));

    return Stack(children: list);
  }
}

class _RegionMap extends StatefulWidget {
  _RegionMap({Key key, this.url, this.width, this.height, this.textScale}) : super(key: key);
  final double width, height, textScale;
  final String url;

  @override
  _RegionMapState createState() => _RegionMapState();
}

class _RegionMapState extends State<_RegionMap> {

  //final n = 0.8;
  //final url = 'assets/mro_map.png';

  @override
  Widget build(BuildContext context) {
    // Variables for the x and y alignments of assets based off of the height
    // and width of the device screen.
    MediaQueryData queryData;
    queryData = MediaQuery.of(context);

    double screenXOrigin = queryData.size.width*0.00025;
    double screenYOrigin = queryData.size.height*0.00035;

    return Scaffold(
      body: new Container(
        decoration: new BoxDecoration(
          shape: BoxShape.rectangle,
          color: Colors.green,
        ),
        alignment: Alignment.bottomCenter,
        child: Row(
          children: <Widget>[

            new AspectRatio(
              aspectRatio: (queryData.size.width) / (queryData.size.height * 0.9),
              child: new Container(
                decoration: new BoxDecoration(
                  shape: BoxShape.rectangle,
                  color: Colors.black,
                ),
                child: Stack(
                  children: <Widget>[

                    // Back Button
                    Align(
                      alignment: Alignment.topLeft,
                      child: Button(
                          (){Navigator.of(context).pop();},
                          "",
                          Icons.arrow_back,
                          Colors.grey,
                          Colors.blue,
                          Colors.black,
                          queryData.size.width,
                          queryData.size.height),
                    ),

                    // Map
                    Align(
                        widthFactor: widget.width,
                        heightFactor: widget.height,
                        child: Picture(
                            pictureURL: widget.url,
                            width: (widget.width),
                            height: (widget.height*0.8))
                    ),

                    // ND
                    /*Align(
                      alignment: Alignment(-screenXOrigin, -screenYOrigin),
                      child: Button(() {},
                          Icons.arrow_back,
                          Colors.transparent,
                          Colors.blue,
                          Colors.transparent,
                          queryData.size.width,
                          queryData.size.height),
                    ),

                    // SD
                    Align(
                      alignment: Alignment(-screenXOrigin, -screenYOrigin),
                      child: Button(
                              (){},
                              Icons.arrow_back,
                              Colors.transparent,
                              Colors.blue,
                              Colors.transparent,
                              queryData.size.width,
                              queryData.size.height),
                    ),

                    // MN
                    Align(
                      alignment: Alignment(-screenXOrigin, -screenYOrigin),
                      child: Button(() {},
                          Icons.arrow_back,
                          Colors.transparent,
                          Colors.blue,
                          Colors.transparent,
                          queryData.size.width,
                          queryData.size.height),
                    ),

                    // IA
                    Align(
                      alignment: Alignment(-screenXOrigin, -screenYOrigin),
                      child: Button(() {},
                          Icons.arrow_back,
                          Colors.transparent,
                          Colors.blue,
                          Colors.transparent,
                          queryData.size.width,
                          queryData.size.height),
                    ),

                    // WI
                    Align(
                      alignment: Alignment(-screenXOrigin, -screenYOrigin),
                      child: Button(() {},
                          Icons.arrow_back,
                          Colors.transparent,
                          Colors.blue,
                          Colors.transparent,
                          queryData.size.width,
                          queryData.size.height),
                    ),*/

                    // NE
                    Align(
                      alignment: Alignment(-screenXOrigin, -screenYOrigin),
                      child: Button(
                              (){
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                  builder:
                                  (BuildContext context) => _StateMap(
                              url: 'assets/mro/generators/nebraska.png',
                              width: queryData.size.width,
                              height: queryData.size.height*0.8,
                              textScale: queryData.textScaleFactor)));
                                },
                              "",
                              Icons.arrow_back,
                              Colors.transparent,
                              Colors.blue,
                              Colors.transparent,
                              queryData.size.width,
                              queryData.size.height),
                    ),

                    // KS
                    /*Align(
                      alignment: Alignment(-screenXOrigin, -screenYOrigin),
                      child: Button(() {},
                          Icons.arrow_back,
                          Colors.transparent,
                          Colors.blue,
                          Colors.transparent,
                          queryData.size.width,
                          queryData.size.height),
                    ),

                    // OK
                    Align(
                      alignment: Alignment(-screenXOrigin, -screenYOrigin),
                      child: Button(() {},
                          Icons.arrow_back,
                          Colors.transparent,
                          Colors.blue,
                          Colors.transparent,
                          queryData.size.width,
                          queryData.size.height),
                    ),*/
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CountryMap extends StatefulWidget {
  _CountryMap({Key key, this.url, this.width, this.height, this.textScale}) : super(key: key);
  final double width, height, textScale;
  final String url;

  @override
  _CountryMapState createState() => _CountryMapState();
}


class _CountryMapState extends State<_CountryMap> {

  @override
  Widget build(BuildContext context) {
    MediaQueryData queryData;
    queryData = MediaQuery.of(context);

    double screenXOrigin = queryData.size.width*0.00025;
    double screenYOrigin = queryData.size.height*0.00035;
    return Scaffold(
      body: new Container(
        decoration: new BoxDecoration(
          shape: BoxShape.rectangle,
          color: Colors.green,
        ),
        alignment: Alignment.bottomCenter,
        child: Row(
          children: <Widget>[
            new AspectRatio(
              aspectRatio: (queryData.size.width) / (queryData.size.height*0.75),
              child: new Container(
                decoration: new BoxDecoration(
                  shape: BoxShape.rectangle,
                  color: Colors.black,
                ),
                child: Stack(
                  children: <Widget>[

                    // Map
                    Align(
                    widthFactor: widget.width,
                      heightFactor: widget.height,
                      child: Picture(
                          pictureURL: widget.url,
                          width: (widget.width),
                          height: (widget.height*0.5))
                    ),


                  // WECC
                    Align(
                      alignment: Alignment(-screenXOrigin-0.6,-screenYOrigin+0.1),
                      child: Button(
                              (){},
                          "WECC",
                          Icons.arrow_back,
                          Colors.transparent,
                          Colors.blue,
                          Colors.transparent,
                          queryData.size.width,
                          queryData.size.height),
                    ),

                    // MRO
                    Align(
                      alignment: Alignment(-screenXOrigin+0.1,-screenYOrigin),
                      child: Button(
                              (){
                                // CALL SET REGION HERE

                                /*Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder:
                                            (BuildContext context) => _RegionMap(
                                  url: 'assets/mro_map.png',
                                  width: queryData.size.width,
                                  height: queryData.size.height*0.8,
                                  textScale: queryData.textScaleFactor)));*/
                              },
                          "MRO",
                          Icons.arrow_back,
                          Colors.transparent,
                          Colors.blue,
                          Colors.transparent,
                          queryData.size.width,
                          queryData.size.height
                      ),
                    ),

                    // Texas RE
                    Align(
                      alignment: Alignment(-screenXOrigin+0.03,-screenYOrigin+0.55),
                      child: Button(
                              (){},
                          "Texas RE",
                          Icons.arrow_back,
                          Colors.transparent,
                          Colors.blue,
                          Colors.transparent,
                          queryData.size.width,
                          queryData.size.height),
                    ),

                    // NPCC
                    Align(
                      alignment: Alignment(-screenXOrigin+1.08,-screenYOrigin-0.13),
                      child: Button(
                              (){},
                          "NPCC",
                          Icons.arrow_back,
                          Colors.transparent,
                          Colors.blue,
                          Colors.transparent,
                          queryData.size.width,
                          queryData.size.height),
                    ),

                    // RF
                    Align(
                      alignment: Alignment(-screenXOrigin+0.73,-screenYOrigin+0.1),
                      child: Button(
                              (){},
                          "RF",
                          Icons.arrow_back,
                          Colors.transparent,
                          Colors.blue,
                          Colors.transparent,
                          queryData.size.width,
                          queryData.size.height),
                    ),

                    // SERC
                    Align(
                      alignment: Alignment(-screenXOrigin+0.65,-screenYOrigin+0.33),
                      child: Button(
                              (){},
                          "SERC",
                          Icons.arrow_back,
                          Colors.transparent,
                          Colors.blue,
                          Colors.transparent,
                          queryData.size.width,
                          queryData.size.height),
                    ),

                    // FRCC
                    Align(
                      alignment: Alignment(-screenXOrigin+1.1,-screenYOrigin+0.6),
                      child: Button(
                              (){},
                          "FRCC",
                          Icons.arrow_back,
                          Colors.transparent,
                          Colors.blue,
                          Colors.transparent,
                          queryData.size.width,
                          queryData.size.height),
                    ),

                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}