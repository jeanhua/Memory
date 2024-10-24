import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'MainControl.dart';
import 'addPage.dart';
import 'detail_page.dart';
import 'globalConfig.dart';
import 'memoryClass.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return HomePageState();
  }
}

class HomePageState extends State<HomePage> {
  List? record = [];
  List<MemoryClass> showRecord = [];
  ScrollController scrollController = ScrollController();
  List<MemoryClass> willDeleted = [];
  bool checkMode = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Core.mainPageUpdate = updatePage;
    ready();
  }

  void ready() async {
    showRecord.clear();
    await DB.openDataBase();
    record = await DB.getAll();
    for (var i in record!) {
      MemoryClass newItem = MemoryClass(
          timestamp: i!['timestamp'], detail: i!["detail"], title: i!["title"]);
      showRecord.add(newItem);
    }
    setState(() {});
  }

  void updatePage() {
    setState(() {});
  }

  items(MemoryClass content, context) {
    return Padding(
        padding: const EdgeInsets.all(10),
        child: GestureDetector(
          onLongPress: () async {
            int operator = 0;
            await showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Center(
                      child: Text("操作"),
                    ),
                    content: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                            onPressed: () {
                              operator = 1;
                              Navigator.of(context).pop();
                            },
                            icon: const Icon(
                              Icons.delete,
                              size: 30,
                              color: Colors.red,
                            )),
                        IconButton(
                            onPressed: () {
                              operator = 2;
                              Navigator.of(context).pop();
                            },
                            icon: const Icon(
                              Icons.copy,
                              size: 30,
                              color: Colors.green,
                            )),
                        IconButton(
                            onPressed: () {
                              operator = 3;
                              Navigator.of(context).pop();
                            },
                            icon: const Icon(
                              Icons.checklist,
                              size: 30,
                              color: Colors.green,
                            )),
                      ],
                    ),
                  );
                });
            if (operator == 1) {
              await DB.delete(content.timestamp);
              showRecord.remove(content);
              setState(() {});
            } else if (operator == 2) {
              Clipboard.setData(ClipboardData(
                  text:
                      "标题：${content.title}\n${DateParse.parseFromStamp(int.parse(content.timestamp))}\n---\n${content.detail}"));
              ScaffoldMessenger.of(context)
                  .showSnackBar(const SnackBar(content: Text("已复制内容至粘贴版")));
            } else if (operator == 3) {
              setState(() {
                willDeleted.add(content);
                checkMode = true;
              });
            }
          },
          onTap: () async {
            // 点击事件
            if (checkMode == false) {
              var popData = await Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => DetailPage(
                        pushData: content,
                      )));
              if (popData != null) {
                if (popData == 1) {
                  showRecord.remove(content);
                }
              }
            } else {
              if (willDeleted.contains(content)) {
                willDeleted.remove(content);
              } else {
                willDeleted.add(content);
              }
            }
            setState(() {});
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: 250,
            decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                      color: willDeleted.contains(content)
                          ? Colors.red
                          : Colors.black,
                      blurRadius: 2,
                      spreadRadius: willDeleted.contains(content)?5:2)
                ],
                color: GlobalConfig.theme[GlobalConfig.nowTheme].accentColor,
                border: const Border(
                    top: BorderSide(),
                    left: BorderSide(),
                    bottom: BorderSide(),
                    right: BorderSide(),),
                borderRadius: BorderRadius.circular(20)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        content.title,
                        style: const TextStyle(
                            fontSize: 40, color: Colors.black87),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
                const Divider(
                  thickness: 2,
                ),
                Container(
                  height: 140,
                  decoration: BoxDecoration(
                      color: GlobalConfig
                          .theme[GlobalConfig.nowTheme].accentColor),
                  child: Row(
                    children: [
                      Expanded(
                        child: Markdown(data: content.detail,physics: const NeverScrollableScrollPhysics(),),
                      ),
                    ],
                  ),
                ),
                Expanded(child: Container()),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        "${DateParse.parseFromStamp(int.parse(content.timestamp))}"
                            .split('.')[0],
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: GlobalConfig
                                .theme[GlobalConfig.nowTheme].primaryColor),
                      ),
                    ),
                    Visibility(
                      visible: willDeleted.contains(content),
                      child: const Icon(Icons.check_circle,color: Colors.green,),
                    )
                  ],
                )
              ],
            ),
          ),
        ));
  }

  @override
  Widget build(BuildContext context_main) {
    Core.nowContext = context_main;
    // TODO: implement build
    return Stack(
      children: [
        ListView.builder(
          controller: scrollController,
          itemCount: showRecord.length + 1,
          itemBuilder: (context, index) {
            if (index == showRecord.length) {
              if(showRecord.length==0){
                return const Center(
                  child: Text("空空如也，等待你的注入！"),
                );
              }
              else{
                return const Center(
                  child: Text("没有更多内容了"),
                );
              }
            }
            return items(showRecord[index], context);
          },
        ),
        Visibility(
          visible: !checkMode,
          child: Positioned(
              right: 20,
              bottom: 80,
              child: Container(
                decoration: BoxDecoration(
                    color: const Color.fromARGB(220, 255, 255, 255),
                    borderRadius: BorderRadius.circular(35)),
                child: IconButton.outlined(
                  onPressed: () async {
                    var res = await Navigator.of(context_main).push(
                        MaterialPageRoute(
                            builder: (context) => const AddPage()));
                    if (res != null) {
                      ready();
                    }
                  },
                  icon: const Icon(
                    Icons.add_box,
                    size: 50,
                    color: Colors.redAccent,
                  ),
                ),
              )),
        ),
        Visibility(
          visible: checkMode,
          child: Positioned(
              right: 20,
              bottom: 80,
              child: Container(
                decoration: BoxDecoration(
                    color: const Color.fromARGB(220, 255, 255, 255),
                    borderRadius: BorderRadius.circular(35)),
                child: IconButton.outlined(
                  onPressed: () async {
                    int operation = 0;
                    await showDialog(context: context, builder: (context){
                      return AlertDialog(
                        title: const Text(
                          "警告！",
                          style: TextStyle(color: Colors.red),
                        ),
                        content:Text(
                          "您确定删除这些记忆吗？\n(已选中${willDeleted.length}项)",
                          style: const TextStyle(fontSize: 20),
                        ),
                        actions: [
                          Row(
                            children: [
                              TextButton(
                                  onPressed: () {
                                    Navigator.of(context)
                                        .pop();
                                  },
                                  child: const Text(
                                    "取消",
                                    style: TextStyle(
                                        fontSize: 20),
                                  )),
                              Expanded(child: Container()),
                              TextButton(
                                  onPressed: () async {
                                    for(var i in willDeleted){
                                      showRecord.remove(i);
                                      await DB.delete(i.timestamp);
                                    }
                                    Navigator.of(context).pop();
                                    setState(() {});
                                  },
                                  child: const Text(
                                    "确定",
                                    style: TextStyle(
                                        fontSize: 20),
                                  )),
                            ],
                          )
                        ],
                      );
                    });
                  },
                  icon: const Icon(
                    Icons.delete,
                    size: 50,
                    color: Colors.redAccent,
                  ),
                ),
              )),
        ),
        Visibility(
          visible: checkMode,
          child: Positioned(
              right: 20,
              bottom: 150,
              child: Container(
                decoration: BoxDecoration(
                    color: const Color.fromARGB(220, 255, 255, 255),
                    borderRadius: BorderRadius.circular(35)),
                child: IconButton.outlined(
                  onPressed: () async {
                    setState(() {
                      willDeleted.clear();
                      checkMode = false;
                    });
                  },
                  icon: const Icon(
                    Icons.turn_left,
                    size: 50,
                    color: Colors.green,
                  ),
                ),
              )),
        )
      ],
    );
  }
}
