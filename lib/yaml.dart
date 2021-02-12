import 'package:yaml/yaml.dart';

Map<String, dynamic> yamlMapToJson(YamlMap yaml) {
  return Map<String, dynamic>.from(yaml).map((key, value) {
    if (value is YamlMap) return MapEntry(key, yamlMapToJson(value));
    if (value is YamlList) return MapEntry(key, yamlListToJson(value));
    return MapEntry(key, value);
  });
}

List<dynamic> yamlListToJson(YamlList yaml) {
  return List<dynamic>.from(yaml).map((e) {
    if (e is YamlMap) return yamlMapToJson(e);
    if (e is YamlList) return yamlListToJson(e);
    return e;
  }).toList();
}
