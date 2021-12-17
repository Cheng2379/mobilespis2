// ignore_for_file: avoid_unnecessary_containers, prefer_const_constructors, prefer_const_literals_to_create_immutables, sized_box_for_whitespace, use_key_in_widget_constructors, unused_field, await_only_futures, prefer_is_empty, unnecessary_this, avoid_function_literals_in_foreach_calls
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:card_swiper/card_swiper.dart';
import 'swiper_data.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        //主题颜色
        theme: ThemeData(
          primaryColor: Colors.white,
        ),
        home: Scaffold(
          //是否将body拓展到状态栏
          extendBodyBehindAppBar: false,
          //状态栏
          appBar: AppBar(
            backgroundColor: Color(0xffFFFFFF),
            elevation: 0,
            toolbarHeight: 0,
          ),
          body: Home(),
        ));
  }
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  List titleList =[];
  //设置尺寸
  void init() {
    ScreenUtil.init(
      BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width, //屏幕宽度
          maxHeight: MediaQuery.of(context).size.height //屏幕高度
      ),
      designSize: Size(360, 690), //基于360*690dp的屏幕适配
    );
    print('屏幕尺寸初始化已执行');
  }

  //获取公告信息
  getAnnouncement() async{
    var response = await http.get(Uri.parse("http://10.0.2.2:5000/api/Announcement"));
    if(response.statusCode == 200){
      var titleText = json.decode(response.body);
      titleList = titleText;
      //按时间降序排序
      titleList.sort((a,b) => b["createTime"]!.compareTo("${a["createTime"]}"));
      print('排序后：$titleList');

      titleList.forEach((element) {
        print('');
        print("id: ${element["id"]}");
        print("title: ${element["title"]}");
        print("createTime: ${element["createTime"]}");
      });

    }else{
      print('请求失败：${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    init();//初始化屏幕尺寸
    getAnnouncement();//获取公告信息

    return Container(
      color: Color(0xffF2F2F2),
      child: Column(
        children: [
          Container(
              width: MediaQuery.of(context).size.width,
              height: ScreenUtil().setHeight(1.5),
              color: Color(0xff797979),
            ),

          //标题栏
          Container(
              width: MediaQuery.of(context).size.width,
              height: ScreenUtil().setHeight(40),
              alignment: Alignment.center,
              padding: EdgeInsets.fromLTRB(10,0,10,0),
              color: Color(0xffD7D7D7),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Skyward Company Management System",
                    style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),
                  ),

                  InkWell(
                    onTap: (){
                      login();
                    },
                    child: Text("Login",
                      style: TextStyle(
                          color: Color(0xff414141),
                          fontWeight: FontWeight.w500
                      ),
                    ),
                  ),

                ],
              ),
            ),

          //轮播图
          AspectRatio(
              aspectRatio: 16/9,
              child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: ScreenUtil().setHeight(150),
                  color: Color(0xffCCCCCC),
                  margin: EdgeInsets.all(ScreenUtil().setSp(20)),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    margin: EdgeInsets.all(ScreenUtil().setSp(10)),
                    child: Swiper(
                        itemCount: swiperData.length,
                        itemBuilder: (BuildContext context, int index){
                          return Image.asset(swiperData[index],fit: BoxFit.fill);
                        },
                        //缩放动画
                        scale: 1,
                        //图片占比
                        viewportFraction: 1,
                        //指示器
                        pagination: SwiperPagination(
                          margin: EdgeInsets.fromLTRB(10, 0, 10,3),
                          //线性指示器
                          builder: RectSwiperPaginationBuilder(
                            size: Size(ScreenUtil().setWidth(35),ScreenUtil().setHeight(10)),
                            color: Colors.white,
                            activeSize: Size(ScreenUtil().setWidth(35),ScreenUtil().setHeight(10)),
                            activeColor: Color(0xffAAAAAA),
                          ),
                        )
                    ),
                  )
              ),
            ),

          //公司公告
          Container(
              height: ScreenUtil().setHeight(35),
              alignment: Alignment.centerLeft,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(topLeft: Radius.circular(3),topRight: Radius.circular(3)),
                color: Color(0xffAAAAAA),
              ),
              margin: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(10)),
              padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(20)),
              child: Text("Company Announcement",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold
                ),
              ),
            ),

          //公告信息
          Container(
            width: MediaQuery.of(context).size.width,
            height: ScreenUtil().setHeight(220),
            margin: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(10)),
            padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(20)),
            color: Colors.white,
            child: ListView.builder(
              physics: NeverScrollableScrollPhysics(),//禁止滑动
              shrinkWrap: false,
              itemCount: titleList.length,
              itemBuilder: (context,index){
                return Container(
                  alignment: Alignment.centerLeft,
                  height: ScreenUtil().setHeight(30),
                  decoration: BoxDecoration(
                      color: Color(0xffFDFDFD),
                      border: Border(
                        top: BorderSide(
                          width: 1,
                          color: Color(0xffE9EBF0)
                        ),
                        bottom: BorderSide(
                          width: 1,
                          color: Color(0xffE9EBF0)
                        ),
                      )
                    ),
                    child: Text(titleList[index]["title"],
                      style: TextStyle(
                        fontSize: ScreenUtil().setSp(12),
                        color: Colors.black87
                      ),
                    ),
                  );
                },
            ),
          )

        ],
      ),
    );
  }




  //登录
  void login(){

  }



}



