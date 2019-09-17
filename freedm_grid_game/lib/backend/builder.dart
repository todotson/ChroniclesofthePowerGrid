/* Paul Leimer - 2-5-2019
  Wrapper for building objects from the database
*/

  import 'dart:convert';
  import 'dart:async' show Future;
  import 'dart:io';
  import 'package:flutter/services.dart' show rootBundle;
  
  import 'package:freedm_grid_game/interface.dart';
  import 'package:freedm_grid_game/backend/generator.dart';
  import 'package:freedm_grid_game/backend/region.dart';
  import 'package:freedm_grid_game/backend/power.dart';
  import 'package:freedm_grid_game/backend/events.dart';


  class Builder {
    var _regions;
    var _events;
    
    List<Region> _region_objs;

    
    Future<String> loadRegionsDB() async {
      try{
        String ret = await rootBundle.loadString('assets/db/regs.json');
        return ret;
      }
      catch(e){
        print(e);
      }
    }

    Future<String> loadEventsDB() async {
      try{
        String ret = await rootBundle.loadString('assets/db/events.json');
        return ret;
      }
      catch(e){
        print(e);
      }
    }


    Builder(){
        loadRegionsDB().then((String data) {
          try{
            _regions = jsonDecode(data);
            print("Loaded region information from database");
          }
          catch(e){
            print(e);
            print("Failed to load regions from database");
          }
        });

        loadEventsDB().then((String data) {
          try{
            _events = jsonDecode(data);
            print("Loaded event information from database");
          }
          catch(e){
            print(e);
            print("Failed to load event from database");
          }
        });
    }

    Map<String, dynamic> loadProfile(String name) => jsonDecode(player_profiles)[0];


    
    Map<int, List<Event>> createGeneratorEvents(Function buildFunc){
      Map<int, List<Event>> event_map = Map();
      for(var reg_json in _regions){
        try{
          regionType rt = regionTypeFromString(reg_json['region']);
          
          reg_json['states'].forEach((name, stateContents) {
              for(var generator_json in stateContents['generators']){
                Generator gen = Generator.fromJson(generator_json);

                int start_year = gen.startDate;

                //build event
                if(event_map[start_year] == null) event_map[start_year] = List();
                event_map[start_year].add(Event( start_year,
                    eventType.generator,
                    "* " +gen.name + " generator under construction",
                    gen.name + " is located in the " + rt.toString().split('.').last + " region",
                    []
                  )
                );
                event_map[start_year].last.generator = gen;
                event_map[start_year].last.region = rt;
                event_map[start_year].last.buildComplete = false;
                event_map[start_year].last.instateAction(buildFunc);

                //completed construction event
                int end_year = gen.doneDate;

                if(event_map[end_year] == null) event_map[end_year] = List();
                event_map[end_year].add(Event( start_year,
                    eventType.generator,
                    "* " + gen.name + " construction complete. Generator is now available for purchase",
                    gen.name + " is located in the " + rt.toString().split('.').last + " region",
                    []
                  )
                );
                event_map[end_year].last.generator = gen;
                event_map[end_year].last.region = rt;
                event_map[end_year].last.buildComplete = true;
                event_map[end_year].last.instateAction(buildFunc);

                
              }
          });
        }
        catch(e){
          print(e);
          print("Failed to create event for a generator");
        }
      }
      return event_map;
    }
      

    Map<regionType, Region> createRegions() {
      Map<regionType, Region> reg_map = Map();
      for(var reg_json in _regions){
        reg_map[regionTypeFromString(reg_json['region'])] = Region.fromJson(reg_json);
      }
      return reg_map;
        
    }

    Map<int, List<Event>> createEvents(Function selector) {
      Map <int, List<Event>> ret = Map();
        for(var event_json in _events){
          Event ev = Event.fromJson(event_json);
          ev.instateAction(selector(ev.type));
          ret[ev.year] != null ? ret[ev.year].add(ev) : ret[ev.year] = List.filled(1,ev,growable: true);
        }
      return ret;
    }
    

        //Temporary Database

String player_profiles = """
[
  {
    "name":"Xavier",
    "money":8000.0
  }
]
  """;     
}
