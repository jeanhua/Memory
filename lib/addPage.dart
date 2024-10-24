import 'package:flutter/material.dart';
import 'MainControl.dart';
import 'globalConfig.dart';

class AddPage extends StatefulWidget {
  const AddPage({super.key});
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return AddPageState();
  }
}

class AddPageState extends State<AddPage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController detailController = TextEditingController();
  double _previousBottomInset = 0.0;
  bool showIconButton = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context_main) {
    Core.nowContext = context_main;
    // 使用MediaQuery来监听底部插入值的变化
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    // 检查底部插入值是否发生变化
    if (bottomInset > 0 && _previousBottomInset == 0) {
      // 键盘弹出
      print('键盘弹出');
      setState(() {
        showIconButton = false;
      });
    } else if (bottomInset == 0 && _previousBottomInset > 0) {
      // 键盘收起
      print('键盘收起');
      setState(() {
        showIconButton = true;
      });
    }
    _previousBottomInset = bottomInset;
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          title: const Text("Memory"),
          backgroundColor: Colors.transparent,
        ),
        backgroundColor: GlobalConfig.theme[GlobalConfig.nowTheme].accentColor,
        body: SizedBox(
          width: MediaQuery.sizeOf(context_main).width,
          height: MediaQuery.sizeOf(context_main).height,
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
                            width: MediaQuery.sizeOf(context).width-20,
                              child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white54,
                            ),
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: "标题",
                                  border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
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
                                  MediaQuery.sizeOf(context_main).width - 20,
                              maxHeight:
                                  MediaQuery.sizeOf(context_main).height - 300,
                              minWidth:
                                  MediaQuery.sizeOf(context_main).width - 20),
                          child: TextField(
                            decoration: const InputDecoration(
                              hintText: "内容",
                                border: OutlineInputBorder(),
                                filled: true,
                                fillColor: Colors.white),
                            controller: detailController,
                            maxLines: null,
                          ),
                        ))
                  ],
                ),
              ),
              Visibility(
                visible: showIconButton,
                child: Positioned(
                  bottom: 30,
                  right: 20,
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        color: const Color.fromARGB(150, 255, 255, 255)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                            iconSize: 60,
                            color: Colors.green,
                            onPressed: () async {
                              // 保存按钮点击
                              if (titleController.text == "") {
                                showDialog(
                                    context: context_main,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: const Text(
                                          "警告！",
                                          style: TextStyle(color: Colors.red),
                                        ),
                                        content: const Text("标题不能为空！"),
                                        actions: [
                                          TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: const Text("确定"))
                                        ],
                                      );
                                    });
                                return;
                              }
                              await DB.insert(
                                  titleController.text, detailController.text);
                              Navigator.of(context_main).pop(1);
                            },
                            icon: const Icon(Icons.check_circle)),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
