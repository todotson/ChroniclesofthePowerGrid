import 'package:flutter/material.dart';
import 'package:freedm_grid_game/interface.dart';
import 'package:freedm_grid_game/frontend/graph.dart';

enum pageView {
  home,
  country,
  region,
}

const String generatorIconAssetsFolder = 'assets/_global/generator_icons/';

const Map<generatorType,String> generatorBuiltIconAssets = {
  generatorType.coal    : 'coal_power_plant.png',
  generatorType.hydro   : 'hydro_power_plant.png',
  generatorType.gas     : 'natural_gas_power_plant.png',
  generatorType.nuclear : 'nuclear_power_plant.png',
  generatorType.solar   : 'solar_power_plant.png',
  generatorType.wind    : 'wind_power_plant.png',
};

const Map<generatorType,String> generatorConstructionIconAssets = {
  generatorType.coal    : 'under_construction_coal.png',
  generatorType.hydro   : 'under_construction_hydro.png',
  generatorType.gas     : 'under_construction_natural_gas.png',
  generatorType.nuclear : 'under_construction_nuclear.png',
  generatorType.solar   : 'under_construction_solar.png',
  generatorType.wind    : 'under_construction_wind.png',
};

const Map<generatorType,String> generatorTypeStrings = {
  generatorType.coal    : 'Coal',
  generatorType.hydro   : 'Hydro',
  generatorType.gas     : 'Gas',
  generatorType.nuclear : 'Nuclear',
  generatorType.solar   : 'Solar',
  generatorType.wind    : 'Wind',
};

const String homeScreenAsset = 'assets/_global/home_screen_vert.png';

const String countryMapAsset = 'assets/_global/us_map.png';

const String generatorAssetFolder = 'generators/';

const Map<regionType,String> regionAssetFolders = {
  regionType.FRCC    : 'assets/frcc/',
  regionType.MRO     : 'assets/mro/',
  regionType.NPCC    : 'assets/npcc/',
  regionType.RF      : 'assets/rf/',
  regionType.SERC    : 'assets/serc/',
  regionType.TexasRE : 'assets/texas_re/',
  regionType.WECC    : 'assets/wecc/',
};

const Map<regionType,String> regionMapAssets = {
  regionType.FRCC    : 'frcc.png',
  regionType.MRO     : 'mro.png',
  regionType.NPCC    : 'npcc.png',
  regionType.RF      : 'rf.png',
  regionType.SERC    : 'serc.png',
  regionType.TexasRE : 'texas_re.png',
  regionType.WECC    : 'wecc.png',
};

List<Widget> countryButtons(Function enterRegion) {
  return <Widget>[
    Align(
      alignment: Alignment(0.5, 0.3),
      child: ButtonTheme(
        minWidth: (50 * 0.15),
        height: (50 * 0.1),
        child: FlatButton(
          onPressed: () => enterRegion(regionType.FRCC),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text("FRCC"),
              Text("Click Here!"),
            ]
          ),
          color: Colors.white,
        ),
      ),
    ),
    Align(
      alignment: Alignment(0.0, -0.2),
      child: ButtonTheme(
        minWidth: (50 * 0.15),
        height: (50 * 0.1),
        child: FlatButton(
          onPressed: () => enterRegion(regionType.MRO),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text("MRO"),
              Text("Click Here!"),
            ]
          ),
          color: Colors.white,
        ),
      ),
    ),
    Align(
      alignment: Alignment(0.95, -0.23),
      child: ButtonTheme(
        minWidth: (50 * 0.15),
        height: (50 * 0.1),
        child: FlatButton(
          onPressed: () => enterRegion(regionType.NPCC),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text("NPCC"),
              Text("Click Here!"),
            ]
          ),
          color: Colors.white,
        ),
      ),
    ),
    Align(
      alignment: Alignment(0.55, -0.1),
      child: ButtonTheme(
        minWidth: (50 * 0.15),
        height: (50 * 0.1),
        child: FlatButton(
          onPressed: () => enterRegion(regionType.RF),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text("RF"),
              Text("Click Here!"),
            ]
          ),
          color: Colors.white,
        ),
      ),
    ),
    Align(
      alignment: Alignment(0.45, 0.1),
      child: ButtonTheme(
        minWidth: (50 * 0.15),
        height: (50 * 0.1),
        child: FlatButton(
          onPressed: () => enterRegion(regionType.SERC),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text("SERC"),
              Text("Click Here!"),
            ]
          ),
          color: Colors.white,
        ),
      ),
    ),
    Align(
      alignment: Alignment(-0.15, 0.19),
      child: ButtonTheme(
        minWidth: (50 * 0.15),
        height: (50 * 0.1),
        child: FlatButton(
          onPressed: () => enterRegion(regionType.TexasRE),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text("TexasRE"),
              Text("Click Here!"),
            ]
          ),
          color: Colors.white,
        ),
      ),
    ),
    Align(
      alignment: Alignment(-0.65, -0.1),
      child: ButtonTheme(
        minWidth: (50 * 0.15),
        height: (50 * 0.1),
        child: FlatButton(
          onPressed: () => enterRegion(regionType.WECC),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text("WECC"),
              Text("Click Here!"),
            ]
          ),
          color: Colors.white,
        ),
      ),
    ),
  ];
}

List<Widget> regionButtons(BuildContext context,Function refreshPage,GameInterface game,regionType type) {
  List<GeneratorInterface> generators = game.regionData(type).generators;
  List<Widget> widgets = [];
  generators.forEach((generator) => widgets.add(
    Align(
      alignment: Alignment((generator.longitude+84)/3.5,-(generator.latitude-27.75)/3.75),
      child: ConstrainedBox(
        constraints: BoxConstraints(
            minHeight: 75,
            maxHeight: 75,
            minWidth: 75,
            maxWidth: 75,
        ),
        child: AnimatedOpacity(
          opacity: generator.isOwned ? 1.0 : 0.5,
          duration: Duration(milliseconds: 750),
          child: FlatButton(
            onPressed: (){
              showDialog(
                context: context,
                builder: (BuildContext context) => buildGeneratorDialog(
                  context,
                  refreshPage,
                  game,
                  type,
                  generator,
                ),
              );
            },
            child: Image(
              image: AssetImage(generatorIconAssetsFolder + (generator.isBuilt ? generatorBuiltIconAssets[generator.type] : generatorConstructionIconAssets[generator.type])),
            ),
          ),
        ),
      ),
    ),
  ));

  return widgets;
}

Widget buildGeneratorDialog(BuildContext context,Function refreshPage,GameInterface game,regionType type,GeneratorInterface generator) {
  return AlertDialog(
    title: Text(generator.name),
    content: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _buildLogoAttribution(game,type,generator),
        _buildGeneratorText(generator),
      ],
    ),
    actions: <Widget>[
      FlatButton(
        color: Colors.blue,
        textColor: Colors.white,
        onPressed: () {
          Navigator.of(context).pop();
        },
        child: Text('Cancel'),
      ),
      FlatButton(
        color: generator.isOwned ? Colors.orange : (game.money >= generator.cost ? Colors.blue : Colors.red),
        textColor: Colors.white,
        onPressed:
          generator.isOwned ?
            () {
              game.sellGenerator(generator);
              Navigator.of(context).pop();
              refreshPage();
            }
          : game.money >= generator.cost ?
            () {
              game.buyGenerator(generator);
              refreshPage();
              Navigator.of(context).pop();
              showDialog(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    title: Text('You Bought ${generator.name}'),
                    content: Image(
                        height: 150.0,
                        image: AssetImage(regionAssetFolders[type] + generatorAssetFolder + generator.asset)
                    ),
                    actions: <Widget>[
                      FlatButton(
                        color: Colors.blue,
                        textColor: Colors.white,
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('OK'),
                      ),
                    ],
                  )
              );
            }
          : () => showDialog(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                title: Text('Not Enough Funds'),
                actions: <Widget>[
                  FlatButton(
                    color: Colors.blue,
                    textColor: Colors.white,
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('OK'),
                  ),
                ],
              )
            ),
        child: Text(generator.isOwned ? 'Sell' : 'Buy'),
      ),
    ],
  );
}

Widget _buildGeneratorText(GeneratorInterface generator) {
  return RichText(
    text: TextSpan(
      style: TextStyle(color: Colors.black87),
      children: <TextSpan>[
        TextSpan(text: 'Cost: \$${generator.cost} M\n',),
        TextSpan(text: 'Base/Peak: ${generator.rating.base}/${generator.rating.peak} MW\n\n',),
        TextSpan(text: 'Description: ${generator.description}\n',),
      ],
    ),
  );
}

Widget _buildLogoAttribution(GameInterface game,regionType type,GeneratorInterface generator) {
  return Padding(
    padding: EdgeInsets.only(top: 16.0),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 0.0),
          child: Image(
            height: 75.0,
            image: AssetImage(regionAssetFolders[type] + generatorAssetFolder + generator.asset),
          ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(left: 12.0),
            child: Container(
              height: 75.0,
              child: Center(
                child: LoadProfile(game.regionData(type).supply + generator.rating,game.regionData(type).load),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

Widget buildReportDialog(BuildContext context,Map<String,String> report) {
  return AlertDialog(
    title: Text(report['year'] + ' Report'),
    content: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _buildReportText(report),
      ],
    ),
    actions: <Widget>[
      FlatButton(
        color: Colors.blue,
        textColor: Colors.white,
        onPressed: () {
          Navigator.of(context).pop();
        },
        child: Text('OK'),
      ),
    ],
  );
}

Widget _buildReportText(Map<String,String> report) {
  return RichText(
    text: TextSpan(
      style: TextStyle(color: Colors.black87),
      children: <TextSpan>[
        TextSpan(text: 'Profit: ' + report['profit'] + '\n'),
        TextSpan(text: 'Upkeep: ' + report['upkeep'] + '\n'),
        TextSpan(text: '\n' + report['feedback'] + '\n'),
      ],
    ),
  );
}

Widget buildGameStartDialog(BuildContext context,Function enterGame) {
  return AlertDialog(
    title: Text('Choose Starting Year:'),
    actions: <Widget>[
      FlatButton(
        color: Colors.blue,
        textColor: Colors.white,
        onPressed: () {
          enterGame(1950);
          Navigator.of(context).pop();
        },
        child: Text('1950'),
      ),
      FlatButton(
        color: Colors.blue,
        textColor: Colors.white,
        onPressed: () {
          enterGame(1975);
          Navigator.of(context).pop();
        },
        child: Text('1975'),
      ),
      FlatButton(
        color: Colors.blue,
        textColor: Colors.white,
        onPressed: () {
          enterGame(2000);
          Navigator.of(context).pop();
        },
        child: Text('2000'),
      ),
    ],
  );
}
