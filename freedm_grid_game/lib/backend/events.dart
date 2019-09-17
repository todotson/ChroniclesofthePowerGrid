import 'package:freedm_grid_game/interface.dart';
import 'package:freedm_grid_game/backend/generator.dart';
import 'package:freedm_grid_game/backend/events.dart';
import 'dart:math';

dynamic eventTypeFromString(String event_type) =>
    eventType.values.firstWhere((f)=> f.toString() == 'eventType.$event_type', orElse: () => null);

class Event implements EventInterface {
  int _year;
  eventType _type;
  final String _desc;
  final String _long_desc;
  final List<dynamic> _aff_areas;
  Function _work;

  //for generator type events
  bool buildComplete;
  regionType region;
  Generator generator;
  
  
  

  int get year => _year;
  eventType get type => _type;
  String get desc => _desc;
  work(Event e) => _work(e);

  Event(this._year, this._type, this._desc, this._long_desc, this._aff_areas );

  factory Event.fromJson(Map<String, dynamic> parsedJson){
    //generatore random year in range
    List<String> times = parsedJson['year'].split('-');
    Random rnd = Random();

    int year = int.parse(times[0]);
    
    if(times.length > 1){
      year = int.parse(times[0]) + rnd.nextInt(int.parse(times[1]) - int.parse(times[0]));
    }

    try{
      return Event(
        year,
        eventTypeFromString(parsedJson['type']),
        parsedJson['desc'],
        parsedJson['long_description'],
        parsedJson['affected_areas']
      );
    }
    catch(e){
      print(e);
    }
  }

  void instateAction(Function work) => _work = work;

}
