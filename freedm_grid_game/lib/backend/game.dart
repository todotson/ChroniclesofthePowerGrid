/*
TO-DO:

Economics - get load colulations done correctly, move 
Upkeep calculations (fuel)
Notes about load supplying: if we want to make fuel costs factor into a player's decsion into buying a certain generator type, upkeep cost may need to remain a constant across all types. OR, we can include fuel cost into the upkeep cost and just have higher and lower upkeep depending on which is more fuel efficient. The only issue with this is that it limits our ability to really include an economy or demand.

 - implement eventt happenings for when player does badly, and for weather
    |_> these events can "stretch" upkeep costs for running overtime or imposing government costs

 - for now, just put in a set upkeep cost for each
 - should each power plant have a range it can operate in so that a player has some leeway in matching the total source to the load?

 - maybe round base and peak for each load and generator to nearest 50 to allow for easy combination calculation?

  |_> I could show this by automatically matching the source and load exactly if it falls within the min and max of all of the plants together

Region activation - add method for activating regions when player first enters them
Saving 

Saving profiles to database

Load planning - model for changing load over time

Finish up events from Isleida - get rid of ones that are unnessecary
 - Make weather events
 - Get rid of "Generator available" events from database
*/



import 'package:freedm_grid_game/interface.dart';
import 'package:freedm_grid_game/backend/generator.dart';
import 'package:freedm_grid_game/backend/region.dart';
import 'package:freedm_grid_game/backend/events.dart';
import 'package:freedm_grid_game/backend/builder.dart';

class Game implements GameInterface {
  double _money;
  int _year;

  Map<regionType,Region> _regions;
  Map<int,List<Event>> _events;
  Map<String,dynamic> _profile;

  Builder _builder;

  double get money => _money;
  int get year => _year;
  List<Event> get events => _events[_year];

  Game(){
    _builder = Builder();
  }

  beginGame(int year) {
    _year = year;

    _profile = _builder.loadProfile('Xavier');
    _regions = _builder.createRegions();
    _events = _builder.createGeneratorEvents(generatorEventAction);
    _events.addAll(_builder.createEvents(workSelector));

    for (int i=1900;i<=_year;i++){
      if (_events[i] != null)
      _events[i].forEach((event) => event.work(event));
    }

    _money = _profile['money'];      
    
  }

  void registerEvent(int year, Event event) => 
      _events[year] != null ? _events[year].add(event) : _events[year] = List.filled(1,event,growable: true);

  Region regionData(regionType region) => _regions[region];
 

  Map<String,String>  nextTurn() {
    Map<String, String> feedback = generateReport(_regions[regionType.FRCC]);
    _regions.forEach((regT,region) {
        if(regT == regionType.FRCC){
          _money += region.generatorRevenue() - region.generatorCosts();
        }
        region.nextYear();
    });

    if (_events[++_year] != null)
      _events[_year].forEach((event) => event.work(event));
    
    return feedback;
  }

  Function generatorEventAction(Event e) {
    if(e.buildComplete) e.generator.isBuilt = true;
    else _regions[e.region].addGenerator(e.generator);
  }

  Function workSelector(eventType evt){
    switch(evt){
      case eventType.generator: {
        return (Event e) {
          print("Generator type");
        };
      }
      break;
      case eventType.disaster: {
        return (Event e) {
          print("Disastor strikes! You lose 100M");
          //_money -= 100;
        };
      }
      break;
      case eventType.regulation: {
        return (Event e) => print("This is a regulation event");
      }
      break;
      default: return (Event e) => print("Event type not found. No effect for this event");
    }
  }  

  void buyGenerator(GeneratorInterface generator) => _money -= (generator as Generator).buy();

  void sellGenerator(GeneratorInterface generator) => _money += (generator as Generator).sell();

  //debug
  void printRegions(){
    _regions.forEach((regName, regObj) {
        for(var gen in regObj.generators) print('       ' + gen.name);
    });
  }

  Map<String,String>  generateReport(Region region) {
    Map<String, String> ret = Map();
    ret['year'] = _year.toString();
    ret['profit'] = region.generatorRevenue().toStringAsFixed(2)+'M';
    ret['upkeep'] = region.generatorCosts().toStringAsFixed(2)+'M';
    
    String feedback (){
      switch(region.efficiency){
        case efficiencyType.underPowered: {

          Event e = Event(
            _year + 1,
            eventType.regulation,
            "* Blackouts caused by your inability to supply proper power to the region results in customer lawsuits, particularily from industrial customers with whom you signed 24/7 power contracts. You lose \$1000M",
            "",
            []
          );

          e.instateAction((Event en){_money -= 1000.0;});
          registerEvent(e.year, e);
          return "You are not supplying enough total power to the region and as a result, large land areas " +
                 " never recieve power. Your inablility to provide power causes not only blackouts " +
                 "but most likely government intervention and imposed fines (check notifications).\n\n " +
                 "Tip: buy more generators before continuing to the next year.";
        }
        break;
        case efficiencyType.inefficient: {
          return "Though you are supplying enough power to supply the region, you are not supplying enough base " +
                 "power to constitute the base power demand of the region. As a result, the generators that are " +
                 "intended only to come on during peak demands during the day must run overtime to make up for " +
                 "the lack of baseline power, causing high maintainance costs. \n\nTip: buy more generator types " +
                 "that have high baseline power ratings.";
        }
        break;
        case efficiencyType.missedPeak: {
          Event e = Event(
            _year + 1,
            eventType.regulation,
            "* At peak demand times throughout the day, blackouts occure, resulting in lawsuits from customers who you signed absolute power agreements with. If the issue continues, FERC may investigate. You lose \$200M",
            "",
            []
          );
          e.instateAction((Event en){_money -= 200.0;});
          registerEvent(e.year, e);
          
          return "You are are satisfying the baseline power demand within this region, however you do not have " +
                 "enough generators that can turn on during peak demand times. As a result, when power usage " +
                 "spikes (such as in the middle of any given day), there are numerous blackouts across the " +
                 "region. This results in not only lost out potential earnings but also leaves you vulnerable to " +
                 "being sued by some of your customers (check notificatins). \n\n Tip: buy more generators with high peak power ratings. ";
        }
        break;
        case efficiencyType.staticOverload: {
          Event e = Event(
            _year + 1,
            eventType.regulation,
            "* Generation of too much energy causes damage to equipment. FERC investigates usage of transmission equipment past rating and determines you are exceeding. You loose \$600M",
            "",
            []
          );
          e.instateAction((Event en){_money -= 600.0;});
          registerEvent(e.year, e);
          return " You are supplying too much base power. Be carful! This can result in damages to distribution systems and result in government fines.";
        }
        case efficiencyType.efficient:{
          return "Great job! You are supplying plenty of baseline and peak power to satisfy power demand in this " +
          "region. \n\nTip: be sure to monitor how the load changes moving into next turn to so that you " +
          "do not fall behind!";
        }
        break;
        default: return "";     
      }
    };
    ret['feedback'] = feedback();
    //profit
    //efficiency
    //
    //More info?
    //   -> Gross Profit
    //   -> Fuel costs
    //       |-> [State 1: Gas, coal, etc; State 2: ...  State n]
    //   -> Peak demand met
    //   -> Base demand met
    //   -> Fines
    //   -> taxes
    //   -> regulations in effect

    
    return ret;
  }
}
