import 'package:flutter/material.dart';
import 'package:freedm_grid_game/interface.dart';
import 'package:freedm_grid_game/frontend/constants.dart';
import 'package:freedm_grid_game/frontend/graph.dart';

class GamePage extends StatefulWidget {
  final GameInterface game;

  GamePage(this.game);

  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  TopHUD topHUD;
  MiddleHUD middleHUD;
  BottomHUD bottomHUD;

  pageView page;
  regionType type;
  List<EventInterface> notifications;

  _GamePageState() {
    page = pageView.home;
    notifications = List();
  }

  void exitLocation() {
    if (page == pageView.region)
      page = pageView.country;
    else
      page = pageView.home;
    refresh();
  }

  void enterRegion(regionType newType){
    page = pageView.region;
    type = newType;
    refresh();
  }

  void enterGame(int year) {
    widget.game.beginGame(year);

    page = pageView.country;
    notifications = widget.game.events;
    refresh();
  }

  void updateHUDs() {
    topHUD = TopHUD(exitLocation, widget.game.money, widget.game.year);
    middleHUD = MiddleHUD(
      refresh,
      page == pageView.country ? countryMapAsset : regionAssetFolders[type] + regionMapAssets[type],
      page == pageView.country ? countryButtons(enterRegion) : regionButtons(context,refresh,widget.game,type),
      page == pageView.region ? widget.game.regionData(type) : null,
      page,
      type
    );
    bottomHUD = BottomHUD(processTurn,widget.game,notifications, page, type);
  }

  void refresh() {
    if (page != pageView.home)
      setState(() => updateHUDs());
    else
      setState((){});
  }

  processTurn() {
    Map<String,String> report = widget.game.nextTurn();
    notifications = widget.game.events;
    if (report != null)
      showDialog(
        context: context,
        builder: (BuildContext context) => buildReportDialog(context,report),
      );
    refresh();
  }

  @override
  Widget build(BuildContext context) {
    return page != pageView.home ? (
      Column(
        children: <Widget>[
          topHUD,
          Expanded(
            child: middleHUD,
          ),
          bottomHUD,
        ],
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
      )
    ) : (
      Container(
      decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(homeScreenAsset)
          )
        ),
      child: Stack(
          children: <Widget>[
            Align(
              alignment: Alignment(-0.02, -0.84),
              child: FlatButton(
                  color: Colors.transparent,
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) => buildGameStartDialog(context,this.enterGame),
                    );
                  },
              ),
            ),
            Align(
              alignment: Alignment(-0.035, -0.73),
              child: ButtonTheme(
                minWidth: 210,
                child: FlatButton(
                  color: Colors.transparent,
                  onPressed: () => enterGame(2050),
                )
              ),
            ),
          ],
        ),
      )
    );
  }
}

class TopHUD extends StatelessWidget {
  final Function exitLocation;
  final double money;
  final int year;

  TopHUD(this.exitLocation,this.money,this.year);

  @override
  Widget build(BuildContext context) {
    return Container (
      color: Colors.lightBlueAccent,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          ButtonTheme(
            minWidth: (50),
            height: (50),
            child: FlatButton(
              child: Column(
                children: <Widget>[
                  Icon(
                    Icons.arrow_back,
                    color: Colors.black,
                  ),
                  Text("Back"),
                ]
              ),
              onPressed: () => exitLocation(),
              color: Colors.white,
            ),
          ),
          Container(
            color: Colors.white,
            constraints: BoxConstraints(
              minWidth: MediaQuery.of(context).size.width*0.45,
              maxWidth: MediaQuery.of(context).size.width*0.45,
            ),
            child: Text("Funds: \$$money M",
              style: TextStyle(
                decoration: TextDecoration.none,
                color: Colors.green,
                fontSize: (18.0),
              )
            )
          ),
          Container(
            color: Colors.white,
            constraints: BoxConstraints(
              minWidth: MediaQuery.of(context).size.width*0.35,
              maxWidth: MediaQuery.of(context).size.width*0.35,
            ),
            child: Text("Year: $year",
              style: TextStyle(
                decoration: TextDecoration.none,
                color: Colors.black,
                fontSize: (18.0),
              )
            )
          ),
        ]
      ),
    );
  }
}

class BottomHUD extends StatelessWidget {
  final Function processTurn;
  final GameInterface game;
  final List<EventInterface> notifications;
  final pageView currentPage;
  final regionType region;

  BottomHUD(this.processTurn, this.game, this.notifications, this.currentPage, this.region);

  Widget _buildAboutDialog(BuildContext context) {
    return AlertDialog(
      title: Text("Notifications"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: _buildEventList(notifications),
      ),
      actions: <Widget>[
        FlatButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          textColor: Theme
              .of(context)
              .primaryColor,
          child: Text("Ok"),
        )
      ],
    );
  }

  List<Widget> _buildEventList(List<EventInterface> notifications) {
    List<Widget> widgets = [];
    notifications?.forEach((event) => widgets.add(Text(event.desc)));
    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.1),
      child: Container(
        color: Colors.lightBlueAccent,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            FlatButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) => _buildAboutDialog(context),
                );
              },
              color: notifications != null ? Colors.green : Colors.white,
              child: Row(
                children: <Widget>[
                  /*Icon(
                    Icons.vpn_key,
                    color: Colors.yellowAccent,
                  ),*/

                  Text(
                      "Notifications",
                      style: TextStyle(fontSize: (20.0))
                  ),
                ]
              )
            ),
            (currentPage == pageView.region) ? Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Icon(
                      Icons.lens,
                      color: Colors.purple,
                      size: 30.0,
                    ),
                    Text(" = Power Needed",
                      style: TextStyle(
                        decoration: TextDecoration.none,
                        color: Colors.black,
                        fontSize: (16.0)
                      )
                    ),
                  ]
                ),
                Row(
                  children: <Widget>[
                    Icon(
                      Icons.lens,
                      color: Colors.teal,
                      size: 30.0,
                    ),
                    Text(" = Your Power",
                      style: TextStyle(
                        decoration: TextDecoration.none,
                        color: Colors.black,
                        fontSize: (16.0)
                      )
                    ),
                  ]
                )
              ]
            ):Text(""),

            Text("Current\nLocation: " + ((currentPage == pageView.region) ? region.toString().split('.').last : 'USA'), //$currentPage", //+ location(),
                style: TextStyle(
                    decoration: TextDecoration.none,
                    color: Colors.black,
                    fontSize: (16.0)
                )
            ),
            ButtonTheme(
              minWidth: (50),
              height: (50),
              child: FlatButton(
                color: Colors.white,
                onPressed: () => processTurn(),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.play_arrow,
                        color: Colors.green,
                      ),
                      Text("Next Turn"),
                    ]
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MiddleHUD extends StatelessWidget {
  final Function refreshPage;
  final String path;
  final List<Widget> widgets;
  final RegionInterface region;
  final pageView page;
  final regionType type;


  MiddleHUD(this.refreshPage,this.path,this.widgets,this.region,this.page,this.type);

  @override
  Widget build(BuildContext context) {
    List<Widget> manageableGenerators = List();
    if (page == pageView.region)
      region.generators.forEach((generator) {
        if (generator.isManageable)
          manageableGenerators.add(FlatButton(
              color: generator.isRunning ? Colors.green : Colors.red,
              onPressed: () {
                generator.isRunning = !generator.isRunning;
                Navigator.of(context).pop();
                refreshPage();
              },
              child: Text(generator.name + ': ' + (generator.isRunning ? 'ON' : 'OFF')),
            )
          );
      });

    return page != pageView.region ? (
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(path),
              fit: BoxFit.contain,
            ),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: widgets,
          ),
        )
    ) : (
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(path),
                    fit: BoxFit.contain,
                  ),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: widgets,
                ),
              ),
            ),
            ConstrainedBox(
              constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget> [
                  Expanded(
                    child: Container(
                      color: Colors.lightBlueAccent,
                      child: Center(
                        child: LoadProfile(region.supply,region.load),
                      ),
                    )
                  ),
                  ButtonTheme(
                    minWidth: 94,
                    child: FlatButton(
                      onPressed: () => showDialog(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                          title: Text('Generator Management'),
                          content: Container(
                            height: MediaQuery.of(context).size.height * 0.6,
                            width: MediaQuery.of(context).size.width * 0.8,
                            child: ListView(
                              shrinkWrap: true,
                              children: manageableGenerators,
                            ),
                          ),
                          actions: <Widget>[
                            FlatButton(
                              color: Colors.blue,
                              textColor: Colors.white,
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text('Done'),
                            ),
                          ],
                        ),
                      ),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Text('Match'),

                            Icon(
                              Icons.insert_chart,
                              color: Colors.black,
                               size: 30.0,
                            ),
                          ]
                      ),
                      color: Colors.white,
                    ),
                  ),
                  /*
                  Expanded(
                      child: Container(
                        height: 50,
                        child: Center(
                          child: LoadProfile.withSampleData(0),
                        ),
                      )
                  ),
                  Expanded(
                      child: Container(
                        height: 50,
                        child: Center(
                          child: LoadProfile.withSampleData(500),
                        ),
                      )
                  ),
                  Expanded(
                      child: Container(
                        height: 50,
                        child: Center(
                          child: LoadProfile.withSampleData(-1000),
                        ),
                      )
                  ),
                  */
                ],
              ),
            ),
          ],
        )
    );
  }
}
