import 'package:flutter_modular/flutter_modular.dart';

import 'bloc.dart';
import 'details.dart';
import 'home.dart';

class ArticlesModule extends Module {
  @override
  List<ModularRoute> get routes => [
        ChildRoute('/', child: (_, args) => const ArticlesPage()),
        ChildRoute('/details',
            child: (_, args) => ArticlePage(model: args.data))
      ];
  @override
  List<Bind<Object>> get binds => [Bind.singleton((i) => ArticleBloc())];
}
