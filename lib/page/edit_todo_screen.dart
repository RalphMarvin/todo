import 'package:flutter/material.dart';
import 'package:todo/model/todo_model.dart';
import 'package:todo/utils/color_utils.dart';
import 'package:todo/model/hero_id_model.dart';
import 'package:todo/component/todo_badge.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:todo/model/todo_list_model.dart';

class EditTodoScreen extends StatefulWidget {
  final String taskId;
  final HeroId heroIds;
  final String taskName;

  EditTodoScreen({
    @required this.taskId,
    @required this.heroIds,
    @required this.taskName
  });

  @override
  State<StatefulWidget> createState() {
    return _EditTodoScreenState();
  }
}

class _EditTodoScreenState extends State<EditTodoScreen> {

  String newtask;
  TextEditingController newTaskCtrl = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    setState(() {
     newtask = widget.taskName; 
     newTaskCtrl.text = widget.taskName;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<TodoListModel>(
      builder: (BuildContext context, Widget child, TodoListModel model) {
        if (model.tasks.isEmpty) {
          // Loading
          return Container(
            color: Colors.white,
          );
        }

        var task = model.tasks.firstWhere((t) => t.id == widget.taskId);
        var color = ColorUtils.getColorFrom(id: task.color);
        return Scaffold(
          key: _scaffoldKey,
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: Text(
              'Edit Task',
              style: TextStyle(color: Colors.black),
            ),
            centerTitle: true,
            elevation: 0,
            iconTheme: IconThemeData(color: Colors.black26),
            brightness: Brightness.light,
            backgroundColor: Colors.white,
          ),
          body: Container(
            constraints: BoxConstraints.expand(),
            padding: EdgeInsets.symmetric(horizontal: 36.0, vertical: 36.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'What task are you planning to perform ?',
                  style: TextStyle(
                    color: Colors.black38,
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600
                  )
                ),
                Container(height: 16.0,),
                TextField(
                  cursorColor: color,
                  autofocus: true,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Your Task ...',
                    hintStyle: TextStyle(
                      color: Colors.black26
                    )
                  ),
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 32.0,
                    fontWeight: FontWeight.w500
                  ),
                  textCapitalization: TextCapitalization.sentences,
                  controller: newTaskCtrl,
                ),
                Container(height: 26.0,),
                Row(
                  children: [
                    TodoBadge(
                      codePoint: task.codePoint,
                      color: color,
                      id: widget.heroIds.codePointId,
                      size: 20.0,
                    ),
                    Container(
                      width: 16.0,
                    ),
                    Hero(
                      child: Text(
                        task.name,
                        style: TextStyle(
                          color: Colors.black38,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      tag: "not_using_right_now", //widget.heroIds.titleId,
                    ),
                  ],
                )
              ],
            ),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
          floatingActionButton: Builder(
            builder: (BuildContext context) {
              return FloatingActionButton.extended(
                heroTag: 'fab_new_task',
                icon: Icon(Icons.add),
                backgroundColor: color,
                label: Text('Save New'),
                onPressed: () {
                  if (newtask.isEmpty) {
                    final snackbar = SnackBar(
                      content: Text(
                        'Ummm... Its seems that you are trying to edit an invisible task which is not allowed in this realm'
                      ),
                      backgroundColor: color,
                      duration: Duration(seconds: 5),
                    );
                    Scaffold.of(context).showSnackBar(snackbar);
                  }
                  else {
                    model.updateTodo(Todo(
                      newtask,
                      parent: task.id
                    ));
                    Navigator.pop(context);
                  }
                },
              );
            },
          ),
        );
      },
    );
  }
}

// Reason for wraping fab with builder (to get scafold context)
// https://stackoverflow.com/a/52123080/4934757