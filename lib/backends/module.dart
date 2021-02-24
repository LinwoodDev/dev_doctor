import 'package:dev_doctor/backends/user.dart';
import 'package:dev_doctor/models/collection.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'entry.dart';
import 'home.dart';

class BackendsModule extends Module {
  @override
  final List<ModularRoute> routes = [
    ChildRoute('/', child: (_, args) => BackendsPage()),
    ChildRoute("/user", child: (_, args) {
      //print("User will be rendered with argument ${args.data}");
      return BackendUserPage(
          model: args.data is BackendUser ? args.data : null,
          collectionId: int.parse(args.queryParams['collectionId']),
          user: args.queryParams['user']);
    }),
    ChildRoute('/entry', child: (_, args) {
      //print("Entry will be rendered with argument ${args.data}");
      return BackendPage(
          model: args.data,
          collectionId: int.parse(args.queryParams['collectionId']),
          user: args.queryParams['user'],
          entry: args.queryParams['entry']);
    })
  ];
}
