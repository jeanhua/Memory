import 'package:flutter/material.dart';
import 'package:memory/MainControl.dart';
import 'package:memory/addPage.dart';
import 'package:memory/indexPage.dart';
import 'package:memory/memoryClass.dart';
import 'detail_page.dart';
import 'globalConfig.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      theme: ThemeData(fontFamily: "CommonBlack"),
      home:PreLoadPage(),
    );
  }
}

class PreLoadPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return PreLoadPageState();
  }
}

class PreLoadPageState extends State<PreLoadPage>{

  late BuildContext context_main;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    init();
  }

  init() async {
    await GlobalConfig.readConfig();
    await Future.delayed(const Duration(seconds: 1));
    Navigator.of(context_main).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>const IndexPage()),(context)=>const IndexPage()==null);
  }

  @override
  Widget build(BuildContext context) {
    context_main = context;
    // TODO: implement build
    return SizedBox(
      width: MediaQuery.sizeOf(context).width,
      height: MediaQuery.sizeOf(context).height,
      child: Container(
        decoration: const BoxDecoration(color: Colors.white),
        child:  Image.asset("assets/images/icon.png",width: 200,color: Colors.redAccent,),
      ),
    );
  }
}