// ignore_for_file: avoid_unnecessary_containers, prefer_const_constructors, prefer_const_literals_to_create_immutables, sized_box_for_whitespace, use_key_in_widget_constructors, unused_field, await_only_futures, prefer_is_empty, unnecessary_this, avoid_function_literals_in_foreach_calls, unused_import, slash_for_doc_comments
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:card_swiper/card_swiper.dart';
import 'data/swiper_data.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

/**
 * 公告详细信息
 */

class Announcement extends StatefulWidget {
  const Announcement({Key? key}) : super(key: key);
  @override
  _AnnouncementState createState() => _AnnouncementState();
}

class _AnnouncementState extends State<Announcement> {

  Map titleMap = {};

  void initScreenUtil() {
    ScreenUtil.init(
      BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width, //屏幕宽度
          maxHeight: MediaQuery.of(context).size.height //屏幕高度
      ),
      designSize: Size(360, 690), //基于360*690dp的屏幕适配
    );
  }

  void getHomeAnnouncement() async{
    Object?  object = ModalRoute.of(context)!.settings.arguments;

    //json转String
    String string =json.encode(object);
    //String转Map
    Map map=json.decode(string);
    titleMap = map;

    print('String: $string');
    print("map: $map");
  }

  @override
  Widget build(BuildContext context) {

    initScreenUtil(); //初始化屏幕尺寸
    getHomeAnnouncement();//获取主页公告信息

    return Scaffold(
      extendBodyBehindAppBar: false, //是否将body拓展到状态栏
      //状态栏
      appBar: AppBar(
        backgroundColor: Color(0xffD7D7D7),
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back),
          color: Color(0xff222222),
        ),

        toolbarHeight: ScreenUtil().setHeight(45),
        title:  Center(
          child: Text(titleMap["title"],
            style: TextStyle(
                color: Color(0xff222222),
                fontSize: ScreenUtil().setSp(11)
            ),
          ),
        )
      ),
      body: Container(
        child: Column(
          children: [
            SizedBox(height: ScreenUtil().setHeight(20),),
            //图片
            ClipRRect(
              borderRadius: BorderRadius.circular(7),
              child:  Container(
                width: ScreenUtil().setWidth(300),
                height: ScreenUtil().setHeight(140),
                // margin: EdgeInsets.fromLTRB(20, 25, 20, 20),
                child: Image.asset("images/${titleMap["id"]}.jpg",fit: BoxFit.fill,),
              ),
            ),
            SizedBox(height: ScreenUtil().setHeight(20),),
            //内容
            Container(
              alignment: Alignment.topLeft,
              width: MediaQuery.of(context).size.width,
              height: ScreenUtil().setHeight(140),
              padding: EdgeInsets.all(ScreenUtil().setSp(10)),
              child: Text("    ${titleMap["contents"]}",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: ScreenUtil().setSp(17),
                ),
              ),
            ),
            //时间
            Container(
                alignment: Alignment.bottomRight,
                width: MediaQuery.of(context).size.width,
                height: ScreenUtil().setHeight(60),
                padding: EdgeInsets.all(ScreenUtil().setSp(20)),
                child: Text(titleMap["createTime"],
                  style: TextStyle(
                    color: Colors.redAccent,
                    fontSize: ScreenUtil().setSp(16),
                  ),
                )
            )

          ],
        ),
      ),
    );
  }
}
