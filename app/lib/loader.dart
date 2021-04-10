import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:yaml/yaml.dart';
import 'yaml.dart';

Future<Map<String, dynamic>?> loadFile(String path, {String? type}) async {
  try {
    var result = await loadJsonFile(path) ?? {};
    if (type == null) result['type'] = 'json';
    return result;
  } catch (e) {
    var result = await loadYamlFile(path);
    if (type == null && result != null) result['type'] = 'yml';
    return result;
  }
}

Future<Map<String, dynamic>?> loadJsonFile(String path) async {
  var response = await http.get(Uri.parse(path + ".json"));
  return json.decode(utf8.decode(response.bodyBytes));
}

Future<Map<String, dynamic>?> loadYamlFile(String path) async {
  try {
    var response = await http.get(Uri.parse(path + ".yml"));
    return yamlMapToJson(loadYaml(utf8.decode(response.bodyBytes)));
  } catch (e) {
    print(e);
  }

  return null;
}
