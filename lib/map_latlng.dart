import 'package:flutter_map/plugin_api.dart';
import 'package:tuple/tuple.dart';

double latFromNormY(double normY) => -90 + normY * 1.8;
double lngFromNormX(double normX) => -180 + normX * 3.6;

class DayZCrs extends CrsSimple {
  @override
  Transformation get transformation => const Transformation(1 / 360, 0.5, -1 / 180, 0.5);

  @override
  String get code => 'CRS.DayZ';

  @override
  Tuple2<double, double>? get wrapLat => null;

  @override
  Tuple2<double, double>? get wrapLng => null;
}
