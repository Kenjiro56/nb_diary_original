import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:diary_basic/edit.dart';
import 'package:news_api_flutter_package/model/article.dart';
import 'package:news_api_flutter_package/model/error.dart';
import 'package:news_api_flutter_package/model/source.dart';
import 'package:news_api_flutter_package/news_api_flutter_package.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Diary_basic',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: "YYYY/MM/DD(Fri)"),
    );
  }
}

class MyHomePage extends StatefulWidget{
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  final NewsAPI _newsAPI = NewsAPI("9e19803975c54b378596c9cd1e079579");
  // ignore: deprecated_member_use
  var _memoList = <String>["","","","",""];
  //var _memoist = []..length = articles.length;
  var _currentIndex = -1;
  int _news = 5;
  // bool _loading = true;
  // final _biggerFont = const TextStyle(fontSize: 18.0);

  @override
  void initState(){
    super.initState();
    //this.loadMemoList();
  }

  // void loadMemoList() {
  //   SharedPreferences.getInstance().then((prefs) {
  //     const key = "memo-list";
  //     if (prefs.containsKey(key)) {
  //       _memoList = prefs.getStringList(key)!;
  //     }
  //     setState(() {
  //       _loading = false;
  //     });
  //   });
  // }

  // void _addMemo() {
  //   setState(() {
  //     _memoList.add("");
  //     _currentIndex = _memoList.length - 1;
  //     storeMemoList();
  //     Navigator.of(context).push(MaterialPageRoute<void>(
  //       builder: (BuildContext context) {
  //         return new Edit(_memoList[_currentIndex], _onChanged);
  //       },
  //     ));
  //   });
  // }

  void _onChanged(String text) {
    setState(() {
      _memoList[_currentIndex] = text;
      storeMemoList();
    });
  }

  void storeMemoList() async {
    final prefs = await SharedPreferences.getInstance();
    const key = "memo-list";
    final success = await prefs.setStringList(key, _memoList);
    if (!success) {
      debugPrint("Failed to store value");
    }
  }

  @override
  Widget build(BuildContext context) {

    //final items = _news;
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
         body: _newsTile(),
    //   ListView.builder(
    //     padding: const EdgeInsets.all(16.0),
    //     itemCount: items,
    //     itemBuilder: /*1*/ (context, i) {
    //       if (i.isOdd) return Divider(height: 2);
    //       final index = (i / 2).floor();
    //       final memo = _memoList[index];
    //       return _newstopic(memo, index);
    //     }
    // ),
    );
  }

  Widget _newsTile(){
    return FutureBuilder<List<Article>>(
        future: _newsAPI.getTopHeadlines(country: "jp"),
        builder: (BuildContext context, AsyncSnapshot<List<Article>> snapshot) {
          return snapshot.connectionState == ConnectionState.done
              ? snapshot.hasData
              ? _buildArticleListView(snapshot.data!)
              : _buildError(snapshot.error as ApiError)
              : _buildProgress();
        });
  }

  Widget _buildArticleListView(List<Article> articles) {
    return ListView.builder(
      itemCount: articles.length,
      itemBuilder: (context, index) {
        Article article = articles[index];
        final memo = _memoList[index];
        return _newstopic(memo, index,article);
        //   Card(
        //   child: ListTile(
        //     title: Text(article.title!, maxLines: 2),
        //     subtitle: Text(article.description ?? "", maxLines: 3),
        //
        // );
      },
    );
  }

  Widget _newstopic(String content,int index,Article article){
    return Column(
      children: [
        ListTile(
          title: Text(article.title!, maxLines: 2),
          subtitle: Text(article.description ?? "", maxLines: 3),
          leading: article.urlToImage == null
                  ? null
                  : Image.network(article.urlToImage!),
        ),
         content == ""
          ? _nullContent(index)
          : _showContent(content, index),
      ],
    );
  }

  Widget _buildProgress() {
    return Center(child: CircularProgressIndicator());
  }

  Widget _buildError(ApiError error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              error.code ?? "",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 4),
            Text(error.message!, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }



  //一言メモ未記入時に表示させるウィジェット
  Widget _nullContent(int index){
    return RaisedButton(
      onPressed: () {
        _currentIndex = index;
        Navigator.of(context)
            .push(MaterialPageRoute<void>(builder: (BuildContext context) {
          return new Edit(_memoList[_currentIndex], _onChanged);
        }
        )
        );
      },
      child: Text('一言メモを書く'),
      color: Colors.blue,
    );
  }

  //一言メモ記入時に表示させるウィジェット
  Widget _showContent(String content,int index){
    return ListTile(
      title: Text('一言メモ'),
      subtitle: Text(content),
      isThreeLine: true,
        onTap: () {
          _currentIndex = index;
          Navigator.of(context)
              .push(MaterialPageRoute<void>(builder: (BuildContext context) {
            return new Edit(_memoList[_currentIndex], _onChanged);
          }
          )
          );
        }
    );
  }
}
  // class MemoList extends StatefulWidget{
  // @override
  // MyHomePage createState() => _MyHomePageState();
  // }


