// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers, slash_for_doc_comments, prefer_const_literals_to_create_immutables, sized_box_for_whitespace, unnecessary_null_comparison, prefer_final_fields, unused_import, unnecessary_brace_in_string_interps

import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:date_format/date_format.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'figure_login_setting.dart';
import 'figure.dart';
import 'package:get_storage/get_storage.dart';
import 'dart:convert';
import 'dart:io';

class MyCenter extends StatefulWidget {
  const MyCenter({Key? key}) : super(key: key);

  @override
  _MyCenterState createState() => _MyCenterState();
}

class _MyCenterState extends State<MyCenter> {

  initScreenUtil() {
    ScreenUtil.init(
      BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width, //屏幕宽度
          maxHeight: MediaQuery.of(context).size.height //屏幕高度
      ),
      designSize: Size(360, 690), //基于360*690dp的屏幕适配
    );
  }

  @override
  Widget build(BuildContext context) {
    initScreenUtil();

    return Scaffold(
      resizeToAvoidBottomInset: false,//防止被键盘顶起布局(调整大小以避免底部插入)
      extendBodyBehindAppBar: false, //是否将body拓展到状态栏
      appBar: AppBar(
        backgroundColor: Color(0xffD7D7D7),
        elevation: 0,
        automaticallyImplyLeading: false,
        toolbarHeight: ScreenUtil().setHeight(45),
        title: Center(
          child: Container(
            alignment: Alignment.center,
            width: MediaQuery.of(context).size.width,
            child: Row(
              children: [
                //返回
                IconButton(
                  onPressed: (){
                    Navigator.pop(context);
                  },
                  icon: Container(
                    width: ScreenUtil().setWidth(20),
                    height: ScreenUtil().setHeight(20),
                    child: Image.asset("images/icon-left.png", fit: BoxFit.fill),
                  ),
                ),

                Container(
                  child: Text("My Center",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: ScreenUtil().setSp(15)
                    ),
                  ),
                )
               ],
            ),
          ),
        ),
        titleSpacing: ScreenUtil().setWidth(-10),
      ),

      body: Container(
        color: Color(0xffF2F2F2),
        child: Column(
          children: [
            Container(
              height: ScreenUtil().setHeight(120),
              padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(20)),
              child: Row(
                children: [
                  Container(
                    width: ScreenUtil().setWidth(80),
                    height: ScreenUtil().setHeight(80),
                    decoration: BoxDecoration(
                      color: Color(0xff555555),
                      borderRadius: BorderRadius.circular(ScreenUtil().setSp(50))
                    ),
                    child: Image.asset("images/icon-mycenter.png",fit: BoxFit.fill,color: Colors.white,),
                  ),

                  Container(
                    height: ScreenUtil().setHeight(100),
                    margin: EdgeInsets.only(
                        left: ScreenUtil().setWidth(20),
                        top: ScreenUtil().setHeight(40)
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Firstname Lastname",
                          style: TextStyle(
                            fontSize: ScreenUtil().setSp(17),
                            fontWeight: FontWeight.bold
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: ScreenUtil().setHeight(20)),
                          child: Text("Rolename",
                            style: TextStyle(
                                fontSize: ScreenUtil().setSp(14),
                                fontWeight: FontWeight.w400,
                                color: Color(0xff898989)
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
            Container(
              height: ScreenUtil().setHeight(5),
              color: Color(0xffD7D7D7),
            ),

            Container(
              alignment: Alignment.topLeft,
              padding: EdgeInsets.only(
                  top: ScreenUtil().setHeight(30),
                  left: ScreenUtil().setWidth(25),
                  right: ScreenUtil().setWidth(20)
              ),
              child: Column(
                children: [
                  //Figure Login Setting
                  InkWell(
                    onTap: (){
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => FigureLoginSetting()
                      ));
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Figure Login Setting",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xff696969),
                              fontSize: ScreenUtil().setSp(15)
                          ),
                        ),

                        Icon(Icons.keyboard_arrow_right,
                          size: ScreenUtil().setSp(30),
                        )
                      ],
                    ),
                  ),
                  Container(
                    height: 2,
                    color: Color(0xffE2E2E2),
                  ),

                  //Modify Password
                  InkWell(
                    onTap: (){

                    },
                    child: Container(
                      margin: EdgeInsets.only(top: ScreenUtil().setHeight(20)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Modify Password",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xff696969),
                                fontSize: ScreenUtil().setSp(15)
                            ),
                          ),

                          Icon(Icons.keyboard_arrow_right,
                            size: ScreenUtil().setSp(30),
                          )
                        ],
                      ),
                    )
                  ),
                  Container(
                    height: 2,
                    color: Color(0xffE2E2E2),
                  ),
                ],
              ),
            ),

            //登出
            Spacer(),
            Container(
              width: MediaQuery.of(context).size.width,
              height: ScreenUtil().setHeight(50),
              margin: EdgeInsets.only(
                bottom: ScreenUtil().setHeight(50),
                left: ScreenUtil().setWidth(30),
                right: ScreenUtil().setWidth(30),
              ),
              decoration: BoxDecoration(
                  border: Border.all(
                    width: ScreenUtil().setSp(1),
                    color: Colors.black
                  ),
                  borderRadius: BorderRadius.circular(10)
              ),
              child: MaterialButton(
                onPressed: () {

                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)
                ),
                child: Text("Logout",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: ScreenUtil().setSp(15),
                      fontWeight: FontWeight.bold
                  ),
                ),
              )
            )
          ],
        ),
      ),
    );
  }
}

