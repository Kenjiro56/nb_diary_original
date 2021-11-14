import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class newsComment{

final int? id;
final String imageUrl;
final String title;
final String source;
final String comment;
final String date;
final String url;

  newsComment({
    this.id,
    required this.imageUrl,
    required this.title,
    required this.source,
    required this.comment,
    required this.date,
    required this.url,
  });
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'imageUrl': imageUrl,
      'title': title,
      'source': source,
      'comment': comment,
      'date': date,
      'url': url
    };
  }

  static Future<Database> get database async {
    // openDatabase() データベースに接続
    final Future<Database> _database = openDatabase(
      // getDatabasesPath() データベースファイルを保存するパス取得
      join(await getDatabasesPath(), 'news_memo_database.db'),
      onCreate: (db, version) {
        return db.execute(
          // テーブルの作成
          "CREATE TABLE memo(id INTEGER PRIMARY KEY AUTOINCREMENT, imageUrl TEXT, title TEXT, source TEXT,comment TEXT,date TEXT)",
        );
      },
      version: 1,
    );
    return _database;
  }

  static Future<void> insertComment(newsComment comment) async {
    final Database db = await database;
    await db.insert(
      'comment',
      comment.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<List<newsComment>> getComment() async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query('comment');
    return List.generate(maps.length, (i) {
      return newsComment(
        id: maps[i]['id'],
        imageUrl: maps[i]['imageUrl'],
        title: maps[i]['title'],
        source: maps[i]['source'],
        comment: maps[i]['comment'],
        date: maps[i]['date'],
        url: maps[i]['url']
      );
    });
  }

  static Future<void> updateComment(newsComment comment) async {
    // Get a reference to the database.
    final db = await database;
    await db.update(
      'comment',
      comment.toMap(),
      where: "id = ?",
      whereArgs: [comment.id],
      conflictAlgorithm: ConflictAlgorithm.fail,
    );
  }

  static Future<void> deleteComment(int id) async {
    final db = await database;
    await db.delete(
      'comment',
      where: "id = ?",
      whereArgs: [id],
    );
  }
}
