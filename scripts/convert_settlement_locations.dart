import 'dart:convert';
import 'dart:io';

import 'package:bored_g/types.dart';

import 'gamexy_conv.dart';

List<Location> extractData() {
  var result = List<Location>.empty(growable: true);

  var dataStr = File("./names").readAsStringSync();
  RegExp('(?:Settlement|Camp|Local)_(.*)[^]*?position\\[\\] = {(.*),(.*)}[^]*?type = "(.*)";').allMatches(dataStr).forEach((e) {
    var englishName = e.group(1)!.toLowerCase();
    var x = double.parse(e.group(2)!);
    var y = double.parse(e.group(3)!);
    var typeStr = e.group(4)?.toLowerCase() ?? "";

    switch (typeStr) {
      case "city":
      case "village":
      case "capital":
      case "camp":
      case "local":
        result.add(Location(englishName, convertGameXToNormX(x), convertGameYToNormY(y), LocationType.values.byName(typeStr)));
        break;
      default:
        break;
    }
  });

  return result;
}

void main() {
  stdout.write(jsonEncode({'locations': extractData()}, toEncodable: (x) => Location.toJson(x as Location)));
}
