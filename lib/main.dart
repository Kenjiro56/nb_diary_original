import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:diary_basic/edit.dart';
import 'package:news_api_flutter_package/model/article.dart';
import 'package:news_api_flutter_package/model/error.dart';
//import 'package:news_api_flutter_package/model/source.dart';
import 'package:news_api_flutter_package/news_api_flutter_package.dart';
import '../config.dart';
//import 'package:url_launcher/link.dart';
import 'package:url_launcher/url_launcher.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Diary_basic',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: "2021年 11月 14日"),
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
  final NewsAPI _newsAPI = NewsAPI(API_KEY);
  // ignore: deprecated_member_use
  var _memoList = <String>[];
  var _currentIndex = -1;
  //bool _loading = true;

  @override
  void initState() {
    super.initState();
    this.loadMemoList();
  }

  void loadMemoList() {
    SharedPreferences.getInstance().then((prefs) {
      const key = "memo-list";
      if (prefs.containsKey(key)) {
        _memoList = prefs.getStringList(key)!;
      }

      setState(() {
        //_loading = false;
      });
    });
  }

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
    }else{
      debugPrint("store success");
    }
  }

  @override
  Widget build(BuildContext context) {
    //final items = _news;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          style: TextStyle(
            color: Color(0xFF555647),
          ),
        ),
        backgroundColor: Color(0xFFefefef),
      ),
      body: _newsTile(),
    );
  }

  Widget _newsTile() {
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
    for (int i = 0; i < articles.length; i++) {
      _memoList.add("");
    }
    return ListView.builder(
      itemCount: articles.length,
      itemBuilder: (context, index) {
        Article article = articles[index];
        final memo = _memoList[index];
            return _newstopic(memo, index, article);
      },
    );
  }

  Widget _newsLap(bool _expanstion){
    return ExpansionTile(
      title: Text('もっとニュースを見る'),
      trailing: Icon(
        _expanstion
            ? Icons.arrow_drop_down_circle
            : Icons.arrow_drop_down,
      ),
    );
  }

  Widget _newstopic(String content, int index, Article article) {
    return Column(
      children: [
        ListTile(
          title: Text(
            article.title!,
            maxLines: 3,
            style: TextStyle(
              color: Color(0xFF1f2326),
              fontSize: 15,
            ),
          ),
          subtitle: Text(
            //article.description ?? "",
            article.source.name!,
            maxLines: 2,
            style: TextStyle(
              color: Color(0xFF1f2326),
              fontSize: 10,
            ),
          ),
          leading: article.urlToImage == null
              ? null
              : Image.network(
                  article.urlToImage!,
                  // width: 150
          ),
          tileColor: Color(0xFFe6bfb2),
            onTap: () => onLaunchUrl(article.url!),
        ),
        content == "" ? _nullContent(index) : _showContent(content, index),
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


  Future onLaunchUrl (String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    }
  }


  //一言メモ未記入時に表示させるウィジェット
  Widget _nullContent(int index) {
    return ElevatedButton(
      onPressed: () {
        _currentIndex = index;
        Navigator.of(context)
            .push(MaterialPageRoute<void>(builder: (BuildContext context) {
          return new Edit(_memoList[_currentIndex], _onChanged);
        }));
      },
      child: Text('一言メモを書く'),
      style: ElevatedButton.styleFrom(
        primary: Color(0xFFffa07a),
      ),
    );
  }

  //一言メモ記入時に表示させるウィジェット
  Widget _showContent(String content, int index) {
    return Card(
      margin: EdgeInsets.all(10),
      elevation: 10,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      shadowColor: Colors.black,
      child: Column(
        children: [
          ListTile(
              title: Text(
                  '一言メモ',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline,
                  decorationColor: Color(0xFFffa07a),
                  decorationThickness: 3,
                  //decorationStyle: TextDecorationStyle.double,
                ),
              ),
              subtitle: Text(
                  content,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 13,
                ),
              ),
              isThreeLine: true,
              onTap: () {
                _currentIndex = index;
                Navigator.of(context)
                    .push(MaterialPageRoute<void>(builder: (BuildContext context) {
                  return new Edit(_memoList[_currentIndex], _onChanged);
                }));
              }),
          ButtonBar(
          alignment: MainAxisAlignment.center,
          children: [
              OutlinedButton(
              child: Text(
                  'Delete',
                  style: TextStyle(
                    color: Color(0xFFffa07a),
                  ),
              ),
              onPressed: () {},
              ),
              OutlinedButton(
              child: Text(
                  'Edit',
                  style: TextStyle(
                    color: Color(0xFFffa07a),
                  ),
              ),
              onPressed: () {},
              )
          ],
          ),
      ],
      ),
    );
  }
}
