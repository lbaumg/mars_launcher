import 'package:flutter/material.dart';
import 'package:mars_launcher/data/app_info.dart';
import 'package:mars_launcher/logic/theme_logic.dart';

typedef OpenAppCallback = Function(AppInfo appInfo);

class TodoListCard extends StatelessWidget {
  final int index;
  final String todo;
  final callbackRemoveFromTodos;

  TodoListCard({required this.index, required this.todo, required this.callbackRemoveFromTodos});

  @override
  Widget build(BuildContext context) {
    var fontFamily = FONT_LIGHT;
    var textColor = Theme.of(context).primaryColor;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.6
          ),
          child: TextButton(
            onPressed: () {},
            child: Text(
              todo,
              overflow: TextOverflow.ellipsis, // Specify how to handle overflow
              maxLines: 2,
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.w100,
                fontFamily: fontFamily,
              ),
            ),
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all(textColor),
            ),
          ),
        ),
        IconButton(
            onPressed: () {
              callbackRemoveFromTodos(index);
            },
            icon: Icon(
              Icons.remove,
              size: 15,
            )
        )
      ],
    );
  }
}
