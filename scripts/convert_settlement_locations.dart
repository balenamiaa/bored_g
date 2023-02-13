import 'dart:convert';
import 'dart:io';

import 'package:bored_g/locations/types.dart';
import 'gamexy_conv.dart';

List<Location> extractData() {
  var result = List<Location>.empty(growable: true);

  var dataStr = File("cp_rawdata/names").readAsStringSync();
  RegExp('(?:Settlement|Camp|Local)_(.*)[^]*?name = "(.*)"[^]*?position\\[\\] = {(.*),(.*)}[^]*?type = "(.*)";')
      .allMatches(dataStr)
      .forEach((e) {
    var englishName = e.group(1)!.toLowerCase();
    var russianName = e.group(2)!.toLowerCase();
    var x = double.parse(e.group(3)!);
    var y = double.parse(e.group(4)!);
    var typeStr = e.group(5)?.toLowerCase() ?? "";

    switch (typeStr) {
      case "city":
      case "village":
      case "capital":
      case "camp":
      case "local":
        result.add(Location(englishName, russianName, convertGameXToNormX(x),
            convertGameYToNormY(y), LocationType.values.byName(typeStr)));
        break;
      default:
        break;
    }
  });

  return result;
}

void main() {
  stdout.write(jsonEncode({'locations': extractData()},
      toEncodable: (x) => Location.toJson(x as Location)));
}
