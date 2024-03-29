import 'package:dev_doctor/courses/details.dart';
import 'package:dev_doctor/courses/part/bloc.dart';
import 'package:dev_doctor/models/course.dart';
import 'package:dev_doctor/models/editor/server.dart';
import 'package:dev_doctor/models/part.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

typedef NavigateCallback = void Function(int part);

class CoursePartDrawer extends StatefulWidget {
  final int? partId;
  final Course? course;
  final NavigateCallback? onChange;
  final ServerEditorBloc? editorBloc;

  const CoursePartDrawer(
      {Key? key, this.course, this.partId, this.onChange, this.editorBloc})
      : super(key: key);
  @override
  _CoursePartDrawerState createState() => _CoursePartDrawerState();
}

class _CoursePartDrawerState extends State<CoursePartDrawer> {
  int? partId;

  Future<List<CoursePart>> _buildFuture() async {
    if (widget.editorBloc != null) {
      return widget.editorBloc!.getCourse(widget.course!.slug).parts;
    }
    return await widget.course!.fetchParts();
  }

  @override
  Widget build(BuildContext context) {
    var supportUrl = widget.course?.supportUrl ??
        widget.course?.server?.supportUrl ??
        widget.editorBloc?.server.supportUrl;
    return Drawer(
        child: Scrollbar(
            child: ListView(children: [
      ListTile(
        title: const Text('course.back').tr(),
        leading: const Icon(PhosphorIcons.arrowArcLeftLight),
        onTap: () {
          Navigator.of(context).pop();
          Navigator.of(context).pop();
        },
      ),
      if (supportUrl != null)
        ListTile(
          title: const Text('course.support').tr(),
          onTap: () => launchUrl(Uri.parse(supportUrl)),
          leading: const Icon(PhosphorIcons.questionLight),
        ),
      const Divider(),
      FutureBuilder<List<CoursePart>>(
          future: _buildFuture(),
          builder: (context, snapshot) {
            if (!snapshot.hasData ||
                snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) return Text("Error: ${snapshot.error}");
            var parts = snapshot.data!;
            var args = Modular.args.queryParams;
            return Column(
                children: List.generate(parts.length, (index) {
              var part = parts[index];
              var selected = args['partId'] != null
                  ? args['partId'] == index.toString()
                  : args['part'] == part.slug;
              return ListTile(
                title: Text(part.name),
                subtitle: Text(part.description),
                selected: selected,
                trailing: selected && widget.editorBloc != null
                    ? IconTheme(
                        data: Theme.of(context).iconTheme,
                        child: EditorCoursePartPopupMenu(
                            bloc: widget.editorBloc!,
                            partBloc: Modular.get<CoursePartBloc>()))
                    : null,
                onTap: () {
                  setState(() => partId = index);
                  widget.onChange!(index);
                },
                isThreeLine: true,
              );
            }));
          })
    ])));
  }
}
