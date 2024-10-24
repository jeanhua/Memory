import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:memory/memoryClass.dart';
import 'MainControl.dart';
import 'detail_page.dart';
import 'globalConfig.dart';

class SearchPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return SearchPageState();
  }
}

class SearchPageState extends State<SearchPage> {
  TextEditingController searchController = TextEditingController();
  List? record = [];
  List<MemoryClass> showRecord = [];
  BuildContext? waitForSearch;
  FocusNode focusNode = FocusNode();

  stopWait() {
    if (waitForSearch != null) {
      Navigator.of(waitForSearch!).pop();
      waitForSearch = null;
    }
  }

  items(MemoryClass content, context) {
    return Padding(
        padding: const EdgeInsets.all(10),
        child: GestureDetector(
          onTap: () async {
            // 点击事件
            var popData = await Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => DetailPage(
                  pushData: content,
                )));
            if (popData != null) {
              if(popData==1){
                showRecord.remove(content);
              }
            }
            setState(() {
            });
          },
          child: Container(
            height: 250,
            decoration: BoxDecoration(
                boxShadow: const [BoxShadow(color: Colors.black,blurRadius: 2,spreadRadius: 2)],
                color: GlobalConfig.theme[GlobalConfig.nowTheme].accentColor,
                border: const Border(top: BorderSide(),left: BorderSide(),bottom: BorderSide(),right: BorderSide()),
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
                const Divider(thickness: 2,),
                Container(
                  height: 140,
                  decoration: BoxDecoration(
                      color: GlobalConfig.theme[GlobalConfig.nowTheme].accentColor
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          content.detail,
                          style: TextStyle(
                              fontSize: 15, color: GlobalConfig.theme[GlobalConfig.nowTheme].textColor),
                          textAlign: TextAlign.center,
                          maxLines: 7,
                          overflow: TextOverflow.fade,
                        ),
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
                        style: TextStyle(color: GlobalConfig.theme[GlobalConfig.nowTheme].primaryColor),
                      ),
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
    // TODO: implement build
    return Stack(
      children: [
        SizedBox(
          height: MediaQuery.sizeOf(context_main).height,
          width: MediaQuery.sizeOf(context_main).width,
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                ),
                width: MediaQuery.sizeOf(context_main).width,
                child: Row(
                  children: [
                    const Text(
                      "搜索:",
                      style: TextStyle(fontSize: 25),
                    ),
                    Expanded(
                      child: TextField(
                        focusNode: focusNode,
                        autofocus: false,
                        controller: searchController,
                        decoration:
                            const InputDecoration(border: OutlineInputBorder()),
                        style: const TextStyle(fontSize: 20),
                      ),
                    ),
                    IconButton(
                        onPressed: () async {
                          // 搜索按钮
                          if(searchController.text==""){
                            FocusScope.of(context_main).requestFocus(focusNode);
                            return;
                          }
                          focusNode.unfocus();
                          showDialog(
                              context: context_main,
                              barrierDismissible: false,
                              builder: (context) {
                                waitForSearch = context;
                                return const AlertDialog(
                                  title: Center(child: Text("搜索中"),),
                                  content: Icon(Icons.running_with_errors)
                                );
                              });
                          showRecord.clear();
                          await DB.openDataBase();
                          record = await DB.find(content: searchController.text);
                          for (var i in record!) {
                            MemoryClass newItem = MemoryClass(timestamp: i!['timestamp'], detail: i!["detail"], title: i!["title"]);
                            showRecord.add(newItem);
                          }
                          Future.delayed(const Duration(milliseconds: 300),(){stopWait();});
                          setState(() {});
                        },
                        icon: const Icon(
                          Icons.search,
                          size: 30,
                        ))
                  ],
                ),
              ),
              const Divider(
                thickness: 1,
                height: 10,
                color: Colors.black,
              ),
              Expanded(
                  child: ListView.builder(
                      itemCount: showRecord.length+1,
                      itemBuilder: (context, index) {
                        if(index==showRecord.length){
                          return const Center(child: Text("无更多结果！"),);
                        }else{
                          return items(showRecord[index], context);
                        }
                      }))
            ],
          ),
        )
      ],
    );
  }
}
