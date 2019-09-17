import 'package:freedm_grid_game/backend/game.dart';

abstract class GameInterface {
  double get money;
  int get year;
  List<EventInterface> get events;

  factory GameInterface() => Game();

  RegionInterface regionData(regionType region);
  Map<String,String> nextTurn();

  beginGame(int year);

  void buyGenerator(GeneratorInterface generator);
  void sellGenerator(GeneratorInterface generator);
}

abstract class EventInterface {
  eventType get type;
  String get desc;
}

abstract class RegionInterface {
  List<GeneratorInterface> get generators;
  PowerInterface get load;
  PowerInterface get supply;
}

abstract class GeneratorInterface {
  String get name;
  String get asset;
  String get description;
  double get latitude;
  double get longitude;

  double get cost;
  generatorType get type;
  PowerInterface get rating;
  double get upkeep;

  bool get isBuilt;
  bool get isOwned;
  bool isRunning;
  bool get isManageable;
}

abstract class PowerInterface {
  double get base;
  double get peak;

  PowerInterface operator +(PowerInterface power);
  PowerInterface operator -(PowerInterface power);
}

enum eventType {
  regulation,
  disaster,
  generator,
}

enum regionType {
  FRCC,
  MRO,
  NPCC,
  RF,
  SERC,
  TexasRE,
  WECC,
}

enum generatorType {
  coal,
  hydro,
  gas,
  nuclear,
  solar,
  wind,
}

enum efficiencyType {
  underPowered,
  inefficient,
  missedPeak,
  efficient,
  staticOverload
}

/*
enum stateType {
  Alabama,
  Alaska,
  Arizona,
  Arkansas,
  California,
  Colorado,
  Connecticut,
  Delaware,
  Florida,
  Georgia,
  Hawaii,
  Idaho,
  Illinois,
  Indiana,
  Iowa,
  Kansas,
  Kentucky,
  Louisiana,
  Maine,
  Maryland,
  Massachusetts,
  Michigan,
  Minnesota,
  Mississippi,
  Missouri,
  Montana,
  Nebraska,
  Nevada,
  NewHampshire,
  NewJersey,
  NewMexico,
  NewYork,
  NorthCarolina,
  NorthDakota,
  Ohio,
  Oklahoma,
  Oregon,
  Pennsylvania,
  RhodeIsland,
  SouthCarolina,
  SouthDakota,
  Tennessee,
  Texas,
  Utah,
  Vermont,
  Virginia,
  Washington,
  WestVirginia,
  Wisconsin,
  Wyoming,
}
*/
