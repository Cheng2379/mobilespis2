// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_unnecessary_containers, sized_box_for_whitespace, prefer_if_null_operators, prefer_is_empty, prefer_void_to_null, slash_for_doc_comments

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mobilespis2/mycenter.dart';
import 'login.dart';
import 'search.dart';
import 'register_edit_asset.dart';
import 'package:http/http.dart' as http;
import 'view_asset.dart';
import 'dart:convert';

/**
 * 显示所有资产
 */

class AssetManagement extends StatefulWidget {
  const AssetManagement({Key? key}) : super(key: key);

  @override
  _AssetManagementState createState() => _AssetManagementState();
}

class _AssetManagementState extends State<AssetManagement> {
  List asset = [];
  List assetList = [];
  bool first = true;

  initScreenUtil() {
    ScreenUtil.init(
      BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width, //屏幕宽度
          maxHeight: MediaQuery.of(context).size.height //屏幕高度
          ),
      designSize: Size(360, 690), //基于360*690dp的屏幕适配
    );
  }

  getAllAsset() async {
    var response = await http.get(Uri.parse("http://10.0.2.2:5000/api/Asset"));
    if (response.statusCode == 200) {
      setState(() {
        asset = json.decode(response.body);
        //按资产名称升序排序
        asset.sort((a, b) => a["name"]!.compareTo(b["name"]));
        asset.sublist(0, 10).forEach((element) {
          assetList.add(element);
        });
        asset.removeRange(0, 10);
        // print("排序之后：$assetList");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    initScreenUtil(); //屏幕尺寸初始化

    if (first) {
      getAllAsset();
      first = false;
    }

    return Scaffold(
      extendBodyBehindAppBar: false, //是否将body拓展到状态栏

      appBar: AppBar(
        toolbarHeight: ScreenUtil().setHeight(45),
        elevation: 0,
        backgroundColor: Color(0xffD7D7D7),
        automaticallyImplyLeading: false,
        leading: IconButton(
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Login()));
            },
            icon: Container(
              width: ScreenUtil().setWidth(15),
              height: ScreenUtil().setHeight(15),
              child: Image.asset("images/icon-left.png", fit: BoxFit.fill),
            )),
        titleSpacing: ScreenUtil().setWidth(-10),
        title: Text(
          "Asset Management",
          style:
              TextStyle(color: Colors.black, fontSize: ScreenUtil().setSp(13)),
        ),
        actions: [
          IconButton(
              onPressed: () {
                //搜索
                _search();
              },
              icon: Container(
                width: ScreenUtil().setWidth(27),
                height: ScreenUtil().setHeight(27),
                child: Image.asset(
                  "images/icon-search.png",
                  color: Colors.black,
                  fit: BoxFit.fill,
                ),
              )),
          IconButton(
              onPressed: () {
                //账户
                _asset();
              },
              icon: Container(
                width: ScreenUtil().setWidth(28),
                height: ScreenUtil().setHeight(28),
                child: Image.asset(
                  "images/icon-mycenter.png",
                  color: Colors.black,
                  fit: BoxFit.fill,
                ),
              )),
        ],
      ),

      body: Container(
        color: Color(0xffF2F2F2),
        child: Column(
          children: [
            Expanded(
                flex: 7,
                child: Container(
                  color: Color(0xffF2F2F2),
                  child: EasyRefresh(
                    //ListView
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: AlwaysScrollableScrollPhysics(),
                      itemCount: assetList.length > 0 ? assetList.length : 0,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          //跳转ViewAsset
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(
                                    builder: (BuildContext context) {
                                      return ViewAsset();
                                    },
                                    //参数
                                    settings: RouteSettings(arguments: assetList[index])
                            ));
                          },
                          child: Container(
                            height: ScreenUtil().setHeight(85),
                            color: Colors.white,
                            margin: EdgeInsets.symmetric(
                                vertical: ScreenUtil().setHeight(3)),
                            child: Stack(
                              children: [
                                //图片
                                Align(
                                  alignment: Alignment(-0.9, 0),
                                  child: Container(
                                      width: ScreenUtil().setWidth(85),
                                      height: ScreenUtil().setHeight(55),
                                      color: Color(0xffCCCCCC),
                                      child: Container(
                                        margin: EdgeInsets.all(
                                            ScreenUtil().setSp(5)),
                                        child: Image.asset(
                                            "images/${assetList[index]["assetPhotos"].length > 0 ? assetList[index]["assetPhotos"][0]["photo"] : "image_null.png"}",
                                            fit: BoxFit.fill),
                                      )),
                                ),

                                //文本
                                Align(
                                  alignment: Alignment(0.3, 0),
                                  child: Container(
                                    width: ScreenUtil().setWidth(190),
                                    height: ScreenUtil().setHeight(60),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(assetList[index]["name"],
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize:
                                                    ScreenUtil().setSp(12))),
                                        Text(assetList[index]["assetNumber"],
                                            style: TextStyle(
                                                color: Color(0xff7E7E7E),
                                                fontSize:
                                                    ScreenUtil().setSp(10))),
                                        Text(assetList[index]["category"],
                                            style: TextStyle(
                                                color: Color(0xff7E7E7E),
                                                fontSize:
                                                    ScreenUtil().setSp(10))),
                                      ],
                                    ),
                                  ),
                                ),

                                //编辑按钮
                                Align(
                                    alignment: Alignment(0.95, 0.3),
                                    child: IconButton(
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      RegisterEditAsset(),
                                                  settings: RouteSettings(
                                                      arguments:
                                                          assetList[index])));
                                        },
                                        icon: Container(
                                          width: ScreenUtil().setWidth(27),
                                          height: ScreenUtil().setHeight(23),
                                          child: Image.asset(
                                              "images/icon-edit.png",
                                              fit: BoxFit.fill),
                                        ))),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                    //头部刷新
                    header: TaurusHeader(),
                    //刷新数据
                    onRefresh: () async {
                      await Future.delayed(Duration(seconds: 1), () {
                        setState(() {
                          getAllAsset();
                        });
                      });
                    },
                    //底部加载
                    footer: TaurusFooter(),
                    //加载数据
                    onLoad: () async {
                      await Future.delayed(Duration(seconds: 1), () {
                        setState(() {
                          if (asset.length > 7) {
                            asset.sublist(0, 7).forEach((element) {
                              assetList.add(element);
                            });
                            asset.removeRange(0, 7);
                          } else {
                            if (asset.length > 0) {
                              asset.sublist(0, asset.length).forEach((element) {
                                assetList.add(element);
                              });
                              asset.removeRange(0, asset.length);
                            } else {
                              print('剩余: ${assetList.length}');
                              Fluttertoast.showToast(
                                  msg: "所有资产已加载完毕",
                                  backgroundColor: Color(0xffAAAAAA),
                                  gravity: ToastGravity.BOTTOM);
                            }
                          }
                        });
                      });
                    },
                  ),
                )),
            Expanded(
                flex: 1,
                child: Container(
                    alignment: Alignment.centerRight,
                    height: ScreenUtil().setHeight(70),
                    margin: EdgeInsets.only(right: ScreenUtil().setWidth(20)),
                    child: Container(
                      width: ScreenUtil().setWidth(50),
                      height: ScreenUtil().setHeight(50),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(100),
                          border:
                              Border.all(width: 2, color: Color(0xff8A8A8A))),
                      child: MaterialButton(
                          onPressed: () {
                            _add();
                          },
                          color: Color(0xffF2F2F2),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(100)),
                          child: Icon(
                            Icons.add,
                            size: ScreenUtil().setSp(22),
                          )),
                    ))),
          ],
        ),
      ),
    );
  }

  //搜索
  void _search() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => SearchAsset()));
  }

  //账户
  void _asset() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => MyCenter()));
  }

  //注册
  void _add() {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => RegisterEditAsset(),
        ));
  }
}
