// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers, slash_for_doc_comments, prefer_const_literals_to_create_immutables, sized_box_for_whitespace, unnecessary_null_comparison, prefer_final_fields, unused_import, unnecessary_brace_in_string_interps

import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gesture_password_widget/gesture_password_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:date_format/date_format.dart';
import 'package:get_storage/get_storage.dart';
import 'package:list_ext/list_ext.dart';
import 'package:get_storage/get_storage.dart';
import 'asset_management.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:convert';

/**
 * 手势密码登录
 */

class FigureLogin extends StatefulWidget {
  const FigureLogin({Key? key}) : super(key: key);

  @override
  _FigureLoginState createState() => _FigureLoginState();
}

class _FigureLoginState extends State<FigureLogin> {
  final box = GetStorage();

  List list = [];

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
  Widget build(BuildContext context) {
    initScreenUtil();
    initGetStorage();//初始化存储驱动程序

    return Scaffold(
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
                    child: Text("Figure Login Setting",
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
        alignment: Alignment.center,
        color: Color(0xffF2F2F2),
        child: GesturePasswordWidget(
          //默认线条颜色
          lineColor: Colors.black,
          lineWidth: ScreenUtil().setSp(3),
          size: 350.0,
          minLength: 4,
          singleLineCount: 3,
          hitShowMilliseconds: 50,
          //错误圆点
          // errorItem: Container(
          //   width: 70.0,
          //   height: 70.0,
          //   decoration: BoxDecoration(
          //     color: Colors.white,
          //     border: Border.all(
          //         width: 1,
          //         color: Colors.redAccent
          //     ),
          //     borderRadius: BorderRadius.circular(50.0),
          //   ),
          //   padding: EdgeInsets.all(17.0),
          //   child: Container(
          //     width: 15.0,
          //     height: 15.0,
          //     decoration: BoxDecoration(
          //       color: Colors.redAccent,
          //       borderRadius: BorderRadius.circular(50.0),
          //     ),
          //   ),
          // ),
          //默认原点
          normalItem: Container(
            width: 70.0,
            height: 70.0,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                  width: 1,
                  color: Color(0xff555555)
              ),
              borderRadius: BorderRadius.circular(50.0),
            ),
            padding: EdgeInsets.all(17.0),
            child: Container(
              width: 15.0,
              height: 15.0,
              decoration: BoxDecoration(
                color: Color(0xff555555),
                borderRadius: BorderRadius.circular(50.0),
              ),
            ),
          ),
          //选中圆点
          selectedItem: Container(
            width: 70.0,
            height: 70.0,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                  width: 1,
                  color: Color(0xff555555)
              ),
              borderRadius: BorderRadius.circular(50.0),
            ),
            padding: EdgeInsets.all(17.0),
            child: Container(
              width: 15.0,
              height: 15.0,
              decoration: BoxDecoration(
                color: Color(0xff555555),
                borderRadius: BorderRadius.circular(50.0),
              ),
            ),
          ),
          hitItem: Container(
            width: 70.0,
            height: 70.0,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                  width: 1,
                  color: Color(0xff555555)
              ),
              borderRadius: BorderRadius.circular(50.0),
            ),
            padding: EdgeInsets.all(17.0),
            child: Container(
              width: 15.0,
              height: 15.0,
              decoration: BoxDecoration(
                color: Color(0xff555555),
                borderRadius: BorderRadius.circular(50.0),
              ),
            ),
          ),
          color: Color(0xffF2F2F2),
          onComplete: (data) {
            print('data: $data');
            list = box.read("figure_password");
            print("密码：$list");
            if(list.containsAll(data)){
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => AssetManagement()
              ));
            }else{
              Fluttertoast.showToast(msg: "密码错误！请重新输入！");
            }
            // if(list.isEmpty){
            //   list.addAll(data);
            //   print('list: $list');
            //   data.forEach((element) {
            //     list.add(element);
            //   });
            //   Fluttertoast.showToast(msg: "请再次输入密码");
            // }else{
            //   print('list: $list');
            //   if(list.length != data.length){
            //     print('输入密码：${data}');
            //     print('手势密码：${list}');
            //     //输入一致
            //     if(list.containsAll(data)){
            //       Fluttertoast.showToast(msg: "登录成功！");
            //       Navigator.pop(context);
            //     }else{
            //       Fluttertoast.showToast(msg: "两次密码不一致，请重新输入");
            //     }
            //   }else{
            //     Fluttertoast.showToast(msg: "两次密码不一致，请重新输入");
            //   }
            // }

          },
        ),
      )
    );
  }
}
