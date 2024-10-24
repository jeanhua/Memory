import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:memory/MainControl.dart';
import 'package:memory/globalConfig.dart';
import 'package:memory/themePage.dart';
import 'package:sqflite/sqflite.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({super.key});
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return AboutPageState();
  }
}

class AboutPageState extends State<AboutPage> {
  output() async {
    if ((await Core.getPermission_storage()) == true) {
      String databasePath = await getDatabasesPath();
      String path = "/storage/emulated/0/Download";
      try {
        if (!Directory("$path/memory").existsSync()) {
          Directory("$path/memory").createSync();
        }
        File("$databasePath/database.db").copySync("$path/memory/output.db");
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("成功导出至$path/memory/output.db")));
      } catch (e) {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text(
                  "错误！",
                  style: TextStyle(color: Colors.redAccent),
                ),
                content: Text(e.toString()),
              );
            });
      }
    } else {
      showDialog(
          context: context,
          builder: (context) {
            return const AlertDialog(
              title: Text(
                "错误！",
                style: TextStyle(color: Colors.redAccent),
              ),
              content: Text("没有权限😡"),
            );
          });
    }
  }

  input() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles();
      if (result != null) {
        String path = result.files.single.path!;
        File file = File(path);
        if (path.endsWith(".db")) {
          String databasePath = await getDatabasesPath();
          DB.database?.close();
          file.copySync("$databasePath/database.db");
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("导入成功！")));
        } else {
          showDialog(
              context: context,
              builder: (context) {
                return const AlertDialog(
                  title: Text(
                    "错误！",
                    style: TextStyle(color: Colors.redAccent),
                  ),
                  content: Text("请选择正确的数据库文件！"),
                );
              });
        }
      } else {
        // User canceled the picker
      }
    } catch (e) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text(
                "错误！",
                style: TextStyle(color: Colors.redAccent),
              ),
              content: Text(e.toString()),
            );
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.sizeOf(context);
    // TODO: implement build
    return SizedBox(
        width: screenSize.width,
        height: screenSize.height,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: screenSize.width - 50,
                height: 150,
                decoration: BoxDecoration(
                    color:
                        GlobalConfig.theme[GlobalConfig.nowTheme].accentColor,
                    boxShadow: const [BoxShadow(color: Colors.black)],
                    border: Border.all(width: 2),
                    borderRadius: BorderRadius.circular(20)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Row(
                      children: [
                        Expanded(
                            child: Text(
                          "Memory\n一款开源轻量的记事本软件",
                          style: TextStyle(
                            fontSize: 20,
                          ),
                          textAlign: TextAlign.center,
                        )),
                      ],
                    ),
                    SelectableText(
                      "https://github.com/jeanhua/Memory",
                      style: const TextStyle(
                          color: Colors.redAccent, fontSize: 13),
                      onTap: () {
                        launchUrl(
                            Uri.parse("https://github.com/jeanhua/Memory"));
                      },
                    ),
                  ],
                ),
              ),
              const Divider(
                height: 20,
                thickness: 1,
              ),
              Padding(
                  padding: const EdgeInsets.all(5),
                  child: TextButton(
                    onPressed: () async {
                      await Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const ThemePage()));
                      setState(() {});
                      GlobalConfig.writeConfig();
                    },
                    style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all(GlobalConfig
                            .theme[GlobalConfig.nowTheme].accentColor)),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.color_lens,
                          size: 50,
                        ),
                        Text(
                          "主题",
                          style: TextStyle(
                              fontSize: 30,
                              color: GlobalConfig
                                  .theme[GlobalConfig.nowTheme].textColor),
                        )
                      ],
                    ),
                  )),
              Padding(
                  padding: const EdgeInsets.all(5),
                  child: TextButton(
                    onPressed: () {
                      output();
                    },
                    style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all(GlobalConfig
                            .theme[GlobalConfig.nowTheme].accentColor)),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.output,
                          size: 50,
                        ),
                        Text(
                          "导出",
                          style: TextStyle(
                              fontSize: 30,
                              color: GlobalConfig
                                  .theme[GlobalConfig.nowTheme].textColor),
                        )
                      ],
                    ),
                  )),
              Padding(
                  padding: const EdgeInsets.all(5),
                  child: TextButton(
                    onPressed: () async {
                      int operation = 0;
                      await showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text(
                                "警告！",
                                style: TextStyle(color: Colors.redAccent),
                              ),
                              content: const Text("此操作将会覆盖原本的数据库，是否继续操作？"),
                              actions: [
                                TextButton(
                                    onPressed: () {
                                      operation = 1;
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text("确定")),
                                TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text("取消"))
                              ],
                            );
                          });
                      if (operation == 1) {
                        input();
                      }
                    },
                    style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all(GlobalConfig
                            .theme[GlobalConfig.nowTheme].accentColor)),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.input,
                          size: 50,
                        ),
                        Text(
                          "导入",
                          style: TextStyle(
                              fontSize: 30,
                              color: GlobalConfig
                                  .theme[GlobalConfig.nowTheme].textColor),
                        )
                      ],
                    ),
                  )),
              Padding(
                  padding: const EdgeInsets.all(5),
                  child: TextButton(
                    onPressed: () async {
                      int operation = 0;
                      await showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text(
                                "警告！",
                                style: TextStyle(color: Colors.redAccent),
                              ),
                              content: const Text(
                                "此操作将会删除原本的数据库，是否继续操作？",
                                style:
                                    TextStyle(fontSize: 20, color: Colors.red),
                              ),
                              actions: [
                                TextButton(
                                    onPressed: () {
                                      operation = 1;
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text("确定")),
                                TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text("取消"))
                              ],
                            );
                          });
                      if (operation == 1) {
                        await DB.removeDatabase();
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("清除成功！")));
                      }
                    },
                    style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all(GlobalConfig
                            .theme[GlobalConfig.nowTheme].accentColor)),
                    child: const Row(
                      children: [
                        Icon(
                          Icons.output,
                          size: 50,
                          color: Colors.red,
                        ),
                        Text(
                          "清除数据库",
                          style: TextStyle(fontSize: 30, color: Colors.red),
                        )
                      ],
                    ),
                  )),
            ],
          ),
        ));
  }
}
