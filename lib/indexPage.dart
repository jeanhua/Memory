import 'package:flutter/material.dart';
import 'package:memory/aboutPage.dart';
import 'package:memory/searchPage.dart';
import 'globalConfig.dart';
import 'homePage.dart';

class IndexPage extends StatefulWidget {
  const IndexPage({super.key});
  @override
  State<StatefulWidget> createState() {
    return IndexPageState();
  }
}

class IndexPageState extends State<IndexPage> {
  final List<BottomNavigationBarItem> bottomNavItems = [
    const BottomNavigationBarItem(
      backgroundColor: Colors.transparent,
      icon: Icon(Icons.home),
      label: "记忆",
    ),
    const BottomNavigationBarItem(
      backgroundColor: Colors.transparent,
      icon: Icon(Icons.search),
      label: "搜索"
    ),
    const BottomNavigationBarItem(
      backgroundColor: Colors.transparent,
      icon: Icon(Icons.person),
      label: "关于"
    ),
  ];

  late int currentIndex;
  String appBarText = "Memory";
  final pages = [const HomePage(),SearchPage(), AboutPage()];

  @override
  void initState() {
    super.initState();
    currentIndex = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            appBarText,style: TextStyle(color: GlobalConfig.theme[GlobalConfig.nowTheme].textColor),
          ),
        ),
        backgroundColor: Colors.transparent,
      ),
      backgroundColor: GlobalConfig.theme[GlobalConfig.nowTheme].backgroundColor,
      bottomNavigationBar: BottomNavigationBar(
        items: bottomNavItems,
        currentIndex: currentIndex,
        type: BottomNavigationBarType.shifting,
        onTap: (index) {
          _changePage(index);
        },
      ),
      body: pages[currentIndex],
    );
  }

  /*切换页面*/
  void _changePage(int index) {
    /*如果点击的导航项不是当前项  切换 */
    if (index != currentIndex) {
      setState(() {
        if(index==0){
          appBarText = "memory";
        }
        else if(index==1){
          appBarText = "搜索";
        }else if(index==2){
          appBarText = "关于";
        }
        currentIndex = index;
      });
    }
  }
}

