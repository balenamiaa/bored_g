import 'dart:convert';
import 'dart:io';

import 'location_entries.dart';

void main() {
  var mapGroupPosStr = File("cp_rawdata/mapGroupPos.xml").readAsStringSync();
  var output = StringBuffer();

  for (var entry in entries) {
    output.write(
      jsonEncode(
        {
          entry.listName: entry.regex.allMatches(mapGroupPosStr).map((e) {
            var x = double.parse(e.group(1)!);
            var y = double.parse(e.group(3)!);

            return entry.fromXY(x, y);
          }).toList(),
        },
        toEncodable: (nonEncodable) => entry.toJson(nonEncodable),
      ),
    );
  }

  stdout.write(output.toString().replaceAll("}{", ","));
}
