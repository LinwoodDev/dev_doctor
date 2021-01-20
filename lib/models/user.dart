import 'package:dev_doctor/models/server.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:yaml/yaml.dart';

@HiveType(typeId: 0)
class User {
  @HiveField(0)
  String name;
  @HiveField(1)
  List<String> servers;

  Future<List<CoursesServer>> fetchServers() => Future.wait(
      servers.asMap().map((index, value) => MapEntry(index, fetchServer(index))).values);
  Future<CoursesServer> fetchServer(int index) async {
    var server = servers[index];
    var response = await http.get("$server/config.yml");
    var data = loadYaml(response.body);
    data['url'] = server;
    return CoursesServer.fromJson(data);
  }
}
