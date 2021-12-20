import 'package:dev_doctor/courses/part/item.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'bloc.dart';

class CoursePartModule extends Module {
  @override
  List<ModularRoute> get routes => [
        ChildRoute('/item',
            transition: TransitionType.defaultTransition,
            child: (_, args) => PartItemPage(
                model: args.data,
                itemId: int.parse(args.queryParams['itemId'] ?? '0')))
      ];

  @override
  List<Bind<Object>> get binds => [Bind.singleton((i) => CoursePartBloc())];
}
