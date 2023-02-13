import 'dart:convert';
import 'dart:io';

import 'package:bored_g/locations/types.dart';
import 'package:quiver/iterables.dart';

import 'gamexy_conv.dart';

final policeStationRegex =
    RegExp(r'Land_.*_PoliceStation[^]*?pos="(.*?) (.*?) (.*?)"');
final fireStationRegex =
    RegExp(r'Land_.*_FireStation[^]*?pos="(.*?) (.*?) (.*?)"');

void main() {
  var mapGroupPosStr = File("cp_rawdata/mapGroupPos.xml").readAsStringSync();

  var policeStations = policeStationRegex.allMatches(mapGroupPosStr).map((e) {
    var x = double.parse(e.group(1)!);
    var y = double.parse(e.group(3)!);

    return RedLocation.fromXY(RedLocationType.policestation,
        convertGameXToNormX(x), convertGameYToNormY(y));
  });

  var fireStations = fireStationRegex.allMatches(mapGroupPosStr).map((e) {
    var x = double.parse(e.group(1)!);
    var y = double.parse(e.group(3)!);

    return RedLocation.fromXY(RedLocationType.firestation,
        convertGameXToNormX(x), convertGameYToNormY(y));
  });

  stdout.write(
    jsonEncode(
      {
        'red_locations': merge([policeStations, fireStations]).toList(),
      },
      toEncodable: (nonEncodable) =>
          RedLocation.toJson(nonEncodable as RedLocation),
    ),
  );
}
