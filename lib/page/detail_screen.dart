import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import 'package:todo/model/todo_list_model.dart';
import 'package:todo/page/edit_todo_screen.dart';

import 'package:todo/task_progress_indicator.dart';
import 'package:todo/component/todo_badge.dart';
import 'package:todo/model/hero_id_model.dart';
import 'package:todo/utils/color_utils.dart';
import 'package:todo/page/add_todo_screen.dart';

class DetailScreen extends StatefulWidget {
  final String taskId;
  final HeroId heroIds;

  DetailScreen({
    @required this.taskId,
    @required this.heroIds,
  });

  @override
  State<StatefulWidget> createState() {
    return _DetailScreenState();
  }
}

class _DetailScreenState extends State<DetailScreen> with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<Offset> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    _animation = Tween<Offset>(begin: Offset(0, 1.0), end: Offset(0.0, 0.0))
        .animate(_controller);
  }

  @override
  Widget build(BuildContext context) {
    _controller.forward();
    return ScopedModelDescendant<TodoListModel>(
      builder: (BuildContext context, Widget child, TodoListModel model) {
        var _task;

        try {
         _task = model.tasks.firstWhere((it) => it.id == widget.taskId);
        } catch (e) {
          return Container(
            color: Colors.white,
          );
        }

        var _todos = model.todos.where((it) => it.parent == widget.taskId).toList();
        var _hero = widget.heroIds;
        var _color = ColorUtils.getColorFrom(id: _task.color);
        return Theme(
          data: ThemeData(primarySwatch: _color),
          child: Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              elevation: 0,
              iconTheme: IconThemeData(color: Colors.black26),
              brightness: Brightness.light,
              backgroundColor: Colors.white,
              actions: [
                SimpleAlertDialog(
                  color: _color,
                  onActionPressed: () => model.removeTask(_task),
                ),
              ],
            ),
            body: Padding(
              padding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 8.0),
              child: Column(children: [
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 36.0, vertical: 0.0),
                  height: 160,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TodoBadge(
                        color: _color,
                        codePoint: _task.codePoint,
                        id: _hero.codePointId,
                      ),
                      Spacer(
                        flex: 1,
                      ),
                      Container(
                        margin: EdgeInsets.only(bottom: 4.0),
                        child: Hero(
                          tag: _hero.remainingTaskId,
                          child: Text(
                            "${model.getTotalTodosFrom(_task)} Task",
                            style: Theme.of(context)
                              .textTheme
                              .body1
                              .copyWith(color: Colors.grey[500]),
                          ),
                        ),
                      ),
                      Container(
                        child: Hero(
                          tag: 'title_hero_unused',//_hero.titleId,
                          child: Text(_task.name,
                            style: Theme.of(context)
                              .textTheme
                              .title
                              .copyWith(color: Colors.black54)),
                        ),
                      ),
                      Spacer(),
                      Hero(
                        tag: _hero.progressId,
                        child: TaskProgressIndicator(
                          color: _color,
                          progress: model.getTaskCompletionPercent(_task),
                        ),
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(top: 16.0),
                    child: ListView.builder(
                      itemBuilder: (BuildContext context, int index) {
                        var todo = _todos[index];
                        return Container(
                          padding: EdgeInsets.only(left: 12.0, right: 12.0),
                          child: ListTile(
                            onTap: () => model.updateTodo(todo.copy(
                              isCompleted: todo.isCompleted == 1 ? 0 : 1)),
                            contentPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 8.0),
                            leading: Checkbox(
                              onChanged: (value) => model.updateTodo(
                                todo.copy(isCompleted: value ? 1 : 0)),
                              value: todo.isCompleted == 1 ? true : false),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                IconButton(
                                  icon: Icon(Icons.create),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => EditTodoScreen(taskId: widget.taskId, heroIds: _hero, taskName: todo.name,),
                                      ),
                                    );
                                  },
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete_outline),
                                  onPressed: () {
                                    SimpleAlertDialog(
                                      color: _color,
                                      onActionPressed: () => model.removeTodo(todo),
                                    );
                                  },
                                ),
                              ],
                            ),
                            title: Text(
                              todo.name,
                              style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.w600,
                                color: todo.isCompleted == 1
                                  ? _color
                                  : Colors.black54,
                                decoration: todo.isCompleted == 1
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none,
                              ),
                            ),
                          ),
                        );
                      },
                      itemCount: _todos.length,
                    ),
                  ),
                ),
              ]),
            ),
            floatingActionButton: FloatingActionButton(
              heroTag: 'fab_new_task',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddTodoScreen(taskId: widget.taskId, heroIds: _hero),
                  ),
                );
              },
              tooltip: 'New Todo',
              backgroundColor: _color,
              foregroundColor: Colors.white,
              child: Icon(Icons.add),
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

typedef void Callback();

class SimpleAlertDialog extends StatelessWidget {
  final Color color;
  final Callback onActionPressed;

  SimpleAlertDialog({
    @required this.color,
    @required this.onActionPressed,
  });

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      textColor: color,
      child: Icon(Icons.delete),
      onPressed: () {
        showDialog(
          context: context,
          barrierDismissible: false, // user must tap button!
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Delete this card?'),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    Text(
                      'This is a one way street! Deleting this will remove all the task assigned in this card.',
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                FlatButton(
                  child: Text('Delete', style: TextStyle(fontWeight: FontWeight.w500)),
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                    onActionPressed();
                  },
                ),
                FlatButton(
                  child: Text('Cancel'),
                  textColor: Colors.grey,
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }
}
