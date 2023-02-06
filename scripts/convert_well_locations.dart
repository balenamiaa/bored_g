import 'dart:convert';
import 'dart:io';

import 'package:bored_g/types.dart';

import 'gamexy_conv.dart';

final wellPumpRegex = RegExp(r'Land_.*_Well_Pump[^]*?pos="(.*?) (.*?) (.*?)"');

void main() {
  var mapGroupPosStr = File("cp_rawdata/mapGroupPos.xml").readAsStringSync();

  stdout.write(
    jsonEncode(
      {
        'well_pumps': wellPumpRegex.allMatches(mapGroupPosStr).map((e) {
          var x = double.parse(e.group(1)!);
          var y = double.parse(e.group(3)!);

          return WellPumpLocation.fromXY(convertGameXToNormX(x), convertGameYToNormY(y));
        }).toList(),
      },
      toEncodable: (nonEncodable) => WellPumpLocation.toJson(nonEncodable as WellPumpLocation),
    ),
  );
}
