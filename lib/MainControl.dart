import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sqflite/sqflite.dart';

class Core {
  static late VoidCallback mainPageUpdate;
  static late BuildContext nowContext;
  static getPermission_storage() async {
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      status = await Permission.storage.request();
    }
    if (status.isGranted) {
      return true;
    } else if (status.isPermanentlyDenied) {
      // 用户选择永久拒绝权限
      await showDialog(
          context: nowContext,
          builder: (context) {
            return AlertDialog(
              title: const Text(
                "警告！",
                style: TextStyle(color: Colors.red),
              ),
              content: const Text("请开启存储权限！"),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text("确定"))
              ],
            );
          });
      openAppSettings();
      return false;
    } else {
      // 用户选择拒绝权限
      await showDialog(
          context: nowContext,
          builder: (context) {
            return AlertDialog(
              title: const Text(
                "警告！",
                style: TextStyle(color: Colors.red),
              ),
              content: const Text("请开启存储权限！"),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text("确定"))
              ],
            );
          });
      return false;
    }
  }
}

class DateParse {
  static parseFromStamp(int datestamp) {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(datestamp);
    String dateString = dateTime.toString();
    return dateString;
  }
}

class DB {
  static Database? database;
  static openDataBase() async {
    database = await openDatabase(join(await getDatabasesPath(), "database.db"),
        version: 3, onCreate: (Database db, int version) async {
      // When creating the db, create the table
      await db.execute(
          'CREATE TABLE schedule (timestamp TEXT PRIMARY KEY,title TEXT,detail TEXT)');
    });
  }

  static removeDatabase() async {
    if (database != null) {
      if (database!.isOpen) {
        await database!.close();
        database = null;
      }
    }
    deleteDatabase(join(await getDatabasesPath(), "database.db"));
  }

  static insert(String title, String detail) async {
    await database?.transaction((txn) async {
      await txn.rawInsert(
          'INSERT INTO schedule(timestamp, title, detail) VALUES(\'${DateTime.now().millisecondsSinceEpoch}\', \'$title\', \'$detail\')');
    });
  }

  static delete(String timestamp) async {
    await database
        ?.rawDelete('DELETE FROM schedule WHERE timestamp = ?', [timestamp]);
  }

  static update(String timestamp, String title, String detail) async {
    int? res = await database?.rawUpdate(
        'UPDATE schedule SET title = ?, detail = ? WHERE timestamp = ?',
        [title, detail, timestamp]);
  }

  static getAll() async {
    if (database == null) return null;
    List<Map> list;
    list = await database!
        .rawQuery('SELECT * FROM schedule ORDER BY timestamp DESC');
    return list;
  }

  static find({timestamp, content}) async {
    List<Map> list = [];
    if (timestamp != null) {
      list = await database!
          .rawQuery('SELECT * FROM schedule WHERE timestamp = ?', [timestamp]);
    } else if (content != null) {
      list = await database!.rawQuery(
          'SELECT * FROM schedule WHERE title LIKE ? OR detail LIKE ?',
          ['%$content%', '%$content%']);
    }
    return list;
  }
}
