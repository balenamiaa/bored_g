import 'dart:convert';

import 'package:flutter/services.dart';

import 'globals.dart';

late Map<String, List<dynamic>> cpData;

Future<void> loadCpData() async {
  cpData = (jsonDecode(await rootBundle.loadString(cpDataPath))
          as Map<String, dynamic>)
      .map((key, value) => MapEntry(key, value as List<dynamic>));
}
