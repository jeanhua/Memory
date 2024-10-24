import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:memory/globalConfig.dart';

class ThemePage extends StatefulWidget {
  const ThemePage({super.key});
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return ThemePageState();
  }
}

class ThemePageState extends State<ThemePage> {
  boxdecoration(int index, bool select) {
    return BoxDecoration(
        color: GlobalConfig.theme[index].accentColor,
        borderRadius: BorderRadius.circular(20),
        border: select == true
            ? Border.all(
                width: 4,
                color: Colors.redAccent,
              )
            : const Border(),
        boxShadow: select == true
            ? <BoxShadow>[const BoxShadow(blurRadius: 20, color: Colors.redAccent)]
            : <BoxShadow>[const BoxShadow()]);
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.sizeOf(context);
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          title: const Text("主题设置"),
        ),
        backgroundColor: GlobalConfig.theme[GlobalConfig.nowTheme].backgroundColor,
        body: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: GestureDetector(
                      onTap: () {
                        if (GlobalConfig.nowTheme != 0) {
                          setState(() {
                            GlobalConfig.nowTheme = 0;
                          });
                        }
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 500),
                        width: screenSize.width - 50,
                        height: 150,
                        decoration: GlobalConfig.nowTheme == 0
                            ? boxdecoration(0, true)
                            : boxdecoration(0, false),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "杏色森林",
                              style: TextStyle(
                                  color: GlobalConfig.theme[0].textColor,
                                  fontSize: 30),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: GestureDetector(
                      onTap: (){
                        if (GlobalConfig.nowTheme != 1) {
                          setState(() {
                            GlobalConfig.nowTheme = 1;
                          });
                        }
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 500),
                        width: screenSize.width - 50,
                        height: 150,
                        decoration: GlobalConfig.nowTheme == 1
                            ? boxdecoration(1, true)
                            : boxdecoration(1, false),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "深蓝湖泊",
                              style: TextStyle(
                                  color: GlobalConfig.theme[1].textColor,
                                  fontSize: 30),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: GestureDetector(
                      onTap: (){
                        if (GlobalConfig.nowTheme != 2) {
                          setState(() {
                            GlobalConfig.nowTheme = 2;
                          });
                        }
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 500),
                        width: screenSize.width - 50,
                        height: 150,
                        decoration: GlobalConfig.nowTheme == 2
                            ? boxdecoration(2, true)
                            : boxdecoration(2, false),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "紫色视野",
                              style: TextStyle(
                                  color: GlobalConfig.theme[2].textColor,
                                  fontSize: 30),
                            )
                          ],
                        ),
                      ),
                    )
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: GestureDetector(
                      onTap: (){
                        if (GlobalConfig.nowTheme != 3) {
                          setState(() {
                            GlobalConfig.nowTheme = 3;
                          });
                        }
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 500),
                        width: screenSize.width - 50,
                        height: 150,
                        decoration: GlobalConfig.nowTheme == 3
                            ? boxdecoration(3, true)
                            : boxdecoration(3, false),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "绿色归宿",
                              style: TextStyle(
                                  color: GlobalConfig.theme[3].textColor,
                                  fontSize: 30),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ));
  }
}
