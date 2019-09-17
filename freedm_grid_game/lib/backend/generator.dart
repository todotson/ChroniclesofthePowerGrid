import 'package:freedm_grid_game/interface.dart';
import 'package:freedm_grid_game/backend/power.dart';
import 'dart:math';

dynamic generatorTypeFromString(String gen_type) =>
    generatorType.values.firstWhere((f)=> f.toString() == 'generatorType.$gen_type', orElse: () => null);

class Generator implements GeneratorInterface{
  final String _name;
  final String _asset;
  final String _description;
  final double _cost;
  final generatorType _type;
  final Power _rating;
  final double _upkeep;
  final double _latitude;
  final double _longitude;
  final int _startDate;
  final int _doneDate;
  final double _variance;

  bool isBuilt;
  bool isOwned;
  bool isRunning;


  String get name => _name;
  String get asset => _asset;
  String get description => _description;
  double get cost => _cost;
  generatorType get type => _type;
  Power get rating => _rating;
  double get upkeep => _upkeep;
  double get latitude => _latitude;
  double get longitude => _longitude;

  Power get  min_rating => new Power(_rating.base - _rating.base * _variance, _rating.peak - _rating.peak * _variance);
  Power get max_rating=> new Power(_rating.base +  _rating.base * _variance, _rating.peak + _rating.peak * _variance);


  int get startDate => _startDate;
  int get doneDate => _doneDate;

  bool get isManageable => isOwned && (_type == generatorType.coal || _type == generatorType.hydro || _type == generatorType.gas);


  Generator(this._name, this._asset, this._description, this._cost, this._type,
      this._rating, this._upkeep, this._latitude, this._longitude, this._startDate, this._doneDate, this._variance) {

    isBuilt = false;
    isOwned = false;
    isRunning = false;

    List args = [this._name, this._asset, this._description,
                  this._cost, this._type, this._rating, this._upkeep,
                  this._latitude, this._longitude, this._startDate, this._doneDate];

    for(var arg in args){
      if(arg == null){
        print("Warning: generator of name " + this.name + " did not fully initialize");
      }
    }

  }


  factory Generator.fromJson(Map<String, dynamic> parsedJson){
    //TEMPORARY
    double upkeepByType(generatorType type){
      switch(type){
        case generatorType.hydro: return 0.5;
        case generatorType.coal: return 0.95;
        case generatorType.gas: return 0.9;
        case generatorType.wind: return 0.4;
        case generatorType.nuclear: return 0.8;    
        case generatorType.solar: return 0.1;   //
        default: return 0.0;
      }
    }

    
    return Generator(
      parsedJson['name'],
      parsedJson['asset'],
      parsedJson['description'],
      parsedJson['cost'],
      generatorTypeFromString(parsedJson['type']),
      Power(
        parsedJson['rating'][1],
        parsedJson['rating'][0]
      ),
      upkeepByType(generatorTypeFromString(parsedJson['type'])),//parsedJson['upkeep'],
      parsedJson['latitude'],
      parsedJson['longitude'],
      parsedJson['date1'],
      parsedJson['date2'],
      0.1 //TEMPORARY - variance
    );
  }

  double buy() {
    isOwned = true;
    isRunning = true;
    return _cost;
  }

  double sell() {
    isOwned = false;
    return _cost * 0.5;
  }

  double getFuelCost(double fuel_cost) =>  (_rating.base * fuel_cost + _rating.peak * fuel_cost) * pow(10, -6);

  double getUpkeepCost(double profit_per_mw, double peak_frac) => _upkeep * profit_per_mw *(_rating.base  + _rating.peak * peak_frac);
      

}
