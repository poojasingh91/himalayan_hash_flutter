import 'package:flutter/material.dart';

class BaseAlertDialog extends StatelessWidget {
  //When creating please recheck 'context' if there is an error!

  final Color _color = const Color.fromARGB(220, 117, 218, 255);

  String _title = '';
  String _content = '';
  String _yes = '';
  String _no = '';
  Function _yesOnPressed = () {};
  Function _noOnPressed = () {};

  BaseAlertDialog(
      {String? title,
      String? content,
      Function? yesOnPressed,
      Function? noOnPressed,
      String? yes = "Yes",
      String? no = "No"}) {
    _title = title!;
    _content = content!;
    _yesOnPressed = yesOnPressed!;
    _noOnPressed = noOnPressed!;
    _yes = yes!;
    _no = no!;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(_title),
      content: Text(_content),
      backgroundColor: _color,
      shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      actions: <Widget>[
        TextButton(
          child: Text(_yes),
          onPressed: () {
            Navigator.pop(context, 'Yes');
            // this._yesOnPressed();
          },
        ),
        TextButton(
          child: Text(_no),
          onPressed: () {
            // this._noOnPressed();
            Navigator.pop(context, 'No');
          },
        ),
      ],
    );
  }
}
