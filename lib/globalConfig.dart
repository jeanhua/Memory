import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:path_provider/path_provider.dart';

class GlobalConfig {
  static List<themeColor> theme = [
    themeColor(const Color(0xffF5ECD7), const Color(0xff71c4ef),
        const Color(0xffebe2cd), const Color(0xff1d1c1c)),
    themeColor(const Color(0xffE0F2F1), const Color(0xff26A69A),
        const Color(0xff80CBC4), const Color(0xff263339)),
    themeColor(const Color(0xffD6C6E1), const Color(0xff6c35de),
        const Color(0xffcb80ff), const Color(0xffffffff)),
    themeColor(const Color(0xffDDDDDD), const Color(0xff658864),
        const Color(0xff8FBC8F), const Color(0xff292524)),
  ];
  // <-----------------------------配置项开始----------------------------->
  static int nowTheme = 0;
  // <-----------------------------配置项结束----------------------------->
  static String toJson() {
    return jsonEncode({
      "nowTheme": nowTheme,
    });
  }

  static writeConfig() async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String appDocPath = appDocDir.path;
    File("$appDocPath/config.json").writeAsStringSync(toJson());
  }

  static readConfig() async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String appDocPath = appDocDir.path;
    try {
      String configText = File("$appDocPath/config.json").readAsStringSync();
      nowTheme = jsonDecode(configText)["nowTheme"];
    } catch (e) {
      nowTheme = 0;
    }
    if (!(nowTheme <= 3 && nowTheme >= 0)) {
      nowTheme = 0;
    }
  }
}

class themeColor {
  Color backgroundColor;
  Color primaryColor;
  Color accentColor;
  Color textColor;
  themeColor(this.backgroundColor, this.primaryColor, this.accentColor,
      this.textColor);
}
