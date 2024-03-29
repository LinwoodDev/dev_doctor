import 'package:dev_doctor/courses/part/bloc.dart';
import 'package:dev_doctor/courses/part/quiz.dart';
import 'package:dev_doctor/courses/part/text.dart';
import 'package:dev_doctor/models/editor/server.dart';
import 'package:dev_doctor/models/item.dart';
import 'package:dev_doctor/models/items/quiz.dart';
import 'package:dev_doctor/models/items/text.dart';
import 'package:dev_doctor/models/items/video.dart';
import 'package:dev_doctor/models/part.dart';
import 'package:dev_doctor/widgets/error.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:dev_doctor/courses/part/video.dart'
    if (dart.library.html) 'package:dev_doctor/courses/part/video_web.dart'
    if (dart.library.io) 'package:dev_doctor/courses/part/video_mobile.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import 'bloc.dart';
import 'layout.dart';

class PartItemPage extends StatefulWidget {
  final PartItem? model;
  final int itemId;
  final ServerEditorBloc? editorBloc;

  const PartItemPage(
      {Key? key, this.model, required this.itemId, this.editorBloc})
      : super(key: key);

  @override
  _PartItemPageState createState() => _PartItemPageState();
}

class _PartItemPageState extends State<PartItemPage> {
  late CoursePartBloc bloc;
  final GlobalKey _itemKey = GlobalKey();
  final ScrollController _detailsScrollController = ScrollController();
  final ScrollController _itemScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _buildBloc();
  }

  @override
  void didUpdateWidget(PartItemPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    setState(() {});
  }

  Future<void> _buildBloc() async {
    bloc = Modular.get<CoursePartBloc>();
    await bloc.fetchFromParams(editorBloc: widget.editorBloc);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<CoursePart>(
        stream: bloc.partSubject,
        builder: (context, snapshot) {
          if (snapshot.hasError || bloc.hasError) return const ErrorDisplay();
          if (!snapshot.hasData ||
              snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          var part = snapshot.data!;
          if (part.items.isEmpty) {
            return PartItemLayout(
                part: part,
                editorBloc: widget.editorBloc,
                itemId: widget.itemId,
                child: Center(child: Text('course.part.empty'.tr())));
          }
          var itemId = widget.itemId;
          if (itemId < 0) itemId = 0;
          if (itemId >= part.items.length) itemId = part.items.length - 1;
          var item = part.items[itemId];
          Widget itemWidget = const Text("Not supported!");
          if (item is VideoPartItem) {
            itemWidget = VideoPartItemPage(
                part: part,
                item: item,
                key: _itemKey,
                editorBloc: widget.editorBloc,
                itemId: itemId);
          }
          if (item is TextPartItem) {
            itemWidget = TextPartItemPage(
                part: part,
                item: item,
                key: _itemKey,
                editorBloc: widget.editorBloc,
                itemId: itemId);
          }
          if (item is QuizPartItem) {
            itemWidget = QuizPartItemPage(
                part: part,
                item: item,
                key: _itemKey,
                editorBloc: widget.editorBloc,
                itemId: itemId);
          }
          final itemBuilder = Builder(builder: (context) => itemWidget);
          return PartItemLayout(
              part: part,
              editorBloc: widget.editorBloc,
              itemId: widget.itemId,
              child: LayoutBuilder(builder: (context, constraints) {
                var itemCard = Scrollbar(
                    controller: _detailsScrollController,
                    child: SingleChildScrollView(
                        controller: _detailsScrollController,
                        child: Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16)),
                            child: Padding(
                                padding: const EdgeInsets.all(64.0),
                                child: itemBuilder))));
                var detailsCard = Scrollbar(
                    controller: _itemScrollController,
                    child: SingleChildScrollView(
                        controller: _itemScrollController,
                        child: Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16)),
                            child: Padding(
                                padding: const EdgeInsets.all(64.0),
                                child: Row(children: [
                                  Expanded(
                                      child: Column(children: [
                                    Text(item.name,
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline5),
                                    Text(item.description)
                                  ])),
                                  if (widget.editorBloc != null)
                                    IconButton(
                                      tooltip: "edit".tr(),
                                      icon:
                                          const Icon(PhosphorIcons.pencilLight),
                                      onPressed: () => Modular.to.pushNamed(Uri(
                                          pathSegments: [
                                            '',
                                            'editor',
                                            'course',
                                            'item',
                                            'edit'
                                          ],
                                          queryParameters: {
                                            ...Modular.args.queryParams
                                          }).toString()),
                                    )
                                  else if (item.allowReset)
                                    IconButton(
                                        tooltip: "reset".tr(),
                                        icon: const Icon(PhosphorIcons
                                            .clockCounterClockwiseLight),
                                        onPressed: () {
                                          part.removeItemPoints(itemId);
                                          bloc.partSubject.add(part);
                                        })
                                ])))));
                if (MediaQuery.of(context).size.width > 1000) {
                  return Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(child: detailsCard),
                        Expanded(flex: 3, child: itemCard)
                      ]);
                } else {
                  return Scrollbar(
                      child: SingleChildScrollView(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [detailsCard, itemCard])));
                }
              }));
        });
  }
}
