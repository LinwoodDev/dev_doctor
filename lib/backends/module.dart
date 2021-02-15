import 'package:dev_doctor/courses/course.dart';
import 'package:dev_doctor/courses/part/module.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'details.dart';
import 'home.dart';

class BackendsModule extends Module {
  @override
  List<ModularRoute> get routes => [
        ChildRoute('/', child: (_, args) => BackendsPage()),
        ChildRoute('/details',
            child: (_, args) => BackendPage(
                model: args.data,
                collectionId: int.parse(args.queryParams['collectionId']),
                user: args.queryParams['user'],
                entry: args.queryParams['entry']))
      ];
}
