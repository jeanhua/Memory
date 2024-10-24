import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:memory/memoryClass.dart';
import 'package:url_launcher/url_launcher.dart';
import 'MainControl.dart';
import 'globalConfig.dart';

class DetailPage extends StatefulWidget {
  const DetailPage({super.key, required this.pushData});
  final MemoryClass pushData;
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return DetailPageState();
  }
}

class DetailPageState extends State<DetailPage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController detailController = TextEditingController();
  ScrollController scrollController = ScrollController();
  double _previousBottomInset = 0.0;
  bool showIconButton = true;
  bool contentChanged = false;
  bool enableMarkdown = true;
  String nowContent = "";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    titleController.text = widget.pushData.title;
    detailController.text = widget.pushData.detail;
    nowContent = widget.pushData.detail;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Core.nowContext = context;
    // 使用MediaQuery来监听底部插入值的变化
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    // 检查底部插入值是否发生变化
    if (bottomInset > 0 && _previousBottomInset == 0) {
      // 键盘弹出
      setState(() {
        showIconButton = false;
      });
    } else if (bottomInset == 0 && _previousBottomInset > 0) {
      // 键盘收起
      setState(() {
        showIconButton = true;
      });
    }
    _previousBottomInset = bottomInset;
    // TODO: implement build
    return PopScope(
        onPopInvokedWithResult: (isret, _) async {
          bool ret = false;
          if (contentChanged) {
            await showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text(
                      "警告！",
                      style: TextStyle(fontSize: 20, color: Colors.redAccent),
                    ),
                    content: const Text("您还未保存,是否确认退出?"),
                    actions: [
                      TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text("取消")),
                      TextButton(
                          onPressed: () {
                            ret = true;
                            Navigator.of(context).pop();
                          },
                          child: const Text("确认"))
                    ],
                  );
                });
            if (ret) {
              Navigator.of(context).pop();
            }
          }
        },
        canPop: !contentChanged,
        child: Scaffold(
            appBar: AppBar(
              title: const Text("Memory"),
              leading: IconButton(
                  onPressed: () async {
                    bool ret = false;
                    if (contentChanged) {
                      await showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text(
                                "警告！",
                                style: TextStyle(
                                    fontSize: 20, color: Colors.redAccent),
                              ),
                              content: const Text("您还未保存,是否确认退出?"),
                              actions: [
                                TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text("取消")),
                                TextButton(
                                    onPressed: () {
                                      ret = true;
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text("确认"))
                              ],
                            );
                          });
                      if (ret) {
                        Navigator.of(context).pop();
                      }
                    } else {
                      Navigator.of(context).pop();
                    }
                  },
                  icon: const Icon(Icons.arrow_back)),
              backgroundColor: Colors.transparent,
            ),
            backgroundColor:
                GlobalConfig.theme[GlobalConfig.nowTheme].accentColor,
            body: SizedBox(
              width: MediaQuery.sizeOf(context).width,
              height: MediaQuery.sizeOf(context).height,
              child: Stack(
                children: [
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                  width: MediaQuery.sizeOf(context).width - 20,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.white54,
                                    ),
                                    child: TextField(
                                      onChanged: (_) {
                                        contentChanged = true;
                                      },
                                      decoration: InputDecoration(
                                          helperText: "标题",
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          )),
                                      style: const TextStyle(fontSize: 20),
                                      controller: titleController,
                                    ),
                                  ))
                            ],
                          ),
                        ),
                        const Divider(
                          height: 20,
                        ),
                        Scrollbar(
                            thickness: 8,
                            trackVisibility: true,
                            thumbVisibility: true,
                            radius: const Radius.circular(10),
                            child: ConstrainedBox(
                                constraints: BoxConstraints(
                                    maxWidth:
                                        MediaQuery.sizeOf(context).width - 20,
                                    maxHeight:
                                        MediaQuery.sizeOf(context).height - 320,
                                    minWidth:
                                        MediaQuery.sizeOf(context).width - 20),
                                child: enableMarkdown
                                    ? Markdown(
                                    data: nowContent,
                                  onTapLink: (text,href,title){
                                      launchUrl(Uri.parse(href!));
                                  },
                                )
                                    : TextField(
                                        onChanged: (_) {
                                          contentChanged = true;
                                          nowContent = detailController.text;
                                        },
                                        decoration: const InputDecoration(
                                            helperText: "内容",
                                            border: OutlineInputBorder(),
                                            filled: true,
                                            fillColor: Colors.white),
                                        controller: detailController,
                                        maxLines: null,
                                      )))
                      ],
                    ),
                  ),
                  Visibility(
                    visible: showIconButton,
                    child: Positioned(
                      bottom: 20,
                      left: MediaQuery.sizeOf(context).width / 2 - 175,
                      child: Container(
                        width: 350,
                        height: 80,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            color: const Color.fromARGB(150, 255, 255, 255)),
                        child: Row(
                          children: [
                            IconButton(
                                onPressed: () {
                                  // 删除
                                  showDialog(
                                      context: context,
                                      barrierDismissible: false,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: const Text(
                                            "警告！",
                                            style: TextStyle(color: Colors.red),
                                          ),
                                          content: const Text(
                                            "您确定删除此记忆吗？",
                                            style: TextStyle(fontSize: 20),
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
                                                      await DB.delete(widget
                                                          .pushData.timestamp);
                                                      Navigator.of(context)
                                                          .pop();
                                                      Navigator.of(context)
                                                          .pop(1);
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
                                  size: 60,
                                  color: Colors.red,
                                )),
                            Expanded(
                              child: Container(),
                            ),
                            IconButton(
                                onPressed: () {
                                  //分享
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: const Center(
                                            child: Text(
                                              "分享",
                                              style: TextStyle(fontSize: 20),
                                            ),
                                          ),
                                          content: SizedBox(
                                            height: 100,
                                            child: Column(
                                              children: [
                                                TextButton(
                                                    onPressed: () {
                                                      Clipboard.setData(
                                                          ClipboardData(
                                                              text:
                                                                  "标题：${super.widget.pushData.title}\n${DateParse.parseFromStamp(int.parse(super.widget.pushData.timestamp))}\n---\n${super.widget.pushData.detail}"));
                                                      Navigator.of(context)
                                                          .pop();
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                              const SnackBar(
                                                                  content: Text(
                                                                      "已复制内容至粘贴版")));
                                                    },
                                                    child: const Text("分享为文本")),
                                                TextButton(
                                                    onPressed: () {
                                                      var jsonMessage = {};
                                                      jsonMessage["title"] =
                                                          super
                                                              .widget
                                                              .pushData
                                                              .title;
                                                      jsonMessage["date"] =
                                                          "${DateParse.parseFromStamp(int.parse(super.widget.pushData.timestamp))}";
                                                      jsonMessage['content'] =
                                                          super
                                                              .widget
                                                              .pushData
                                                              .detail;
                                                      Clipboard.setData(
                                                          ClipboardData(
                                                              text: jsonEncode(
                                                                  jsonMessage)));
                                                      Navigator.of(context)
                                                          .pop();
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                              const SnackBar(
                                                                  content: Text(
                                                                      "已复制内容至粘贴版")));
                                                    },
                                                    child:
                                                        const Text("分享为json")),
                                              ],
                                            ),
                                          ),
                                        );
                                      });
                                },
                                icon: const Icon(
                                  Icons.share,
                                  size: 60,
                                  color: Colors.amber,
                                )),
                            Expanded(
                              child: Container(),
                            ),
                            IconButton(
                                iconSize: 60,
                                color: Colors.green,
                                onPressed: (){
                                  if(enableMarkdown){
                                    setState(() {
                                      enableMarkdown = false;
                                    });
                                  }
                                  else{
                                    setState(() {
                                      enableMarkdown = true;
                                    });
                                  }
                                },
                                icon: const Icon(Icons.code,)),
                            Expanded(
                              child: Container(),
                            ),
                            IconButton(
                                iconSize: 60,
                                color: Colors.green,
                                onPressed: () async {
                                  // 保存按钮点击
                                  await DB.update(
                                      widget.pushData.timestamp,
                                      titleController.text,
                                      detailController.text);
                                  widget.pushData.title = titleController.text;
                                  widget.pushData.detail =
                                      detailController.text;
                                  contentChanged = false;
                                  await showDialog(
                                      context: context,
                                      barrierDismissible: false,
                                      builder: (context) {
                                        return AlertDialog(
                                          icon: const Icon(Icons.check_box),
                                          content: const Text("保存完成"),
                                          actions: [
                                            TextButton(
                                                onPressed: () {
                                                  Map popData = {};
                                                  popData['title'] =
                                                      titleController.text;
                                                  popData['detail'] =
                                                      detailController.text;
                                                  Navigator.of(context).pop();
                                                },
                                                child: const Text("确定"))
                                          ],
                                        );
                                      });
                                  Navigator.of(context).pop();
                                },
                                icon: const Icon(Icons.check_circle)),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            )));
  }
}
