// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers, prefer_const_literals_to_create_immutables, sized_box_for_whitespace, unnecessary_new, prefer_final_fields, slash_for_doc_comments

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:date_format/date_format.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_storage/get_storage.dart';
import 'asset_management.dart';
import 'figure_login.dart';

/**
 * 登录
 */

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final box = GetStorage();

  String good = "";

  var telephone = TextEditingController();
  FocusNode telephoneNode = FocusNode();
  var passWord = TextEditingController();
  FocusNode passWordNode = FocusNode();

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

  getNowTime() {
    DateTime now = new DateTime.now();
    String nowTime = formatDate(now, [HH]);
    int time = int.parse(nowTime);
    // print("当前时间：$now");
    // print("格式转换： $time");
    if (time >= 6 && time < 12) {
      good = "Good Morning";
    } else if (time >= 12 && time < 18) {
      good = "Good Afternoon";
    } else if (time >= 18 || time < 6) {
      good = "Good Evening";
    }
    // print("good $good");
  }

  @override
  Widget build(BuildContext context) {
    initScreenUtil(); //屏幕
    getNowTime(); //获取当前时间

    return Scaffold(
      resizeToAvoidBottomInset: false,//防止被键盘顶起布局(调整大小以避免底部插入)
      extendBodyBehindAppBar: false, //是否将body拓展到状态栏
      appBar: AppBar(toolbarHeight: 0, elevation: 0, backgroundColor: Colors.white),
      backgroundColor: Color(0xffF2F2F2),

      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: ()  => FocusScope.of(context).requestFocus(FocusNode()),
        child: Container(
          child: Column(
            children: [
              //LOGO
              Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.symmetric(vertical: ScreenUtil().setHeight(30)),
                  child: Container(
                      alignment: Alignment.center,
                      width: ScreenUtil().setWidth(80),
                      height: ScreenUtil().setHeight(80),
                      decoration: BoxDecoration(
                          color: Color(0xffAAAAAA),
                          borderRadius: BorderRadius.all(Radius.circular(10)
                          )
                      ),
                      child: Text("LOGO",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: ScreenUtil().setSp(15))
                      )
                  )
              ),

              //Good
              Container(
                alignment: Alignment.centerLeft,
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(50)),
                child: Text(good,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: ScreenUtil().setSp(18),
                      fontWeight: FontWeight.w500
                  ),
                ),
              ),

              //Please login into the system
              Container(
                alignment: Alignment.centerLeft,
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.symmetric(
                    horizontal: ScreenUtil().setWidth(50),
                    vertical: ScreenUtil().setHeight(15)
                ),
                child: Text("Please login into the system",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: ScreenUtil().setSp(16),
                      fontWeight: FontWeight.w500
                  ),
                ),
              ),

              //Telephone
              Container(
                alignment: Alignment.centerLeft,
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.only(
                  left: ScreenUtil().setWidth(50),
                  right: ScreenUtil().setWidth(50),
                  top: ScreenUtil().setHeight(30),
                ),
                child: Text("Telephone",
                  style: TextStyle(
                      color: Color(0xff555555),
                      fontSize: ScreenUtil().setSp(16),
                      fontWeight: FontWeight.w500
                  ),
                ),
              ),

              //TextField
              Container(
                alignment: Alignment.centerLeft,
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.only(
                    left: ScreenUtil().setWidth(50),
                    right: ScreenUtil().setWidth(50),
                    bottom: ScreenUtil().setHeight(20)
                ),
                child: TextField(
                  controller: telephone,
                  focusNode: telephoneNode,
                  keyboardType: TextInputType.phone,
                ),
              ),

              //Password
              Container(
                alignment: Alignment.centerLeft,
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.only(
                  left: ScreenUtil().setWidth(50),
                  right: ScreenUtil().setWidth(50),
                ),
                child: Text("Password",
                  style: TextStyle(
                      color: Color(0xff555555),
                      fontSize: ScreenUtil().setSp(16),
                      fontWeight: FontWeight.w500
                  ),
                ),
              ),

              //TextField
              Container(
                alignment: Alignment.centerLeft,
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.only(
                    left: ScreenUtil().setWidth(50),
                    right: ScreenUtil().setWidth(50),
                    bottom: ScreenUtil().setHeight(20)
                ),
                child: TextField(
                  controller: passWord,
                  focusNode: passWordNode,
                  obscureText: true,//隐藏密码
                  scrollPadding: EdgeInsets.only(left: ScreenUtil().setWidth(5)),
                  scrollPhysics: ScrollPhysics(),
                  style: TextStyle(
                      fontSize: ScreenUtil().setSp(15)
                  ),
                ),
              ),

              //LoginButton
              Container(
                width: MediaQuery.of(context).size.width,
                height: ScreenUtil().setHeight(42),
                margin: EdgeInsets.only(
                  top: ScreenUtil().setHeight(30),
                  left: ScreenUtil().setWidth(50),
                  right: ScreenUtil().setWidth(50),
                ),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(width: 1,color: Color(0xffA0A0A0))
                ),

                child: MaterialButton(
                  onPressed: () {
                    _login();
                  },
                  color: Color(0xffF2F2F2),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)
                  ),
                  child: Text("Login",
                    style: TextStyle(color: Colors.black, fontSize: ScreenUtil().setSp(13)),
                  ),
                ),
              ),

              //Figure Login
              Container(
                  alignment: Alignment.bottomRight,
                  margin: EdgeInsets.symmetric(
                      vertical: ScreenUtil().setHeight(50),
                      horizontal: ScreenUtil().setWidth(25)
                  ),
                  child: InkWell(
                    onTap: (){
                      if(box.read("ok")==true){
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => FigureLogin()
                        ));
                      }else{
                        Fluttertoast.showToast(msg: "暂未设置手势密码，请设置手势密码");
                      }
                    },
                    child: Text("Figure Login",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: ScreenUtil().setSp(12),
                          fontWeight: FontWeight.w400
                      ),
                    ),
                  )
              )
            ],
          ),
        ),
      )
    );
  }

  //登录
  void _login() {
    //获取Telephone输入文本
    String telephoneText =  telephone.text;
    //获取Password文本
    String passWordText = passWord.text;

    if(telephoneText == ""){
        Fluttertoast.showToast(
            msg: "Telephone can't Null!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 2,
            backgroundColor: Color(0xffAAAAAA),
            textColor: Colors.white,
            fontSize: ScreenUtil().setSp(15)
      );
    }else if(passWordText == ""){
      Fluttertoast.showToast(
          msg: "Password can't Null!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 2,
          backgroundColor: Color(0xffAAAAAA),
          textColor: Colors.white,
          fontSize: ScreenUtil().setSp(15)
      );
    }else {
      //登录
      box.write("phone", telephoneText);
      box.write("password", passWordText);

      Navigator.push(context, MaterialPageRoute(
        builder: (context) => AssetManagement(),
      ));
    }
  }


}


