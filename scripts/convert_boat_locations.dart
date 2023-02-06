import 'dart:convert';
import 'dart:io';

import 'package:bored_g/types.dart';

import 'gamexy_conv.dart';

final wellPumpRegex = RegExp(r'Land_Boat[^]*?pos="(.*?) (.*?) (.*?)"');

void main() {
  var mapGroupPosStr = File("cp_rawdata/mapGroupPos.xml").readAsStringSync();

  stdout.write(
    jsonEncode(
      {
        'boats': wellPumpRegex.allMatches(mapGroupPosStr).map((e) {
          var x = double.parse(e.group(1)!);
          var y = double.parse(e.group(3)!);

          return BoatLocation.fromXY(convertGameXToNormX(x), convertGameYToNormY(y));
        }).toList(),
      },
      toEncodable: (nonEncodable) => BoatLocation.toJson(nonEncodable as BoatLocation),
    ),
  );
}
