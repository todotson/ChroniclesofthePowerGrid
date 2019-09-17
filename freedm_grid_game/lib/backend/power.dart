import 'package:freedm_grid_game/interface.dart';

class Power implements PowerInterface {
  final double _base;
  final double _peak;

  double get base => _base;
  double get peak => _peak;

  Power(this._base, this._peak);

  PowerInterface operator +(PowerInterface power) => Power(_base+power.base, _peak+power.peak);
  PowerInterface operator -(PowerInterface power) => Power(_base-power.base, _peak-power.peak);
}
