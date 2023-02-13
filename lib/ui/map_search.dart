import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fuzzywuzzy/fuzzywuzzy.dart';
import 'package:latlong2/latlong.dart';
import 'package:searchfield/searchfield.dart';
import 'package:tuple/tuple.dart';

import '../_flutterstyle.dart';
import '../globals.dart';
import '../locations/settlement_location_markers.dart';

List<String> pseudoCyrillicTransliteration(String input) {
  final a = input
      .replaceAll('4', 'Ч')
      .replaceAll('h', 'н')
      .replaceAll('k', 'к')
      .replaceAll('bi', 'ы')
      .replaceAll('b', 'в')
      .replaceAll('a', 'д')
      .replaceAll('n', 'и')
      .replaceAll('m', 'м')
      .replaceAll('6', 'б')
      .replaceAll('3', 'з')
      .replaceAll('r', 'я')
      .replaceAll('t', 'т')
      .replaceAll('b', 'Б')
      .replaceAll('e', 'е')
      .replaceAll('p', 'р');

  final b = a.replaceAll('и', 'П');
  final c = b.replaceAll('П', 'л');

  final ba = b.replaceAll('я', 'г');
  final ca = c.replaceAll('я', 'г');

  final baa = b.replaceAll('и', 'й');
  final baaa = baa.replaceAll('я', 'г');

  final caa = c.replaceAll('л', 'й');
  final caaa = caa.replaceAll('я', 'г');

  return [a, b, c, ba, baa, baaa, ca, caa, caaa];
}

class DayZMapSearchDialog extends ConsumerWidget {
  final FocusNode focus;

  const DayZMapSearchDialog(this.focus, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var search = SearchField<Tuple3<String, String, Marker>>(
      suggestions: settlementLocationMarkers
          .map(
            (x) => SearchFieldListItem<Tuple3<String, String, Marker>>(
              "${x.item1}\n${x.item2}",
              item: x,
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: Text(
                  "${x.item1} (${x.item2})",
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 12),
                ),
              ),
            ),
          )
          .toList(),
      comparator: (inputText, suggestionKey) {
        return (partialRatio(inputText, suggestionKey.split('\n').first) >
                70) ||
            pseudoCyrillicTransliteration(inputText)
                .any((x) => partialRatio(x, suggestionKey.split('\n')[1]) > 50);
      },
      textInputAction: TextInputAction.continueAction,
      focusNode: focus,
      onSuggestionTap: (p0) {
        Navigator.pop(context, p0.item!.item3.point);
      },
    );

    var title = const Text("Search Settlements",
        textAlign: TextAlign.center,
        style: TextStyle(
            fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold));

    return Container(
      alignment: Alignment.topCenter,
      padding: const EdgeInsets.all(16),
      child: FractionallySizedBox(
        widthFactor: 1,
        heightFactor: 0.1,
        child: Card(
          shadowColor: const Color.fromARGB(255, 143, 139, 139),
          elevation: 24,
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              children: [Flexible(child: title), search],
            ),
          ),
        ),
      ),
    );
  }
}

showSearchDialog(BuildContext context) {
  var focus = FocusNode();

  showDialog<LatLng>(
      context: context,
      builder: (cx) => DayZMapSearchDialog(focus)).then((value) {
    if (value != null) mapController.move(value, 4);
  });

  focus.requestFocus();
}
