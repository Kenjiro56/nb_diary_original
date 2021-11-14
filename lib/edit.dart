import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class Edit extends StatelessWidget {
  String _current;
  final Function _onChanged;

  Edit(this._current, this._onChanged, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
            'Edit',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        actions: <Widget>[
          ElevatedButton(
            // onPressed: () => FocusScope.of(context).requestFocus(FocusNode()),
            onPressed: () => Navigator.of(context).pop(),
            child: const Icon(
              Icons.check,
              color: Colors.black
            ),
            style: ElevatedButton.styleFrom(
              primary: const Color(0xFFefefef),//ボタンの背景色
            ),
            //shape: CircleBorder(side: BorderSide(color: Colors.transparent)),
          ),
        ],
        leading: ElevatedButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
          ),
          style: ElevatedButton.styleFrom(
            primary: const Color(0xFFefefef),//ボタンの背景色
          ),
          //shape: CircleBorder(side: BorderSide(color: Colors.transparent)),
        ),
        backgroundColor: const Color(0xFFefefef),
      ),
      body: Container(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            controller: TextEditingController(text: _current),
            maxLines: 99,
            style: const TextStyle(color: Colors.black),
            onChanged: (text) {
              _current = text;
              _onChanged(_current);
            },
          )),
    );
  }
}