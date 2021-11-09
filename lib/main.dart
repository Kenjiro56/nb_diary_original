import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Diary_basic',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'YYYY/MM/DD(Fri)'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: ListView(
      children: <Widget>[
        _newstopic(),
        _newstopic(),
        _newstopic(),
      ],
      ),
    );
  }
  Widget _newstopic(){
    return Column(
      children: [
        ListTile(
          title: Text('YouTuber結婚'),
          subtitle: Text('hogehogehogehogehogehogehogehogehogeaaasasaaaaaas'),
          isThreeLine: true,
          tileColor: Colors.deepOrange[100],
        ),
        Card(
          child: Image.asset('images/sample.png'),
        ),

        //もし入力されてたらその内容を表示する用
        // ListTile(
        //   title: Text('一言メモ'),
        //   subtitle: Text('hogehogehogehogehogehogehogehogehogehogehogehogehogehogehoge'),
        //   isThreeLine: true,
        // ),
        RaisedButton(
          onPressed: null,
          child: Text('一言メモを書く'),
          color: Colors.blue,
        ),
      ],
    );
  }
}
