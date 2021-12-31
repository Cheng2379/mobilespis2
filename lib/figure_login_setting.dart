// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers, slash_for_doc_comments, prefer_const_literals_to_create_immutables, sized_box_for_whitespace, unnecessary_null_comparison, prefer_final_fields, unused_import, unnecessary_brace_in_string_interps

import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:date_format/date_format.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_storage/get_storage.dart';
import 'package:get_storage/get_storage.dart';
import 'figure.dart';
import 'dart:convert';
import 'dart:io';

/**
 * 设置手势密码
 */

class FigureLoginSetting extends StatefulWidget {
  const FigureLoginSetting({Key? key}) : super(key: key);

  @override
  _FigureLoginSettingState createState() => _FigureLoginSettingState();
}

class _FigureLoginSettingState extends State<FigureLoginSetting> {
  final box = GetStorage();
  var _passwordText = TextEditingController();
  FocusNode _passFocusNode = FocusNode();

  initScreenUtil() {
    ScreenUtil.init(
      BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width, //屏幕宽度
          maxHeight: MediaQuery.of(context).size.height //屏幕高度
      ),
      designSize: Size(360, 690), //基于360*690dp的屏幕适配
    );
  }

  initGetStorage() async{
    await GetStorage.init();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print('read: ${box.read('open')}');
  }

  @override
  Widget build(BuildContext context) {
    initScreenUtil();
    initGetStorage();

    return Scaffold(
        resizeToAvoidBottomInset: false, //防止被键盘顶起布局(调整大小以避免底部插入)
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
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Container(
                      width: ScreenUtil().setWidth(20),
                      height: ScreenUtil().setHeight(20),
                      child:
                          Image.asset("images/icon-left.png", fit: BoxFit.fill),
                    ),
                  ),

                  Container(
                    child: Text(
                      "Figure Login Setting",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: ScreenUtil().setSp(15)),
                    ),
                  )
                ],
              ),
            ),
          ),
          titleSpacing: ScreenUtil().setWidth(-10),
        ),
        body: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
          child: Container(
            color: Color(0xffF2F2F2),
            padding: EdgeInsets.only(
                left: ScreenUtil().setWidth(20),
                top: ScreenUtil().setHeight(20)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //Figure Login
                Container(
                  child: Row(
                    children: [
                      //单选按钮
                      Switch(
                        value: box.read("open") ?? false,
                        onChanged: (data) {
                          setState(() {
                            box.write("open", data);
                          });
                          print('开关: $data');
                        },
                        activeTrackColor: Colors.black,
                        activeColor: Colors.white,
                      ),
                      Text(
                        "Figure Login",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: ScreenUtil().setSp(15),
                            color: Color(0xff5D5D5D)),
                      )
                    ],
                  ),
                ),

                //password
                Container(
                  margin: EdgeInsets.only(
                      top: ScreenUtil().setHeight(30),
                      left: ScreenUtil().setWidth(10)),
                  child: Text(
                    "Please input your login password",
                    style: TextStyle(
                        color: Color(0xff7E7E7E),
                        fontSize: ScreenUtil().setSp(13)),
                  ),
                ),

                //TextField / NextButton
                Container(
                  height: ScreenUtil().setHeight(50),
                  padding: EdgeInsets.only(
                    left: ScreenUtil().setWidth(10),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: ScreenUtil().setWidth(210),
                        child: TextField(
                          autofocus: false,
                          controller: _passwordText,
                          focusNode: _passFocusNode,
                        ),
                      ),
                      Container(
                        width: ScreenUtil().setWidth(80),
                        height: ScreenUtil().setHeight(35),
                        margin:
                            EdgeInsets.only(left: ScreenUtil().setWidth(20)),
                        decoration: BoxDecoration(
                            border: Border.all(width: 1, color: Colors.black),
                            borderRadius: BorderRadius.circular(10)),
                        child: MaterialButton(
                          onPressed: () {
                            _nextButton();
                          },
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          child: Text(
                            "Next",
                            style: TextStyle(
                                fontSize: ScreenUtil().setSp(14),
                                color: Colors.black),
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ));
  }

  //Next
  _nextButton() {
    if (box.read("open")==true) {
      String password = _passwordText.text;
      print('开关已打开');
      if(password == ""){
        Fluttertoast.showToast(msg: "请输入密码！");
      }else if(password != box.read("password")){
        Fluttertoast.showToast(msg: "登录密码错误,请重新输入！");
      } else{
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => Figure()
        ));
      }
    } else {
      print('开关已关闭');
      Fluttertoast.showToast(msg: "请打开手势密码开关");
    }
  }
}
