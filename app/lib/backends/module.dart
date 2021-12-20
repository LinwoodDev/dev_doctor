import 'package:dev_doctor/backends/user.dart';
import 'package:dev_doctor/widgets/error.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'entry.dart';
import 'home.dart';

class BackendsModule extends Module {
  @override
  final List<ModularRoute> routes = [
    ChildRoute('/', child: (_, args) => BackendsPage()),
    ChildRoute("/user", child: (_, args) {
      if (args.queryParams.containsKey('collectionId') &&
          args.queryParams.containsKey('user'))
        return BackendUserPage(
            model: args.data,
            collectionId: int.parse(args.queryParams['collectionId']!),
            user: args.queryParams['user']);
      return ErrorDisplay();
    }),
    ChildRoute('/entry', child: (_, args) {
      if (args.queryParams.containsKey('collectionId') &&
          args.queryParams.containsKey('user') &&
          args.queryParams.containsKey('entry'))
        return BackendPage(
            model: args.data,
            collectionId: int.parse(args.queryParams['collectionId']!),
            user: args.queryParams['user']!,
            entry: args.queryParams['entry']!);
      return ErrorDisplay();
    })
  ];
}
