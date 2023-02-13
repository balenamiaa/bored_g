import 'dart:convert';
import 'dart:io';

import 'package:bored_g/locations/types.dart';
import 'package:quiver/iterables.dart';

import 'gamexy_conv.dart';

final hospitalRegex = RegExp(r'Land_.*_Hospital[^]*?pos="(.*?) (.*?) (.*?)"');
final medicalCenterRegex =
    RegExp(r'Land_.*_HealthCare[^]*?pos="(.*?) (.*?) (.*?)"');

void main() {
  var mapGroupPosStr = File("cp_rawdata/mapGroupPos.xml").readAsStringSync();

  var hospitals = hospitalRegex.allMatches(mapGroupPosStr).map((e) {
    var x = double.parse(e.group(1)!);
    var y = double.parse(e.group(3)!);

    return PinkLocation.fromXY(PinkLocationType.hospital,
        convertGameXToNormX(x), convertGameYToNormY(y));
  });

  var medicalcenters = medicalCenterRegex.allMatches(mapGroupPosStr).map((e) {
    var x = double.parse(e.group(1)!);
    var y = double.parse(e.group(3)!);

    return PinkLocation.fromXY(PinkLocationType.medicalcenter,
        convertGameXToNormX(x), convertGameYToNormY(y));
  });

  stdout.write(
    jsonEncode(
      {
        'pink_locations': merge([hospitals, medicalcenters]).toList(),
      },
      toEncodable: (nonEncodable) =>
          PinkLocation.toJson(nonEncodable as PinkLocation),
    ),
  );
}
