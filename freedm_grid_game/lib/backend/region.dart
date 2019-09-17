import 'package:freedm_grid_game/interface.dart';
import 'package:freedm_grid_game/backend/generator.dart';
import 'package:freedm_grid_game/backend/power.dart';
import 'dart:math';

dynamic regionTypeFromString(String reg_type) =>
    regionType.values.firstWhere((f) => f.toString() == 'regionType.$reg_type', orElse: () => null);

class Region implements RegionInterface{
  List<Generator> _generators;
  Power _load;
  double _profit_per_mw;

  List<Generator> get generators => _generators;
  Power get load => _load;

  Power get supply {
    Power min = Power(0.0, 0.0);
    Power max = Power(0.0, 0.0);
    generators.forEach((generator) {
        if (generator.isOwned && generator.isRunning && generator.isBuilt) {   
          min += generator.min_rating;
          max += generator.max_rating;
        }
    });
    //auto match supply and load if load is within range of supply
      return Power(_findSupply(min.base, max.base, _load.base), _findSupply(min.peak, max.peak, _load.peak));
  }
  
  Region(int profit_per_mw, double begin_base_load, double begin_peak_load) {
    _generators = List();
    _load = Power(begin_base_load, begin_peak_load);
    (profit_per_mw != null) ? _profit_per_mw = profit_per_mw *365*24* pow(10, -6): _profit_per_mw = 0.0;
  }

  factory Region.fromJson(Map<String, dynamic> reg_json){
    return new  Region(
      reg_json["begin_profit_per_mw"],
      reg_json["begin_base_load"],
      reg_json["begin_peak_load"]
    ); 
  }

  efficiencyType get efficiency {
    Power net = supply - _load;
    if       (net.base < 0 && net.peak < 0)  return efficiencyType.underPowered;
    else if  (net.base < 0 && net.peak > 0 && (net.base + net.peak) < 0) return efficiencyType.underPowered;
    else if  (net.base < 0 && net.peak > 0) return efficiencyType.inefficient;
    else if  (net.base ==  0 && net.peak < 0)  return efficiencyType.missedPeak;
    else if  (net.base > 0)  return efficiencyType.staticOverload;
    else if  (net.base == 0 && net.peak >= 0)  return efficiencyType.efficient;
    else return efficiencyType.inefficient;
  }

  double generatorRevenue() {
    double round(double n, int deg){
      return (n * pow(10,deg)).round()/pow(10,deg);
    }
    double revenue = 0;

    //gross profit = profit for amount of power consumed
    if (supply.base < _load.base)
      revenue = round(_profit_per_mw * supply.base, 3);
    else
      revenue = round(_profit_per_mw* _load.base, 3);

    if (supply.peak < _load.peak)
      revenue += round(_profit_per_mw * supply.peak,3);
    else
      revenue += round(_profit_per_mw * _load.peak, 3);

    return revenue;
  }

  void nextYear() => _load += Power(120, 500);

  double generatorCosts() {
    double sum = 0;
    _generators.forEach((generator) {
        //TEMPORARY - peak power, if greater than total peak power, is divided among the given generators. If a proper divide is greater than 
        if (generator.isOwned && generator.isRunning) sum += generator.getUpkeepCost(_profit_per_mw, (supply.peak > _load.peak)? _generators.length / supply.peak : 1.0);        
    });
    return sum; // return in millions
  }

  void setStateGenerators(List<Generator> generators) {
    _generators += generators;
  }

  void addGenerator(Generator generator) {
    _generators.add(generator);
  }


  double _findSupply(double supply_min, double supply_max, double load){
      if ( supply_min < load && load < supply_max) return load;
      else if ( supply_min > load) return supply_min;
      else return supply_max;
  }

}
