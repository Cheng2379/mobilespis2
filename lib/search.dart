// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers, slash_for_doc_comments, prefer_const_literals_to_create_immutables, sized_box_for_whitespace, unnecessary_null_comparison, prefer_final_fields, unused_import, unnecessary_brace_in_string_interps

import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:date_format/date_format.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

class SearchAsset extends StatefulWidget {
  const SearchAsset({Key? key}) : super(key: key);

  @override
  _SearchAssetState createState() => _SearchAssetState();
}

class _SearchAssetState extends State<SearchAsset> {
  final FocusNode searchNode = FocusNode();
  var _searchText = TextEditingController();

  String text = "";
  String category = "";
  String number = "";
  String assetName = "";

  int assetNameIndex = 0;
  int categoryIndex = 0;
  int numberIndex = 0;

  List asset = [];

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
  void initState() {
    super.initState();
    getSearchText();
    getAsset();
  }

  getSearchText() async {
    //监听输入文本
    _searchText.addListener(() {
      setState(() {
        text = _searchText.text;
        if (text.isNotEmpty) {
          print('输入框：$text');
          getAsset();
        } else {
          asset = [];
          print('输入框：空');
        }
      });
    });
  }

  getAsset() async {
    var response =
        await http.get(Uri.parse("http://10.0.2.2:5000/api/Asset/vague/$text"));
    setState(() {
      if (response.statusCode == 200) {
        asset = json.decode(response.body);
        // print('asset: $asset');
      } else {
        asset = [];
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    initScreenUtil();

    return Scaffold(
        resizeToAvoidBottomInset: false,
        extendBodyBehindAppBar: false,
        appBar: AppBar(
            elevation: 0,
            automaticallyImplyLeading: false,
            toolbarHeight: ScreenUtil().setHeight(45),
            backgroundColor: Color(0xffD7D7D7),
            titleSpacing: 0,
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
                        child: Image.asset("images/icon-left.png",
                            fit: BoxFit.fill),
                      ),
                    ),

                    //搜索框
                    Container(
                      alignment: Alignment.center,
                      width: ScreenUtil().setWidth(290),
                      height: ScreenUtil().setHeight(30),
                      margin: EdgeInsets.only(
                          left: ScreenUtil().setWidth(8),
                          top: ScreenUtil().setHeight(20),
                          bottom: ScreenUtil().setHeight(15)),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(
                              Radius.circular(ScreenUtil().setSp(20)))),
                      child: TextField(
                        controller: _searchText,
                        focusNode: searchNode,
                        enableInteractiveSelection: false,
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.fromLTRB(10, 0, 0, 10),
                            isDense: false,
                            border: InputBorder.none,
                            hintText: "Search Asset",
                            filled: true),
                      ),
                    )
                  ],
                ),
              ),
            )),
        body: GestureDetector(
          behavior: HitTestBehavior.translucent,
          //清除焦点
          onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
          child: Container(
              color: Color(0xffF2F2F2),
              child: Column(
                children: [
                  Visibility(
                    child: Container(
                      height: ScreenUtil().setHeight(550),
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: asset.length,
                        itemBuilder: (context, index) {
                          assetName = asset[index]['name'];
                          category = asset[index]['category'];
                          number = asset[index]['assetNumber'];

                          assetNameIndex = assetName.indexOf(text);
                          categoryIndex = category.indexOf(text);
                          numberIndex = number.indexOf(text);

                          return Container(
                            height: ScreenUtil().setHeight(100),
                            margin: EdgeInsets.only(
                                bottom: ScreenUtil().setHeight(10)),
                            color: Colors.white,
                            child: Row(
                              children: [
                                //照片
                                Container(
                                  width: ScreenUtil().setWidth(100),
                                  height: ScreenUtil().setHeight(70),
                                  color: Color(0xffCCCCCC),
                                  padding:
                                      EdgeInsets.all(ScreenUtil().setSp(5)),
                                  margin: EdgeInsets.only(
                                      left: ScreenUtil().setWidth(10)),
                                  child: Image.asset(
                                      "images/${asset[index]['assetPhotos'].length > 0 ? asset[index]['assetPhotos'][0]['photo'] : "image_null.png"}",
                                      fit: BoxFit.fill),
                                ),

                                //类别，名字，金额
                                Container(
                                  margin: EdgeInsets.only(
                                      left: ScreenUtil().setWidth(10),
                                      top: ScreenUtil().setHeight(20)),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      //资产名字
                                      Container(
                                          child: Text.rich(
                                        TextSpan(children: [
                                          TextSpan(
                                            text: assetNameIndex >= 0
                                                ? assetName.substring(
                                                    0, assetNameIndex)
                                                : assetName,
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize:
                                                    ScreenUtil().setSp(13)),
                                          ),
                                          TextSpan(
                                            text:
                                                assetNameIndex >= 0 ? text : "",
                                            style: TextStyle(
                                                color: Color(0xffBB7922),
                                                fontSize:
                                                    ScreenUtil().setSp(13)),
                                          ),
                                          TextSpan(
                                            text: assetNameIndex >= 0
                                                ? assetName.substring(
                                                    assetNameIndex +
                                                        text.length,
                                                    assetName.length)
                                                : "",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize:
                                                    ScreenUtil().setSp(13)),
                                          ),
                                        ]),
                                      )),

                                      //编号
                                      Container(
                                          child: Text.rich(TextSpan(children: [
                                        TextSpan(
                                          text: numberIndex >= 0
                                              ? number.substring(0, numberIndex)
                                              : number,
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: ScreenUtil().setSp(13)),
                                        ),
                                        TextSpan(
                                          text: numberIndex >= 0 ? text : "",
                                          style: TextStyle(
                                              color: Color(0xffBB7922),
                                              fontSize: ScreenUtil().setSp(13)),
                                        ),
                                        TextSpan(
                                          text: numberIndex >= 0
                                              ? number.substring(
                                                  numberIndex + text.length,
                                                  number.length)
                                              : "",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: ScreenUtil().setSp(13)),
                                        ),
                                      ]))),

                                      //类别
                                      Container(
                                          child: Text.rich(TextSpan(children: [
                                        TextSpan(
                                          text: categoryIndex >= 0
                                              ? category.substring(
                                                  0, categoryIndex)
                                              : category,
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: ScreenUtil().setSp(13)),
                                        ),
                                        TextSpan(
                                          text: categoryIndex >= 0 ? text : "",
                                          style: TextStyle(
                                              color: Color(0xffBB7922),
                                              fontSize: ScreenUtil().setSp(13)),
                                        ),
                                        TextSpan(
                                          text: categoryIndex >= 0
                                              ? category.substring(
                                                  categoryIndex + text.length,
                                                  category.length)
                                              : "",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: ScreenUtil().setSp(13)),
                                        ),
                                      ]))),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    visible: asset.isNotEmpty ? true : false,
                  ),
                  Visibility(
                    child: Center(
                      child: Text(
                        "暂无资产信息",
                        style: TextStyle(
                            fontSize: ScreenUtil().setSp(20),
                            color: Colors.black),
                      ),
                    ),
                    visible: asset.isEmpty ? true : false,
                  ),
                ],
              )),
        ));
  }
}
